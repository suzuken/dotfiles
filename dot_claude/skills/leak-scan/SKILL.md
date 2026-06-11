---
name: leak-scan
description: >-
  public repo に push する前に、gitleaks で secret・既知の機密パターンを機械的・確定的に
  スキャンする層。API キー / トークン / 秘密鍵に加え、個人・社内固有のマーカー (会社ドメインの
  メール、絶対ホームパス、機密表示、社名のべた書き) を共通 config で検出する。任意の public repo
  で使える (repo 固有の設定に依存しない)。「leak check」「gitleaks かけて」「公開前に secret
  チェック」、あるいは新しい public repo に pre-push ガードを仕込みたいときに使う。
  意味的な「これ公開して平気か」判断は safe-to-publish skill が担う — この skill はその下の
  機械的レイヤー。
---

# leak-scan — gitleaks による機械的な公開前スキャン

public repo へ push する前に、secret と既知の機密パターンを **確定的に** 検出する。
判断の余地がない（=正規表現で書ける）ものはすべてここで止める。文脈を読む意味的な
判断は上位の `safe-to-publish` skill に任せる。

## 前提

- `gitleaks` が必要。無ければ `brew install gitleaks`。
- config は2段構え（「エンジンは公開、データは手元」）:
  - **ローカル overlay**: `~/.config/gitleaks/company.toml`（chezmoi age 暗号化で配布）。
    built-in secret + 汎用ルール + **会社固有の機密ルール**（会社ドメインのメール・社名の
    べた書き等）を含む完全版。会社固有のリテラルは public repo に出さず手元に置く。
  - **public フォールバック**: バンドルした `~/.claude/skills/leak-scan/gitleaks.toml`。
    built-in secret + 汎用ルール（絶対ホームパス・日本語機密マーカー）のみ。会社固有なし。
- **overlay があればそれを、無ければバンドル版を使う**。新しいマシンで overlay が未復号の
  間や、会社固有ルールが不要な環境でも、フォールバックで汎用スキャンは成立する。

## モード

### scan（デフォルト）— 差分を検査する

公開前に変更内容をスキャンする。範囲の決め方:

- 引数なし → staged 差分。staged が空なら working tree。
- 範囲指定 (例 `origin/main..HEAD`) → その範囲。

実行例（overlay を優先し、無ければバンドル版にフォールバック）:

```sh
CFG="$HOME/.config/gitleaks/company.toml"
[ -f "$CFG" ] || CFG="$HOME/.claude/skills/leak-scan/gitleaks.toml"
# staged の検査
gitleaks protect --staged --config "$CFG" --redact --no-banner
# コミット範囲の検査
gitleaks detect --config "$CFG" --log-opts="origin/main..HEAD" --redact --no-banner
```

検出ゼロなら「機械チェック clean」と報告。検出ありなら、redact 済みの所見を提示し、
誤検知なら対象 repo 自身の `.gitleaks.toml` allowlist で対処、意図的なら `--no-verify`
で bypass できる旨を添える。

### install-hook — その repo に pre-push ガードを仕込む

新しい public repo で、push のたびに自動でスキャンが走るようにする。

1. 対象 repo に pre-push フックを置き、上記 config でスキャンさせる。
2. `core.hooksPath` 等の既存のフック管理方式に合わせる（壊さない）。
3. bypass は `git push --no-verify`、ガードの存在と bypass 手順を README 等に一言残す。

suzuken/dotfiles には既にこのガードが入っている（`hooks/pre-push` + repo 固有の
`.gitleaks.toml`）。他の public repo に同じ仕組みを横展開するのがこのモードの役割。

## 住み分け

公開前チェックは「leak-scan（機械層）→ safe-to-publish（意味層）」の順で重ねる。
