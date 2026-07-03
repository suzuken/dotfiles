---
name: mermaid-safe-syntax
description: >-
  Mermaid 図（mermaid.js、特に 11.x 系）を作成・編集するときに使う。構文エラーで
  レンダリングが崩れる・図が表示されないトラブルの調査にも使う。表で足りる単純な
  数値比較や統計提示には Mermaid を使わず Markdown 表を優先する判断も含む。
---

# Mermaid 安全構文

mermaid@11.x でパースエラーや表示崩れを起こしやすい構文と、保守的な代替。

## 避ける構文

- **`xychart-beta`** — beta 仕様で不安定。ハイフン入り x-axis label（例 `2023-1st`）や
  `bar` + `line` 併用でパース失敗しやすい。統計・数値比較は Markdown 表の方が結局見やすい
- **`quadrantChart`・`sankey-beta`** など beta 系全般 — 同様の理由で避ける
- pie / gantt の **title・section 名にカンマや括弧**を含める
  （例: `title n=2,378` や `section 2023-1st (908 行)` は崩れることがある）
- gantt のタスク名内の特殊記号（`(...)`、全角括弧、区切りと紛らわしいコロン以外の `:`）
- **flowchart の予約語**（`end` / `default` / `subgraph` / `direction`）を
  node id・classDef 名・`:::class` 参照に使う
  （例: `classDef end fill:...` や `node:::end` は subgraph 終端と衝突して構文エラー。
  `done` / `final` / `complete` などに置き換える）
- label 内の未クォートの比較記号 `<` `>`（`<br/>` などの HTML タグは問題ない）

## 安全な書き方

- title・section 名はカンマなし・括弧なしの単純文字列にする
  （`title main コミット内訳 n=2378` / `section 2023-1st  908 行`）
- ラベルにハイフンが必要なら `flowchart` を使う（pie/gantt より寛容）
- 図種は `flowchart` / `erDiagram` / `sequenceDiagram` / `pie` を中心に選ぶ
- **`[label]` / `{label}` / `((label))` 内に括弧を含めるときは必ずダブルクォートで囲む**
  - NG: `N[テキスト (補足)]` → `PS`/`PE` token expected で構文エラー
  - OK: `N["テキスト (補足)"]`、または括弧自体を外す `N[テキスト 補足]`
  - cylinder 形状の `N[(text)]` はこれとは別構文なので問題ない
  - 同じ理由で edge label も括弧を含むならクォートする: `-->|"hit (12%)"|`
- 複数の統計値を並べて比較したいだけなら、図に固執せず Markdown 表を使う

## 検証

書いた mermaid コードは実際にレンダリングして確認する（ビルドパイプラインに
mermaid lint が組み込まれていればそれに従う）。目視だけで「たぶん大丈夫」と
判断しない。上記の禁止構文をブロックする静的チェックを組み込めるなら、
プロンプトでの注意書きより優先する。
