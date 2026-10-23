# skill：skill の作成と修正

1. 置き場所を決める（`chezmoi-management`）。プロジェクト固有かグローバルかを判断できなければ、作る前にユーザーに聞く
2. 既存の skill との重複を確かめる。重なるなら、新しく作らずに既存の skill を直す
3. 静的に検査できる規則は skill に書かず、linter か ast-grep にする
4. frontmatter の `description` に、使う場面のトリガー語と、使わない場面を書く。ユーザーが明示したときだけ動かすなら `disable-model-invocation: true` を付ける
5. 本文を `japanese-tech-writing` で書く。外部の skill を参考にしたら、出典とライセンスを書く
6. 実際の題材で、新しい subagent に skill を実行させてテストする。実行役と採点役を分け、実行役には「曖昧だった箇所、従えなかった箇所」を報告させる。出た曖昧さを直す
7. ~/.claude に反映するときは、変更した skill だけを `chezmoi apply` する

**返答**：作った、または直した skill、テストの題材と結果、直した曖昧さ。
