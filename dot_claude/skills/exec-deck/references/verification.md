# 配布前の検証手順

`file://` は Playwright が拒否し、parts/_layout は断片で単体では開けない。**必ず `node scripts/build-dist.js` で dist を生成してから dist を HTTP 配信して確認する**。

```bash
node scripts/build-dist.js && cd dist && python3 -m http.server 8765 --bind 127.0.0.1   # backgrounded
# → http://127.0.0.1:8765/index.html      (単一・全文検索)
# → http://127.0.0.1:8765/pages/<id>.html (個別ページ)
```

dist は CSS インライン化されるので `?v=N` 不要。ブラウザは強キャッシュするので URL に `?v=N` を付けてバストする。

## 1. オーバーフロー監査 (横溢れ)
全要素を `getBoundingClientRect()` し、`right > innerWidth + 1` を抽出。デスクトップ幅とモバイル幅 (480) の両方で。テーブル・固定幅 SVG・反転セクションの全幅化が溢れやすい。

```js
// browser_evaluate で実行
const w = innerWidth;
[...document.querySelectorAll('*')]
  .filter(el => el.getBoundingClientRect().right > w + 1)
  .map(el => el.tagName + (el.className ? '.' + el.className : '') + ' → ' + Math.round(el.getBoundingClientRect().right))
  .slice(0, 40);
```

モバイルは `browser_resize` で 480 幅にして同じ監査。インラインの `grid-template-columns` はメディアクエリで折りたためないので、溢れたら style.css にクラスを生やす。

## 2. ファクト残存 grep
編集で主要な数字・固有名詞・URL が消えていないか、build 後の dist を grep。一次資料から採った値が落ちると気づきにくい。
```bash
grep -o '出典 URL\|主要な固有名詞\|キーになる数値' dist/index.html | sort | uniq -c
```

## 3. 記法の混入 (build script が自動で弾く)
`build-dist.js` の lint が `[[...]]` (memory リンク記法) と未レンダリングの `**markdown**` を検出して `process.exit(1)` する。手で書いたメモ記法が本文に漏れるのを防ぐ。追加で弾きたいパターン (確定度バッジの不整合など) は lint 配列に足す。

## 4. ダークモード
`currentColor` + CSS 変数で自動追従するはずだが、固定色を使った箇所は崩れる。`browser_evaluate` で `document.documentElement.style.colorScheme = "dark"` にするか OS 設定で目視。

## linter 化 (推奨)
これらを散文の手順でなく `just audit` (build の lint + Playwright 監査スクリプト) に落とし、`just deploy` の依存に挟む。プロンプト遵守に頼ると毎回どこかで漏れる — 静的に検査できるものは機械保証にする。
