---
name: gas-restricted-share
description: >-
  静的 HTML / 単一ファイルのサイトを、Google アカウント認証で範囲限定 (組織ドメイン + 個人メール/Google グループの allowlist) して Google Apps Script (GAS) Web Apps で共有する。サーバ不要・無料・共有通知メールが飛ばない・URL を変えずに中身を更新できる。
  社内・チーム限定で資料/ダッシュボード/レポート/ツールを Web で配りたい、特定の人だけに見せたい、でも Drive 共有の招待通知は飛ばしたくない、ホスティングは立てたくない、というときは必ずこの skill を使う。exec-deck の配信層にも使う。
  使わない場面: 一般公開 (ANYONE) してよい静的サイト (Pages/Vercel 等の方が速い)、Google Workspace 組織がない場合、動的な永続データストアが要るアプリ。
---

# gas-restricted-share — GAS Web Apps で範囲限定共有

立派な資料やツールを作っても「サーバを立てずに、社内の特定メンバーだけに、招待通知を飛ばさず Web で見せたい」は意外と手段がない。GAS Web Apps はこれを**サーバ不要・無料・標準認証**で満たす。この skill はその定型 (アクセス制御・デプロイ・サンドボックス対策) をテンプレ化する。

雛形は `assets/Code.gs.template` / `assets/appsscript.json.template` / `assets/deploy.just` をコピーして、プレースホルダ (ドメイン・allowlist・ルート・scriptId) を埋める。

## アクセス制御の本質 — なぜ二段構えか

GAS Web Apps の `access` は **`DOMAIN` / `ANYONE` / `MYSELF` の 3 択しかなく、「特定の人だけ」をマニフェストでは指定できない**。そこで二段構えにする:

1. **`appsscript.json` の `webapp.access: "DOMAIN"`** — まず GAS レベルで組織ドメイン内に遮断 (社外を弾く)。
2. **`doGet` 内の allowlist 判定** — `Session.getActiveUser().getEmail()` でアクセス者を取り、個人メール + Google グループの許可リストと照合して更に絞る。

`Session.getActiveUser()` は**アクセスした本人**を返す (なりすませない — Google ログイン必須)。だから allowlist はクライアント改ざん不可で信頼できる。

テスト→本番切り替えの手順は `references/setup.md` 参照。

## 通知なし共有 — なぜ招待が飛ばないか

Drive の明示共有 (`addEditor` / 共有ダイアログ) を**一切使わず**、`access` 制御 + doGet allowlist だけで限定する。Drive 共有を使わないので**共有通知メールが飛ばない**。「関係者にこっそり配る」「URL を知っていて allowlist に居る人だけ見られる」が実現できる。clasp の push/deploy でも通知は出ない。

## デプロイ — URL を変えずに更新

- 初回 `clasp deploy` で Web アプリ URL (`https://script.google.com/a/macros/<domain>/s/<id>/exec`) が発行される。
- 2 回目以降は **`clasp redeploy <deploymentId>`** で同じ deployment を更新 → **URL 不変のまま中身だけ差し替わる**。共有済み URL が生き続ける。
- 配信フローは `assets/deploy.just` の通り: ビルド → `dist` を `scripts/gas/` にコピー → ページ間リンクのプレースホルダを sed 置換 → `clasp push -f` → `clasp redeploy`。
- セットアップ (clasp login / create / scriptId / deploymentId 固定) は `references/setup.md`。

## マルチページとサンドボックス対策

GAS Web アプリは **iframe サンドボックス内**で配信される。これが 2 つの落とし穴を生む:

1. **ページ間リンクは相対パスでは届かない**。1 つの doGet から複数 HTML を出し分けるには `?p=<name>` でルーティングし、リンクは**実行時に `ScriptApp.getService().getUrl()` で得た絶対 URL + `target="_top"`** に置換する。HTML 側には `__P_FOO__` のようなプレースホルダを埋めておき、doGet で `.replace(/__P_FOO__/g, base + '?p=foo')` する (テンプレ参照)。
2. **内部アンカー (`#section` 等) には `<base target="_top">` を入れない**。入れると同一ページ内ジャンプが親フレームに飛んで壊れる。ページ間リンクだけ個別に `target="_top"` を付ける。

単一ページだけなら `?p` ルーターは不要 (doGet が 1 ファイルを返すだけ)。

## セキュリティの注意
- **scriptId / deploymentId はローカル固有**。`.clasp.json` は gitignore する。公開リポジトリに deploymentId をベタ書きしない。
- allowlist の個人メール・グループは組織固有情報。公開リポジトリに置くなら別ファイル/環境変数に分離する。
- `GroupsApp.getGroupByEmail(...).hasUser()` は**実行者がそのグループを参照できる**必要がある。参照できない場合に備え `try/catch` で次のグループへフォールバックし、個人メール allowlist を併用する (テンプレ実装済)。
- 生成された `scripts/gas/*.html` (dist のコピー) は生成物なので gitignore する。

## アンチパターン
- `access: "ANYONE"` で機密情報を出す (DOMAIN + allowlist にする)
- Drive 明示共有を併用して意図せず招待通知を飛ばす (access 制御だけで足りる)
- 毎回 `clasp deploy` で URL が変わる (`redeploy <id>` で固定; 詳細は troubleshooting.md)
- iframe 内でページ間リンクを相対パスのまま置く (getUrl 絶対 URL + target=_top に置換)
- 内部アンカーまで `target="_top"` にして同一ページジャンプを壊す
- scriptId / allowlist を公開リポジトリにベタ書き
