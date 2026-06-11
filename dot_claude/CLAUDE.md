# 開発スタイル

TDD で開発する（探索 → Red → Green → Refactoring）。

# コード設計

- コントラクト層（API/型）を厳密に定義し、実装層は再生成可能に保つ
- 静的検査可能なルールはプロンプトではなく、その環境の linter か ast-grep で記述する

# モデルコスト配分（サブエージェント委譲）

メインセッションが高コストモデル（Fable / Opus）のとき、トークン消費を抑えるため次のように使い分ける:

- メインセッションは設計・タスク分割・監査・レビューを担う
- 実装の使い分け: 小規模な修正・テスト作成・機械的な変更は `implementer` agent（Sonnet）に切り出す。大規模・難易度の高い実装（横断的な変更、繊細なリファクタリング、根本原因不明のデバッグ）はメインセッション（Fable 1M）が直接行う
- 戻りの大きい MCP 呼び出し（Google Drive 等のファイル内容取得、大量の検索結果）は `mcp-fetcher` agent（Sonnet・読み取り専用）で実行し、要約・抽出結果だけをメインに返す。メインのコンテキストに生データを流さない
- 読み取り専用の広い探索（コードベース調査など）はビルトインの `Explore` agent に切り出してメインのコンテキストを節約する
- 委譲するときは自己完結したプロンプトを渡す（対象ファイルパス・従うべき規約・完了条件・検証コマンドを含める）
- subagent は非同期でディスパッチし、返るまでブロックせずメインは並行して作業を続ける
- 長時間タスクでは自己批評でなく、新しいコンテキストを持つ独立 subagent に仕様照合の検証を定期的にさせる
- subagent の成果物はメインセッションが必ずレビュー・検証してから完了とする

# ツール

- 大量・機械的なデータ取得（Google Drive 等）に MCP を使わない: ファイル内容が全部モデルを通り token 消費が激しい。rclone・gcloud・API 直叩きの script に落として Claude の外で実行する。MCP は少数ファイルの探索・形式確認・トリアージまで
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
- **グローバル** (`~/.claude/skills/` 直置き or APM global): 言語・ツール横断、複数 repo で再利用可能、運用ノウハウ。`~/.claude/skills/` は chezmoi 管理（suzuken/dotfiles、**public repo**）なので、作成・更新したら `chezmoi add` で取り込み、社内固有名は書かない（leak-scan を通す）
- **判断不能なとき**: ユーザーに「project 固有かグローバルか」を質問してから作成（理由: 後から移動するとパス参照や apm.yml 設定が壊れやすい）

外部公開・他者の repo からも参照される可能性があれば upstream repo に置いて APM 登録、自分環境専用なら chezmoi 管理 → 詳細は `chezmoi-management` skill「APM vs chezmoi の境界」節を参照

# brain-first

私の外部化された脳（brain MCP、suzuken/brain）が使える。次の習慣で使うこと:

- **行動前に脳に聞く**: 私の考え・判断基準・過去の文脈が関わる話題
  （設計判断、組織・事業の方針、過去に考えたことの参照）では、回答や作業の前に
  `brain_ask` / `brain_search` で脳に問い合わせる。
- **`ref` 付きヒットはグラフページ**: `brain_neighbors` で関連を辿ると文脈が広がる。
- **gaps は育成のシグナル**: `brain_ask` の `gaps` に出たものは「脳に無い知識」。
  会話で補えたら brain-capture（ページ化）を私に提案する。
- **新しい洞察が出たら**: 再利用される判断基準・原則・独自の統合は、勝手に書かずに
  「これ brain に入れますか?」と提案する（suzuken/brain repo の brain-capture スキルの流儀:
  逐語 > 要約、`[[dir/id]]` クロスリンク必須、重複確認、第三者情報は確認後）。
