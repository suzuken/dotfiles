---
name: chezmoi-management
description: >-
  dotfiles (suzuken/dotfiles、chezmoi 管理の **public repo**) に何をどう置くかを扱う。
  新しい設定ファイル・skill・スクリプトを「chezmoi に入れる / 入れない」の境界判断、
  chezmoi add / apply / diff の日常ワークフロー、age 暗号化での機密分離、
  APM (apm.yml で配布する upstream repo) との使い分け、社内 skill を symlink で
  逃がすパターンを含む。「これ chezmoi 管理下にしたい」「dotfiles に入れる?」
  「新しい skill をどこに置く?」「chezmoi でどうやってたっけ」と言われたとき、
  および ~/.claude 配下の設定・skill を作成・更新した直後に使う。
  他人の dotfiles や chezmoi 以外の dotfiles 管理方式には使わない。
---

# chezmoi-management — public な dotfiles に何をどう置くか

`suzuken/dotfiles` は **public repo** で、chezmoi で `~` に展開している。
この skill の中心的な仕事は 2 つ:

1. 対象を chezmoi に入れてよいかの**境界判断**（public に出るため）
2. 入れると決めた後の**手順**（add / apply / 暗号化 / 公開前チェック）

## 前提

| 項目 | 値 |
| --- | --- |
| source | `~/src/github.com/suzuken/dotfiles` (ghq 管理。chezmoi のデフォルト位置ではない) |
| 設定 | `~/.config/chezmoi/chezmoi.toml` (`sourceDir` を上書き、age 有効) |
| age 秘密鍵 | `~/.config/chezmoi/key.txt` — **絶対に commit しない**。失うと復号不能なので別途バックアップ |
| 公開鍵 (recipient) | `.chezmoi.toml.tmpl` に記載。公開して問題ない |
| 公開前ガード | `hooks/pre-push` で gitleaks (`just install-hooks` で有効化) |

## 判断: chezmoi に入れるか

上から順に評価し、最初に当たったものを採用する。

1. **secret そのもの**（API キー、トークン、鍵）
   → chezmoi にもファイルとして入れない。macOS Keychain (`secret` / `secret-set` helper) に置く。
2. **仕組みは汎用だが、中身に社内固有名や機密が入る**（例: 会社固有の gitleaks ルール）
   → `chezmoi add --encrypt` で age 暗号化。source には `encrypted_*.age` として入る。
   方針は「**エンジンは公開、データは手元**」。実例: `dot_config/gitleaks/encrypted_company.toml.age`。
3. **ファイル全体が社内固有**（社内サービス名・社内 repo 名・社内ドメインが構造的に埋まっている）
   → chezmoi に入れない。暗号化で誤魔化さない（ファイル名・パスも公開される）。
   実例: `~/.claude/settings.json` は社内固有名を含むので管理外。
4. **他者・他 repo からも参照される、または特定 repo のドメイン知識に依存**
   → 後述の「APM / upstream repo」側。
5. **上のどれでもない = 自分環境専用で汎用、public にして無害**
   → chezmoi 管理下にする。これがデフォルト。

迷ったら**ユーザーに聞く**。後から移動するとパス参照や apm.yml 設定が壊れる。

## APM vs chezmoi の境界

skill / agent / コマンドの配置先は 3 通りある。

| 置き方 | 使う場面 | 実例 |
| --- | --- | --- |
| **chezmoi** (`dot_claude/skills/<name>/`) | 言語・ツール横断で複数 repo で再利用でき、public にして無害な運用ノウハウ | `leak-scan`, `exec-deck`, `stacked-pr`, `writing` |
| **upstream repo + APM** (`<repo>/.claude/skills/` を `apm.yml` で配布) | 特定 repo のドメイン知識・規約に依存し、**他者や他 repo からも参照される**もの。`apm install` で配れる | デザインシステム repo、社内ツール repo など |
| **社内 repo + symlink** (upstream に本体を置き `~/.claude/skills/<name>` から symlink) | 社内固有で自分だけがグローバルに使いたい。public な dotfiles に出せない | 社内ツール・社内ブランド・社内資料生成系の skill |

判断の軸は「**再利用の範囲**」と「**公開可否**」の 2 つで、混同しやすい:

- 複数 repo で使いたい ≠ chezmoi に入れる。社内固有なら symlink パターンを取る。
- 特定 repo 専用 ≠ APM 登録。他者が参照しないなら repo の `.claude/skills/` に置くだけでよい。

### symlink パターンの運用

```
~/.claude/skills/<name> -> ~/src/github.com/<org>/<repo>/.claude/skills/<name>
```

- 本体の更新は**その repo 側で commit** する。chezmoi には触らない。
- symlink 自体も chezmoi 管理外（パスに社内 repo 名が露出するため）。
- 新マシンでは `ghq get` の後に **symlink を手で張り直す**。数本なら手動で十分。
  スクリプト化しても repo 名が社内固有なので public には置けない。

## 日常ワークフロー

```sh
# 1. 実ファイル (~ 側) を編集する。source を直接編集してもよいが、混ぜない
# 2. source に取り込む
chezmoi add ~/.claude/skills/<name>            # ディレクトリごと OK
chezmoi add --encrypt ~/.config/foo/secret.toml # 機密混じりは暗号化して取り込む

# 3. 差分と管理状況を確認
chezmoi diff
chezmoi status
chezmoi managed | grep <name>

# 4. 公開前チェック（下記「公開前 2 層」）→ commit → push (pre-push で gitleaks)
```

逆方向（source を編集した / 別マシンで pull した）:

```sh
chezmoi diff     # 先に何が変わるか見る
chezmoi apply    # ~ に展開
chezmoi cd       # source repo に移動
```

`skill` を更新したら `chezmoi add` を忘れない。`~/.claude/skills/` 側だけ直して満足すると、
次の `chezmoi apply` で**巻き戻る**。

### source のファイル名規約

| prefix / suffix | 意味 |
| --- | --- |
| `dot_foo` | `~/.foo` |
| `encrypted_foo.age` | age 暗号化。apply 時に復号 |
| `foo.tmpl` | Go template（`.chezmoi.toml.tmpl` の `[data]` を参照） |
| `run_once_before_*` / `run_once_after_*` | 初回 apply 時に一度だけ実行 |

## 公開前 2 層

public repo なので commit / push 前に必ず両方通す。

1. **`leak-scan` skill**（機械的・確定的）— gitleaks。`just check`（作業ツリー全体、untracked 込み）/
   `just check-history`（commit 済み）。会社固有ルールは復号済み overlay
   `~/.config/gitleaks/company.toml` を優先し、無ければ repo 同梱の汎用 `.gitleaks.toml`。
2. **`safe-to-publish` skill**（意味的）— 正規表現に引っかからない内部文脈・固有名・個人情報を
   文章として読んで拾う。skill やドキュメントを追加したときは特にこちら。

bypass は `git push --no-verify` だが、使ったら理由を述べる。

## チェックリスト

新しく chezmoi に入れるとき:

- [ ] 判断フロー 1〜5 を通した（社内固有名・絶対ホームパス・会社ドメインのメールを含まないか）
- [ ] `chezmoi add` 済み（`chezmoi managed` で確認）
- [ ] `chezmoi diff` が期待どおり（意図しない上書きがない）
- [ ] `just check` が clean
- [ ] skill を追加した場合は `safe-to-publish` を通した
- [ ] コミットメッセージは**英語**（public repo の規約）

## 関連

- `leak-scan` — 機械的な公開前スキャン層
- `safe-to-publish` — 意味的な公開判断層
- `stacked-pr` — dotfiles に複数変更を積むとき
