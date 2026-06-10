# トラブルシューティング / 落とし穴

## アクセス制御まわり
- **「特定の人だけ」がマニフェストで指定できない**: GAS の `access` は DOMAIN/ANYONE/MYSELF の 3 択。個人指定は doGet 内の allowlist で行う (テンプレ済)。
- **`GroupsApp.getGroupByEmail(...).hasUser()` が例外を投げる**: 実行者がそのグループを参照する権限を持たないと失敗する。`try/catch` で次のグループにフォールバックし、`ALLOWED_USERS` (個人メール) を併用しておく (テンプレ済)。グループ判定に頼り切らない。
- **`Session.getActiveUser().getEmail()` が空**: access が `ANYONE`(匿名許可) だと匿名アクセスでメールが取れない。`DOMAIN` なら必ずログイン済みなのでアクセス者のメールが取れる。範囲限定では DOMAIN 必須。
- **なりすまし**: `getActiveUser()` は Google 認証済みの本人を返すのでクライアント改ざん不可。allowlist 判定は信頼できる。

## iframe サンドボックス / リンク
- **ページ間リンクが効かない / 真っ白**: GAS は iframe 内配信なので相対パスが届かない。実行時の `ScriptApp.getService().getUrl()` で絶対 URL を作り `target="_top"` を付ける。HTML に `__P_<KEY>__` プレースホルダを埋め、doGet で置換する (テンプレ済)。
- **内部アンカー (#section) が親フレームに飛んで壊れる**: `<base target="_top">` を入れているのが原因。base target は入れず、ページ間リンクにだけ個別に `target="_top"` を付ける。
- **マルチページの相対リンク**: ビルド時に `href="page1/index.html"` のような相対リンクを、deploy スクリプトの sed で `href="__P_PAGE1__" target="_top"` に置換しておく (deploy.just 参照)。

## デプロイ / 反映
- **URL が毎回変わる**: `clasp deploy` を都度打つと新規 deployment ができて URL が変わる。`clasp redeploy <deploymentId>` で固定の deployment を更新する。
- **古い版が出る (キャッシュ)**: redeploy 後も数十秒〜古い版が出ることがある。URL 再読み込み or 別タブ。投影直前に開いておく。
- **読み込みラグ**: GAS Web アプリはリダイレクトで数秒のラグが出る。リアルタイム性が要る用途には向かない。
- **`appsscript.json` が上書きされた**: `clasp create`/`push` がデフォルトのマニフェストで上書きすることがある。access: DOMAIN の版を git で管理して戻す。

## 共有通知
- **意図せず招待メールが飛んだ**: Drive の明示共有 (共有ダイアログ / `addEditor`) を使うと通知が飛ぶ。この方式は **access 制御 + doGet allowlist だけ**で限定するので、Drive 共有は一切使わないこと。それで通知ゼロのまま限定できる。

## セキュリティ衛生
- `.clasp.json` (scriptId)、生成された `scripts/gas/*.html` (dist コピー) は **gitignore**。
- allowlist の個人メール・グループ・deploymentId を公開リポジトリにベタ書きしない (別ファイル/環境変数に分離、または非公開リポジトリ)。
