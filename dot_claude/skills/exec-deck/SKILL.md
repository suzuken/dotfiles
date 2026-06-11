---
name: exec-deck
description: >-
  経営層・意思決定者向けの情報密度の高い HTML 資料 (経営会議/合宿/役員提案/戦略ドキュメント/投影用 1 ページ資料) を、parts 分割 + build script のパイプラインで作る。投影・配布・PDF を単一 HTML ファイルで兼ね、PPTX を経由しない。
  経営資料・ボード資料・役員プレゼン・意思決定ドキュメント・社内戦略資料・合宿資料を「作る/構成する/作り替える」ときは、ユーザーが "deck" や "HTML" と明示しなくても必ずこの skill を使う。特に「複数セクションある」「投影もするし配布もしたい」「情報量が多い」資料で効く。
  組織ブランドのトンマナ (色・フォント) が要る場合は、この skill の上に組織のブランド skill (トンマナを定義した skill) を重ねる — この skill 自体は中立トークンで動く。
  使わない場面: PPTX/Google Slides の生成、単発の 1 枚 HTML、ブログ記事や README などの長文ドキュメント、定例の進捗報告・軽い社内共有スライド (経営レビューや意思決定を伴わないもの)。
---

# exec-deck — 経営資料の HTML パイプライン

経営層に「投影で話し、配布で読ませ、PDF で残す」資料を、1 つの HTML で作る。スライド (PPTX) を経由せず、情報密度を上げる方向に倒す。この skill は**足場 (parts 分割 + build + 検証 + レイアウト構成要素)** を提供する。何を載せるか (議論設計) は別 skill、ブランドの色・フォントも別 skill に委ねる。

## なぜこの形か

単一 HTML は初日は速いが数千行になると構造変更が大手術になる。parts 分割 + build は初日から行う可逆リファクタ。ブランド (色・フォント) は内容 8 割固まってから CSS 変数を差し替えるだけでよい。

## 構造

```
html/
  _layout/
    head.html      <!doctype>〜<body><div class="container"> + 検索バー + フォント/CSS link
    cover.html     表紙 (ヒーロー)
    toc.html       目次 (カードグリッド + 当日/予習バッジ)
    foot.html      </div></body></html> + 検索スクリプト
  parts/
    <id>.html      各セクション断片 (<section id="..."> 〜 </section>)
  style.css        全スタイル (:root のトークンで色・フォントを集中管理)
scripts/
  build-dist.js    結合 → dist/index.html (単一・CSS インライン・全文検索) + dist/pages/<id>.html (個別)
dist/              生成物 (gitignore)。配布のたびに build
```

- **編集は parts / _layout / style.css を直接さわる**。Markdown から再生成しない (HTML が正)。
- **build-dist.js の `ORDER` 配列がセクションの結合順**。新セクションは parts に足し ORDER に id を追加。
- 配布物は 2 種: `dist/index.html` (単一ファイル — 投影・配布・PDF・全文検索) と `dist/pages/<id>.html` (個別ページ — 予習・複数ページ閲覧)。

雛形は `scripts/build-dist.js` / `assets/head.html` / `assets/style.css` / `assets/foot.html` をコピーして使う。`build-dist.js` は CSS を `<link>` から `<style>` にインライン化し、見つからなければ `process.exit(1)` で止まる (壊れた配布物を作らない)。

## 初日にやること — 足場を組む

1. `html/_layout/` + `html/parts/` + `html/style.css` + `scripts/build-dist.js` を雛形から配置。`just build` (or `node scripts/build-dist.js`) が通ることを確認。
2. セクションの骨格 (ID と順序) を `ORDER` に先に並べる。中身は空 `<section>` でよい — **構造を先に決め、内容を後から流す**。
3. 意思決定資料なら、何を載せ・どう決めさせるかは `decision-deck-architecture` skill に従って設計してから parts を埋める。
4. ブランドのトンマナが要るなら、内容が固まった段階で組織のブランド skill を起動し `style.css` の `:root` トークンを差し替える。

> 一次情報 (数字・固有名詞・人物) を扱うなら `source-fact-intake` skill の規律 (確定度判定・ソース確定後に書く) を守る。会議で使うなら `meeting-run-design` skill で運営も設計する。

## レイアウト構成要素

情報密度を上げるための要素は `assets/style.css` に定義済み。カタログと使い分けは `references/components.md` を読む (table / .stats / .card / .callout / .kicker / .discussion / .diagram / .answers / .part-divider など)。原則:

- 一行で済むことを段落にしない。表で済むことをカードにしない。並列性 (3-4 個) はカードで。
- 数字は `.stats` の big-number で抜き出す。本文に埋もれさせない。
- 図は**インライン SVG**。`stroke`/`fill` は `currentColor` を基準にし、アクセントだけ変数 (`var(--accent)`) を使う (light/dark 両対応・ブランド差し替えに追従)。SVG 作図の指針は `references/svg-guide.md`。
- 強調は絞る。`<b>` やアクセント色を全文に撒くと、本当に見せたい点が埋もれる。

## 検証 — 壊れた資料を配らない

build 後、配布前に確認する (手順は `references/verification.md`):

- **オーバーフロー監査**: Playwright で全要素を `getBoundingClientRect()` し `right > innerWidth+1` を抽出。デスクトップ幅とモバイル幅 (480) の両方。テーブルがモバイルで溢れやすい。
- **ファクト残存**: 主要な数字・固有名詞・URL が build 後の dist に残っているか grep (編集で消えていないか)。
- **記法の混入**: `[[...]]` (memory リンク記法)・未レンダリングの `**markdown**` が本文に出ていないか grep。
- ダークモード (`prefers-color-scheme`) は `currentColor` + CSS 変数で自動追従するはずだが、固定色を使った箇所は目視。

## 配信

`dist/` をそのまま静的配信する (Pages / Vercel 等) か、**社内・特定メンバー限定で配るなら `gas-restricted-share` skill** (GAS Web Apps で組織ドメイン + allowlist 制御、サーバ不要・通知なし・固定 URL)。配布のたびに build → 検証 → 配信。`dist/` は生成物なので gitignore。

## アンチパターン
- 単一巨大 HTML に全部書く (分割を後回しにして終盤に大手術)
- ブランドの色・装飾を内容より先に作り込む
- 図を PNG/画像で貼る (インライン SVG にする — currentColor で追従・差分が見える)
- 検証をプロンプト遵守に頼る (build の `process.exit` と Playwright 監査に落とす)
