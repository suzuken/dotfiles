---
name: claude-desktop-link
description: >-
  Claude Desktop を deep link（claude:// URL スキーム）で開く・リンクを作る。
  「Desktop で開いて」「この続きを Desktop の Claude Code で」「このディレクトリで
  Desktop セッションを立てて」「chat / Cowork への引き継ぎリンクを作って」と言われたとき、
  またはドキュメントに Claude 起動リンクを埋め込みたいときに使う。
  ターミナルで新しい claude CLI セッションを開くだけの場合には使わない（それは cmux や
  ターミナル側の操作）。
---

# claude-desktop-link — claude:// deep link の組み立て

macOS では `open "<url>"` で Claude Desktop が起動・遷移する（Windows: `start ""`、Linux: `xdg-open`）。

## URL 形式

| 用途 | URL |
|---|---|
| 新規 chat | `claude://claude.ai/new?q=[prompt]` |
| 既存 chat / project | `claude://claude.ai/chat/{id}` / `claude://claude.ai/project/{id}` |
| Claude Code セッション | `claude://code/new?q=[prompt]&folder=[abs-path]` |
| Cowork セッション | `claude://cowork/new?q=[prompt]&folder=[abs-path]&file=[abs-path]` |

- パラメータは全部任意。`prompt` は `q` の別名。`folder` / `file` は絶対パス
- **値は必ず URL エンコード**する（パスの `/` も含めて `quote(safe="")` で）
- prompt は約 14,000 字で切り詰められる
- link 経由の folder は untrusted 扱いで、Desktop 側が必ず確認ダイアログを出す（自動で信頼はされない）

## 手元のショートカット（dot_zshrc に定義済み）

- `ccode [prompt...]` — カレントディレクトリで Claude Code セッションを開く
- `cchat [prompt...]` — 新規 chat を開く

## 引き継ぎリンクを作るとき

このセッションの続きを Desktop でやる場合は、`q` に「何をどこまでやったか + 次にやること」を
1〜2 文で入れ、`folder` に作業 repo を指定した URL を提示する。会話全体は渡らないので、
文脈は q に自己完結させる。
