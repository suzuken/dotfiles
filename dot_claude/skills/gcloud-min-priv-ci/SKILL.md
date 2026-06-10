---
name: gcloud-min-priv-ci
description: >-
  GitHub Actions から GCP へ最小権限でデプロイする CI（Workload Identity 連携 +
  gcloud builds submit + gcloud run deploy）を構築・デバッグするときに使う。
  特に「forbidden from accessing the bucket」「caller does not have permission to
  act as service account」「artifactregistry.repositories.downloadArtifacts denied」
  などの gcloud 権限エラーの調査、WIF の Terraform 構成、デプロイ SA / ビルド SA の
  権限設計が対象。エラーメッセージは真因を指さないことが多いので、推測でロールを
  足す前にこの skill を読む。GCP 以外の CI/CD や、サービスアカウント鍵を使う
  レガシー構成には使わない。
---

# 最小権限 GCP CI デプロイ（WIF + Cloud Build + Cloud Run）

GitHub Actions → GCP のデプロイを SA 鍵なし・最小権限で組むときの構成テンプレートと、
gcloud の権限エラー 4 連発（実地で全部踏んだ）の対処。

## 大原則: エラーメッセージ駆動で権限を足さない

gcloud の permission エラーは**真因と別の権限を提案してくる**。2 回推測が外れたら、
ローカルにインストール済みの gcloud SDK ソースを読んで確定させるのが最短:

```sh
GCLOUD_ROOT=$(gcloud info --format="value(installation.sdk_root)")
grep -rn "<エラーメッセージの一部>" $GCLOUD_ROOT/lib --include="*.py" -l
# → 該当箇所の前後を読み、どの API 呼び出しが失敗しているか特定する
```

認証そのものの切り分けには監査ログが使える（WIF が機能していれば
`GenerateAccessToken` の成功記録が残る）:

```sh
gcloud logging read 'protoPayload.serviceName="iamcredentials.googleapis.com"' \
  --project $PROJECT --freshness 1h
```

## 落とし穴 4 つ（gcloud builds submit / run deploy）

1. **デフォルトステージングバケットの ownership 検査**
   `gcloud builds submit` はデフォルトの `{project}_cloudbuild` バケットを使うとき、
   bucket squatting 対策で `buckets.list`（**プロジェクトレベル権限**）を実行する
   （SDK の `submit_util.py` → `storage_api.py CreateBucketIfNotExists(check_ownership=True)`）。
   バケットスコープの `roles/storage.admin` では足りない。
   → **`--gcs-source-staging-dir=gs://{project}_cloudbuild/source` を明示**すると
   `check_ownership=False` になり検査ごとスキップできる。バケットスコープの
   storage.admin（`buckets.get` が要るので objectAdmin では不可）だけで済む。

2. **ビルド実行 SA の既定は Compute デフォルト SA**（2024-07 以降の新規プロジェクト）。
   投入側 SA に Compute デフォルト SA への actAs を付けると Editor 相当への昇格経路に
   なる（セキュリティレビュー必ず刺さる）。
   → **専用ビルド SA を作り、cloudbuild.yaml の `serviceAccount:` で指定**する。
   カスタムビルド SA を指定する場合は `options.logging: CLOUD_LOGGING_ONLY` が必須。
   `--tag` ワンライナーは使えなくなるので `--config cloudbuild.yaml` に移す。

3. **ログストリーミングは project Viewer が必要**。`--suppress-logs` では回避できず、
   ビルド自体が SUCCESS でも gcloud が exit 1 する。
   → **`--async` で投入して `gcloud builds describe` をポーリング**:
   ```sh
   BUILD_ID=$(gcloud builds submit --async --format='value(id)' \
     --config cloudbuild.yaml --gcs-source-staging-dir="gs://${PROJECT}_cloudbuild/source" \
     --project "$PROJECT" .)
   while :; do
     STATUS=$(gcloud builds describe "$BUILD_ID" --project $PROJECT --format='value(status)')
     case "$STATUS" in
       SUCCESS) break ;;
       PENDING|QUEUED|WORKING) sleep 10 ;;
       *) echo "build failed: $STATUS" >&2; exit 1 ;;
     esac
   done
   ```
   一般化: 「サーバ側は成功しているのにクライアントが exit 1」がありうるので、
   失敗時はまず対象リソースの実状態（describe）を確認する。

4. **`gcloud run deploy` はタグ→digest 解決で AR 読み取りを要求**する。
   投入側 SA に対象リポジトリスコープの `roles/artifactregistry.reader` が必要
   （イメージを pull する Cloud Run service agent とは別）。

5. （おまけ）GitHub Actions の runner に `gcloud beta` は入っていない。
   `setup-gcloud` に `install_components: beta` を指定しないと対話プロンプトで死ぬ。

## 権限セット（設計段階でこれを列挙してから plan する）

**deploy SA**（GitHub Actions が WIF で impersonate）:
- `roles/run.admin`（プロジェクト）
- `roles/cloudbuild.builds.editor`（プロジェクト）
- `roles/serviceusage.serviceUsageConsumer`（プロジェクト）
- `roles/storage.admin`（**ステージングバケット限定**）
- `roles/artifactregistry.reader`（**対象 AR リポジトリ限定**）
- `roles/iam.serviceAccountUser`（ビルド SA とランタイム SA への actAs）

**ビルド SA**（cloudbuild.yaml で指定）:
- `roles/artifactregistry.writer`（**対象 AR リポジトリ限定**）
- `roles/logging.logWriter`（プロジェクト。CLOUD_LOGGING_ONLY 用）
- `roles/storage.objectViewer`（**ステージングバケット限定**。ソース tarball 読み取り）

**WIF**（Terraform）:
- pool + GitHub OIDC provider。`attribute_condition` で
  `assertion.repository == "owner/repo" && assertion.ref == "refs/heads/main"` まで絞る
  （トークン交換の時点で他リポジトリ・他ブランチを拒否）
- deploy SA に `roles/iam.workloadIdentityUser` を
  `principalSet://…/attribute.repository/owner/repo` で付与
- 有効化が必要な API: `iam` / `iamcredentials` / `sts`
- GitHub 側: `permissions: id-token: write` + `google-github-actions/auth@v2` に
  provider のフルパス（`projects/{number}/locations/global/workloadIdentityPools/...`）と SA email

実装例: 各プロジェクトの Terraform（WIF pool/provider + SA + IAM binding）、
`cloudbuild.yaml`、`.github/workflows/` を参照（この skill を適用した repo に一式がある）。
