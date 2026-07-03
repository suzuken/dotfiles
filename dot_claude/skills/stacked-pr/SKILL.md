---
name: stacked-pr
description: >-
  積み上げブランチ（stacked PR、A→B→C のように前の PR の先に次のブランチを切る運用）で
  push・マージするときに使う。「stacked PR」「積み上げ PR」「PR を分割」「ブランチを積む」
  と言われたとき、または複数 PR が依存関係（base 違い）を持つ状況で該当する。
  単発の独立ブランチ・PR には使わない。
---

# stacked PR 運用の落とし穴

他ブランチを基点に切ったブランチの push 事故と、マージ順序を誤ったときの
PR 自動クローズ事故。どちらも一度起きると force push なしでは戻せない。

## push: 完全 refspec を使う

`git checkout -b new-branch origin/other-branch` のように他ブランチ基点で切ると、
**upstream が origin/other-branch に向く**。この状態で `git push -u origin new-branch`
すると、環境の push 設定によっては **other-branch 側に push されてしまう**ことがある
（意図した new-branch ではなく、基点にした方の remote ブランチにコミットが乗る）。

対策:
- push は常に完全 refspec で書く: `git push origin <branch>:refs/heads/<branch>`
- または切った直後に `git branch --unset-upstream` してから `push -u`

事故った場合、force push は（ガード環境では）通らない前提で復旧する:
- 元 commit から新ブランチを前進 push → 誤って乗せた側の PR を新 PR に差し替える
- force push で戻そうとしない（ユーザーの明示指示があっても通らないガード運用がありうる）

## マージ順序: 子の base 付け替えが先

stacked PR（A→B→C）を下から順にマージするとき、**先に子 PR の base を付け替えてから
親をマージ**する。

理由: `gh pr merge --delete-branch` で base ブランチを削除すると、それを base にしていた
open PR は**自動クローズされ、再オープン不能**になる（base 変更も closed PR には効かない）。
自動クローズされた PR は同じブランチから作り直すしかない（PR 番号は変わる）。

正しい手順:
1. `gh pr edit <child> --base main`（子の base を先に main へ付け替え）
2. `gh pr merge <parent> --merge --delete-branch`
3. CI green を確認
4. 子も同様に繰り返す（子がさらに孫を持つ場合は孫→子の順で 1〜3 を先に済ませる）

一般化: 「削除される側に依存している open な何か」がないか、削除・クローズ系の
操作の前に必ず確認する。
