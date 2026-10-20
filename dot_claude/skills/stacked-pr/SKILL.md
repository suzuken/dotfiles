---
name: stacked-pr
description: >-
  積み上げブランチ（stacked PR、A→B→C のように前の PR の先に次のブランチを切る運用）の
  分割・push・同期・マージ手順。`gh stack`（github/gh-stack 拡張）を優先し、使えない repo では
  手作業の手順に落とす。作業が複数 PR に分かれる / 分けた方がレビューしやすいと判断した
  時点で、ユーザーの指示を待たずに使う（stacked PR がデフォルト）。「stacked PR」「積み上げ PR」
  「PR を分割」「ブランチを積む」「gh stack」と言われたとき、既存の PR の上に追加変更を載せるときも該当。
  1 PR で完結する変更には使わない。
---

# stacked PR

## 分け方

- 1 PR = 1 つのレビュー可能な論点。前提となる変更（型・リファクタ）を下に、それを使う変更を上に積む
- stack 全体の構成（各 PR の論点）を、最初の PR を作る前にユーザーへ一言で示す

## gh stack（優先）

`gh extension install github/gh-stack` で導入（gh 2.0+ / git 2.36+）。repo 側で stacked PRs が
有効でないと exit code 9 で失敗する — そのときは下の「手作業」に切り替える。

| やること | コマンド |
|---|---|
| stack を始める（既存ブランチの取り込みも可） | `gh stack init [--base <trunk>] [branches...]` |
| 上に次のブランチを積む（最上段で実行） | `gh stack add [-A] -m "<msg>" <branch>` |
| push + PR 作成 + GitHub 上の stack 作成 | `gh stack submit --auto` |
| 下の修正を上へ伝播（cascading rebase + push） | `gh stack sync` / `gh stack rebase --upstack` |
| 構成確認 | `gh stack view --short` |
| 既存 PR 群を後から stack にまとめる | `gh stack link <PR...>`（下→上の順） |
| マージ（指定 PR までを一括、all-or-nothing） | `gh stack merge <PR> --merge -y` |

注意:
- Claude からは対話 UI を避ける: `submit` には `--auto`、`switch` / `modify` は使わない（`up` / `down` / `checkout <branch>` で移動）
- `push` / `sync` は `--force-with-lease` で書き換える。ユーザー環境で force push がガードされている場合は通らないので、手作業へ切り替える
- 非対話の `sync` は diverge した stack を検出すると何も push せず中断する。conflict（exit 3）は解消後に `gh stack rebase --continue`
- worktree では clean な worktree しか rebase / sync されない（stash はしない）
- `gh stack merge` は branch protection・必須チェックを迂回しない。PR は open かつ draft でないこと
  （`submit` は `--open` なしだと draft のまま。レビュー依頼時に `--open` を付ける）

## 手作業（gh stack が使えない repo）

- 次のブランチは前の PR ブランチの先端から切り、`gh pr create --base <parent-branch>`
- PR 本文の冒頭に stack 全体（親・子 PR へのリンク）を書く
- 下の PR へのレビュー修正は下のブランチで直し、上のブランチへ merge で伝播させる（force push 不要な形を保つ）

### push: 完全 refspec を使う

`git checkout -b new-branch origin/other-branch` のように他ブランチ基点で切ると、
**upstream が origin/other-branch に向く**。この状態で `git push -u origin new-branch`
すると、環境の push 設定によっては **other-branch 側に push されてしまう**ことがある。

対策:
- push は常に完全 refspec で書く: `git push origin <branch>:refs/heads/<branch>`
- または切った直後に `git branch --unset-upstream` してから `push -u`

事故った場合、force push は（ガード環境では）通らない前提で復旧する:
- 元 commit から新ブランチを前進 push → 誤って乗せた側の PR を新 PR に差し替える

### マージ順序: 子の base 付け替えが先

`gh pr merge --delete-branch` で base ブランチを削除すると、それを base にしていた
open PR は**自動クローズされ、再オープン不能**になる（作り直すと PR 番号が変わる）。

1. `gh pr edit <child> --base main`（子の base を先に main へ付け替え）
2. `gh pr merge <parent> --merge --delete-branch`
3. CI green を確認
4. 子も同様に繰り返す

一般化: 「削除される側に依存している open な何か」がないか、削除・クローズ系の
操作の前に必ず確認する。
