Installation
============

[chezmoi](https://www.chezmoi.io/) で管理しています。

```
$ make install
```

これは内部で以下を実行します:

```
$ chezmoi init --apply --source <this repo>
```

初回実行時は `name` と `email` の入力を求められ、`~/.gitconfig` の `[user]` セクションに反映されます。
`run_once_before_install-packages.sh` が Homebrew / oh-my-zsh / vim-plug の導入も行います。

別マシンへ展開する場合:

```
$ chezmoi init --apply git@github.com:suzuken/dotfiles.git
```

Secrets / encryption
====================

機密を含むファイル（会社固有の gitleaks ルール等）は chezmoi の
[age 暗号化](https://www.chezmoi.io/user-guide/encryption/age/) で管理しています。
方針は「エンジン（仕組み）は公開、データ（固有名）は手元」。暗号化ファイルは source 内に
`encrypted_*.age` として置かれ、apply 時に復号されます。

* **秘密鍵**: `~/.config/chezmoi/key.txt`。**リポジトリには絶対に入れない**。
  失うと暗号化ファイルを復号できなくなるので、別途バックアップしておく。
* **新マシン**: `age` を入れ（`brew install age`）、鍵を手元にコピーしてから
  `chezmoi init --apply` する。鍵が無いと暗号化ファイルの展開だけが失敗する。
* **公開鍵 (recipient)** は `.chezmoi.toml.tmpl` に記載。これは公開して問題ない。

pre-push hook
=============

公開リポジトリへの secret / 機密情報の混入を [gitleaks](https://github.com/gitleaks/gitleaks)
で防ぎます。`just install-hooks` で `core.hooksPath=hooks` を設定すると、push 前に
スキャンが走ります。会社固有ルールはローカルの復号済み overlay
（`~/.config/gitleaks/company.toml`）を優先し、無ければ repo 同梱の汎用
`.gitleaks.toml` にフォールバックします。bypass は `git push --no-verify`。

Prerequisite
============

* vim 9.0+
* chezmoi (`brew install chezmoi`)

How to use
==========

zsh
---

Using [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).

[peco](https://github.com/peco/peco) and [ghq](https://github.com/motemen/ghq) are used for exploring `src` directory with `GOPATH` style.

### Tips

On zsh,

* `^S`: open any `src` directory by peco. It enables incremental search for projects you fetched.
* `^R`: search .zsh_history in peco.

vim
---

To install plugins, run `:PlugInstall`.

LICENSE
=======

Public Domain
