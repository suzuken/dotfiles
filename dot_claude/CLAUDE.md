# 開発スタイル

TDD で開発する（探索 → Red → Green → Refactoring）。

# コード設計

- コントラクト層（API/型）を厳密に定義し、実装層は再生成可能に保つ
- 静的検査可能なルールはプロンプトではなく、その環境の linter か ast-grep で記述する

# モデルコスト配分（サブエージェント委譲）

メインセッションが高コストモデルのとき:

- メインは設計・タスク分割・監査・レビューと、大規模・難易度の高い実装（横断的な変更、繊細なリファクタリング、根本原因不明のデバッグ）を担う
- 小規模な修正・テスト作成・機械的な変更は `implementer` agent（Sonnet）に切り出す
- 戻りの大きい取得（Google Drive 等の MCP、gh などの CLI/API 往復、大量の検索結果）は `mcp-fetcher` agent（Sonnet）で実行し、要約だけをメインに返す
- 長時間タスクでは自己批評でなく、新しいコンテキストを持つ独立 subagent に仕様照合の検証を定期的にさせる

# ツール

- 大量・機械的なデータ取得（Google Drive 等）に MCP を使わない: ファイル内容が全部モデルを通り token 消費が激しい。rclone・gcloud・API 直叩きの script に落として Claude の外で実行する。MCP は少数ファイルの探索・形式確認・トリアージまで
- タスク: justfile
- LLM モデルはバージョンを pin する。`-latest` エイリアスを使わない（挙動が黙って変わる）
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

新規 skill の配置先（project 固有 / グローバル）が判断できないときは、作る前にユーザーに質問する（後から移すとパス参照や apm.yml が壊れやすい）。配置の基準と chezmoi 取り込み手順は `chezmoi-management` skill を参照
