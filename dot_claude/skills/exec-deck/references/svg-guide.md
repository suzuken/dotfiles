# インライン SVG 作図の指針

図は PNG/画像で貼らず**インライン SVG** にする。理由: light/dark 両対応が `currentColor` で自動で効く・差分が git で見える・ブランド差し替えに追従する・拡大しても劣化しない。

## 色の規約 (最重要)
- 線・塗りは `currentColor` を基準にする (`stroke="currentColor"` / `fill="currentColor"`)。これで親要素の文字色に追従し、dark/light どちらでも破綻しない。
- 強調したい一点だけ `var(--accent)` を使う (例: ハイライトしたいバー 1 本)。アクセントを撒かない。
- 背景が必要な図は最背面に明示的な `<rect fill="var(--surface)">` (または `var(--bg)`) を置く。viewer の背景透過に依存しない。
- 純黒 `#000` / 純白 `#fff` の単独使用は避ける。固定色を使うなら中間トーン。
- 濃淡は `opacity` で付ける (`opacity=".5"`) と 1 色で階調が出て dark でも安全。

## スケールとサイズ
- `viewBox="0 0 W H"` で素直に座標を取り、`width`/`height` は指定しない (`.diagram svg { max-width:100%; height:auto }` で親に収まる)。
- 目盛り・ラベルの `font-size` は 10-13px。細かい注記が情報密度を上げる。
- テキストは `fill="currentColor"`、補助は `opacity` を落とす。

## よく使う型
- **タイムライン**: 横軸 1 本 + 等間隔のノード + 上下にラベル。フェーズ区切りは縦の薄い線。
- **4 象限マップ**: 中央十字 + 4 ラベル + 各象限にプロット点。軸名は端に小さく。
- **ピラミッド / レイヤー**: 台形を積む。各層の幅で量を表す。
- **ガント / ラダー**: 行ごとにバー。期間は x、進捗は塗り分け。
- **比較バー**: 横棒を並べ、強調する 1 本だけ `var(--accent)`。

## 雛形 (タイムライン)
```html
<figure class="diagram">
  <svg viewBox="0 0 600 120" role="img" aria-label="ロードマップ">
    <rect x="0" y="0" width="600" height="120" fill="var(--surface)"/>
    <line x1="40" y1="70" x2="560" y2="70" stroke="currentColor" opacity=".4"/>
    <g font-size="11" fill="currentColor">
      <circle cx="120" cy="70" r="5" fill="currentColor"/>
      <text x="120" y="55" text-anchor="middle">Phase 1</text>
      <circle cx="300" cy="70" r="5" fill="var(--accent)"/>
      <text x="300" y="55" text-anchor="middle">Phase 2</text>
      <circle cx="480" cy="70" r="5" fill="currentColor"/>
      <text x="480" y="55" text-anchor="middle">Phase 3</text>
    </g>
  </svg>
  <figcaption>3 フェーズのロードマップ</figcaption>
</figure>
```

確認: build → 配信して dark モード (`document.documentElement.style.colorScheme='dark'` or OS 設定) でも線・文字が見えるか目視する。
