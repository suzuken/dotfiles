#!/usr/bin/env node
// exec-deck 配布ビルド (汎用テンプレ)。
// 正は html/parts/*.html (各 <section> 断片) + html/_layout/*.html (共通枠) + html/style.css。
// 2 出力:
//   dist/index.html      — 全 part を結合した単一ファイル (CSS インライン・全文検索)。投影/配布/PDF 用
//   dist/pages/<id>.html — 各 section 独立ページ (軽量ナビ + 検索)。予習/複数ページ閲覧用
// 使い方: ORDER をこの資料のセクション ID に置き換える。dist/ は生成物 (gitignore)。
const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '..');
const r = (p) => fs.readFileSync(path.join(root, p), 'utf8');
const w = (p, c) => { fs.mkdirSync(path.dirname(path.join(root, p)), { recursive: true }); fs.writeFileSync(path.join(root, p), c); };

// ★ セクションの並び順。html/parts/<id>.html に対応。ここを自分の資料の構成に置き換える。
const ORDER = ['s01', 's02', 's03'];

const head = r('html/_layout/head.html');
const cover = r('html/_layout/cover.html');
const toc = fs.existsSync(path.join(root, 'html/_layout/toc.html')) ? r('html/_layout/toc.html') : '';
const foot = r('html/_layout/foot.html');
const css = r('html/style.css');
const parts = Object.fromEntries(ORDER.map(id => [id, r(`html/parts/${id}.html`)]));

// CSS を <link> から <style> にインライン化 (単一ファイル配布のため)。見つからなければ止める。
const linkRe = /<link\s+rel="stylesheet"\s+href="style\.css[^"]*">/;
const styleTag = `<style>\n${css}\n</style>`;
const inlineCss = (html) => {
  if (!linkRe.test(html)) { console.error('ERROR: style.css の <link> が見つかりません (head.html を確認)'); process.exit(1); }
  const out = html.replace(linkRe, styleTag);
  if (/href="style\.css/.test(out)) { console.error('ERROR: 置換後も style.css 参照が残存'); process.exit(1); }
  return out;
};

// 各 part の h2 から表示タイトル (num + 題) を取り出す (個別ページのナビ用)
function titleOf(id) {
  const m = parts[id].match(/<h2>(?:<span class="num">([^<]*)<\/span>)?\s*([^<]*)/);
  return { num: (m && m[1] || '').trim(), ttl: (m && m[2] || id).trim() };
}

// --- ① 配布用 単一ファイル ---
const single = inlineCss(head + cover + toc + ORDER.map(id => parts[id]).join('') + foot);
w('dist/index.html', single);

// --- ② 複数ページ (各 section 独立 + 軽量ナビ) ---
function miniNav(id, i) {
  const prev = ORDER[i - 1], next = ORDER[i + 1];
  const t = titleOf(id);
  const link = (pid, label) => pid ? `<a href="${pid}.html">${label}</a>` : `<span class="navoff">${label}</span>`;
  return `
<nav class="pagenav">
  <div class="pagenav-row">
    ${link(prev, '← 前')}
    <a href="../index.html" class="pagenav-home">目次 (全体 1 ファイル)</a>
    ${link(next, '次 →')}
  </div>
  <div class="pagenav-title"><span class="num">${t.num}</span> ${t.ttl}</div>
</nav>`;
}
ORDER.forEach((id, i) => {
  w(`dist/pages/${id}.html`, inlineCss(head + miniNav(id, i) + parts[id] + foot));
});

// --- lint: 配布物に混入しやすい記法を検出して止める (壊れた資料を配らない) ---
const lintTargets = { 'dist/index.html': single };
const issues = [];
for (const [f, html] of Object.entries(lintTargets)) {
  if (/\[\[[^\]]+\]\]/.test(html)) issues.push(`${f}: memory リンク記法 [[...]] が露出`);
  if (/(^|[^*])\*\*[^*\n]+\*\*/.test(html.replace(/<[^>]*>/g, ''))) issues.push(`${f}: 未レンダリングの **markdown** が露出`);
}
if (issues.length) { console.error('LINT NG:\n  ' + issues.join('\n  ')); process.exit(1); }

const kb = (n) => (n / 1024).toFixed(0);
console.log(`dist/index.html (${kb(Buffer.byteLength(single))}KB, 単一・全文検索) + dist/pages/ に ${ORDER.length} ページを生成`);
