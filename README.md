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
