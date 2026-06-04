# 振る舞い

* ツールの結果を受け取った後、その品質を慎重に検討し、次に進む前に最適な次のステップを決定してください。
* この新しい情報に基づいて計画し、反復するために思考を使用し、最善の次のアクションを取ってください。

# 開発スタイル

TDD で開発する（探索 → Red → Green → Refactoring）。
KPI やカバレッジ目標が与えられたら、達成するまで試行する。
不明瞭な指示は質問して明確にする。

# コード設計

- 関心の分離を保つ
- 状態とロジックを分離する
- 可読性と保守性を重視する
- コントラクト層（API/型）を厳密に定義し、実装層は再生成可能に保つ
- 静的検査可能なルールはプロンプトではなく、その環境の linter か ast-grep で記述する

# ツール

- タスク: justfile
- Node.js: Bun を使える場面では優先する。既存プロジェクトが pnpm 前提の場合や lockfile / workspace 設定が pnpm に依存している場合は pnpm を使う
- Node.js runtime: v24+
- E2E: playwright

# 言語

- 公開リポジトリではドキュメントやコミットメッセージを英語で記述する

# SVG 出力

- 線・塗りは `currentColor` を基準にする（`stroke="currentColor"` / `fill="currentColor"`）。ダーク/ライト両方の背景で破綻させないため
- 背景が必要な図は最背面に明示的な `<rect fill="...">` を置く。viewer の背景透過に依存しない
- 固定色を使うときは中間トーンを選ぶ。純黒 `#000` や純白 `#fff` 単独はダーク/ライトのどちらかで埋もれるので避ける

# 環境

- GitHub: suzuken
- リポジトリ: ghq 管理（`~/src/github.com/owner/repo`）

# スキル作成

新規 skill を作るとき、配置先を次の指針で決める:

- **project 固有** (`<repo>/.claude/skills/` に置く / 該当 repo の `apm.yml` で配布): 特定 repo のドメイン知識・規約・ファイルレイアウトに依存し、他 repo で使う見込みがない
- **グローバル** (`~/.claude/skills/` 直置き or APM global): 言語・ツール横断、複数 repo で再利用可能、運用ノウハウ
- **判断不能なとき**: ユーザーに「project 固有かグローバルか」を質問してから作成（理由: 後から移動するとパス参照や apm.yml 設定が壊れやすい）

外部公開・他者の repo からも参照される可能性があれば upstream repo に置いて APM 登録、自分環境専用なら chezmoi 管理 → 詳細は `chezmoi-management` skill「APM vs chezmoi の境界」節を参照
