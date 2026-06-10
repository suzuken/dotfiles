# セットアップ手順 (一度だけ)

GAS Web Apps で静的サイトを範囲限定配信するための初回セットアップ。OAuth のブラウザ遷移があるので手動で踏む (Claude Code セッション内なら `! <command>` で実行するとブラウザ遷移がそのまま流れる)。

## 1. clasp を入れてログイン
```bash
npm i -g @google/clasp        # clasp 本体
clasp login                   # 配信したい組織のアカウントで OAuth (ブラウザ)
```
配信は「組織ドメイン内限定」にするので、その組織の Google アカウントでログインする。

## 2. プロジェクト構成を置く
リポジトリに GAS 用ディレクトリを作り、テンプレを配置:
```
scripts/gas/
  appsscript.json    ← assets/appsscript.json.template (access: DOMAIN)
  Code.gs            ← assets/Code.gs.template (allowlist / ルート / タイトルを埋める)
  index.html         ← dist のコピー (生成物、gitignore)
```
`Code.gs` の `ALLOWED_USERS` / `ALLOWED_GROUPS` / `ROUTES` / `APP_TITLE` を自分の値に置換する。

## 3. スタンドアロンプロジェクトを作成 (scriptId 取得)
```bash
clasp create --type webapp --title "<your-app>" --rootDir scripts/gas
# → .clasp.json (scriptId 入り) がリポジトリルートに生成される
```
- clasp が `appsscript.json` を上書きしようとしたら、こちらの版 (access: DOMAIN) を残す。
- `.clasp.json` の `rootDir` が `scripts/gas` を指しているか確認:
  ```json
  { "scriptId": "xxxxx", "rootDir": "scripts/gas" }
  ```
- **`.clasp.json` は gitignore する** (scriptId はローカル固有)。

## 4. 初回デプロイ → deploymentId を固定
```bash
clasp push -f
clasp deploy -d "initial"
# → deploymentId と Web アプリ URL が発行される
clasp deployments        # deploymentId を確認
```
この **deploymentId を `deploy.just` の `<DEPLOYMENT_ID>` に書き込む**。以降は `clasp redeploy <deploymentId>` で**同じ URL のまま中身を更新**できる。

URL は `https://script.google.com/a/macros/<domain>/s/<id>/exec` の形。これを allowlist のメンバーに共有する。

## 5. テスト → 本番の切り替え
- **テスト中**: `appsscript.json` の `access` を `"MYSELF"` にしておくとデプロイ者だけがアクセスでき、表示確認が安全。
- **本番**: `access` を `"DOMAIN"` に戻し、`Code.gs` の allowlist で更に絞る。push → redeploy。
- 社外秘なら `"ANYONE"` には**しない**。

## 毎回の配信
```bash
just deploy-gas   # build → dist を scripts/gas/ にコピー → プレースホルダ置換 → clasp push → redeploy
```
