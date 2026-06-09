# レイアウト構成要素カタログ

`assets/style.css` に定義済みの要素と、使い分けの判断。**情報密度を上げる方向に倒す** — 一行で済むことを段落にしない、表で済むことをカードにしない。ただし並列性 (3-4 個の並び) はカードで積極的に見せる。

## 何を選ぶか (早見表)

| 伝えたいこと | 使う要素 |
|---|---|
| 4 つ前後の重要な数字 | `.stats` (big-number) |
| 多列・多行の比較 / 一覧 | `table` / `table.compact` |
| 3-4 個の並列な概念・選択肢 | `.card` を `.grid.grid-3` 等で |
| 補足・注意・OK 例 | `.callout` / `.callout.warn` / `.callout.ok` |
| 一文で言い切る主張 | `.kicker` |
| 経営に決めてほしい論点 | `.discussion` |
| この節が答える問い | `.answers` (h2 直下) |
| 節内の大きな転換 (情報共有→意思決定→行動) | `.part-divider` |
| 図・チャート | `.diagram` + インライン SVG + `<figcaption>` |

## 各要素

### h2 / .num / .lede / h3 / h4
セクションは `<section id="...">` で囲み、`<h2><span class="num">01</span> 題</h2>` で始める。`.num` がアクセント色の連番バッジ。h2 直下の `.lede` が導入文 (最大幅 720px、灰)。本文の階層は h3 → h4 (h4 は小見出しラベル、大文字)。

### .stats / .stat
```html
<div class="stats">
  <div class="stat"><div class="v">340<small>億</small></div><div class="k">連結売上</div></div>
  <div class="stat"><div class="v">+8.6<small>%</small></div><div class="k">市場成長</div></div>
</div>
```
数字を本文に埋もれさせない。4 つ前後が収まりが良い (`grid` は repeat(4))。

### table / .pill
情報密度の主役。`<thead>` のラベルは小さく、数値セルは `class="num"` で tabular-nums + monospace に揃える。状態は `.pill` (`.pill.ok` / `.pill.warn`) で色付きバッジ。モバイルでは `table-layout: fixed` で折り返す (style.css 済)。

### .card / .grid
```html
<div class="grid grid-3">
  <div class="card"><span class="tag">区分</span><h4>見出し</h4><p>本文</p></div>
  ...
</div>
```
`.grid-2` / `.grid-3` / `.grid-4`。並列なものを横に並べて比較させる。インラインで `grid-template-columns` を書かない (モバイルで折りたためない) — 必ずクラスを使う。

### .callout
左ボーダーの色で種別。既定はアクセント、`.warn` は警告色、`.ok` は成功色。プロフィール用の 2 カラムは `.callout--profile`。

### .kicker
太字 18px・左にアクセントのバー。「この資料で一番言いたい一文」に 1 セクション 1 個まで。撒くと効かない。

### .discussion
アクセントの破線枠。**経営に決めてほしい論点をここに集める**。意思決定資料では決定項目ごとに 1 つ置く (中身の作法は `decision-deck-architecture` skill)。

### .answers
h2 直下に置く「この節が答える問い」。資料全体の背骨の問い (横断する 1 本) に対し、各節がどれに答えるかを明示すると流れが締まる。

### .part-divider
1 セクションが長くなり、性質の違う塊 (情報共有 / 意思決定 / アクション) に分かれるときの大区切り。
```html
<div class="part-divider"><div class="pd-label">DECISION</div><div class="pd-title">意思決定</div><div class="pd-note">ここから経営の判断事項</div></div>
```

### section.dark (反転セクション)
`<section class="dark">` で全幅の黒地になり「章が変わった」リズムを作る。内部は CSS 変数を再定義して追従するので子要素は崩れない。多用しない — 表紙と、節目の 1-2 セクションに留める。

### .diagram
SVG 図の枠 + キャプション。作図は `svg-guide.md`。
