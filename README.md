Installation
============

```
$ make install
```

Prerequisite
============

* Latest Golang
* vim 8.0+

How to use
==========

zsh
---

Using [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) with antigen.

[peco](https://github.com/peco/peco) and [ghq](https://github.com/motemen/ghq) are used for exploring `src` directory with `GOPATH` style.

### Tips

On zsh,

* `^S`: open any `src` directory by peco. It enables incremental search for projects you fetched.
* `^R`: search .zsh_history in peco.

vim
---

To install plugins, run `:PlugInstall`.

### Golang

Just use [fatih/vim-go: Go development plugin for Vim](https://github.com/fatih/vim-go).

LICENSE
=======

Public Domain
