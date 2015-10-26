Installation
============

```
$ make install
```

Prerequisite
============

* Golang 1.x
* Python 2.x (using pyenv is recommended.)
* Ruby 2.x (using rbenv is recommended.)

How to use
==========

zsh
---

I'm usually using [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), so if you don't know about that, please check that manual. In this configuration, you can use zshrc.mine for each environment.

[peco](https://github.com/peco/peco) and [ghq](https://github.com/motemen/ghq) are used for managing `src`. It's treat all project depends on golang's source management style.

### Tips

On zsh,

* `^S`: open any `src` directory by peco. It enables incremental search for projects you fetched.
* `sd`: search and open your documents (txt, pdf etc.) in `~/Documents` and `~/Dropbox` by peco.
* `^R`: search .zsh_history in peco.

gem
---

Everything in $GOPATH/src style.

```
$ gem install gem-src
```

vim
---

For using vim, you need to install vundle.vim.

    git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

Launch vim, and `:BundleInstall`.

When writing, I always write with this vim.

### Managing plugins

For managing plugins for vim, [Vundle][] is used here.

[Vundle]:   https://github.com/gmarik/vundle "gmarik/vundle - GitHub"

Vundle is very good choice for managing your plugins -- it's easy to install, search, clean up, and update for vim plugins.

### Browsing files

@see [unite.vim][] page on GitHub.

[unite.vim]:  https://github.com/Shougo/unite.vim "Shougo/unite.vim - GitHub"

And, "f" key is mapped to start using Unite for useful.


### encoding

Encoding is very serious problem for vim users. If you have iconv, your vim will work well.

### Folding

### Leader

',' key is mapped to Leader. '\' is too far, I think.

### Utility

Some small utilities is provided.

* `<C-c><C-e>e` to edit, and `<C-c><C-e>s` to reload .vimrc in normal mode.

        noremap <C-c><C-c> <C-c>
        noremap <C-c><C-e>e :edit $HOME/.vimrc<CR>
        noremap <C-c><C-e>s :source $HOME/.vimrc<CR>

* `<F1>` to `<ESC>`, because I usually mistake it.

        inoremap <F1> <ESC>
        nnoremap <F1> <ESC>
        vnoremap <F1> <ESC>

* `;` to `:` in normal mode.

        nnoremap ; :

* `jj` to switch normal mode in insert mode.

        inoremap jj <ESC>

* `<F2>` to paste mode.

        set pastetoggle=<F2>

* Moving splited tabs by `<C-h><C-j><C-k><C-l>`.

        nnoremap <C-h> <C-w>h
        nnoremap <C-j> <C-w>j
        nnoremap <C-k> <C-w>k
        nnoremap <C-l> <C-w>l

* `<Enter>` always inserts new line.

        map <S-Enter> O<ESC>
        map <Enter> o<ESC>


* Creating underline/overline headings for markup languages. Inspired by http://sphinx.pocoo.org/rest.html#sections .

        nnoremap <leader>1 yyPVr=jyypVr=
        nnoremap <leader>2 yyPVr*jyypVr*
        nnoremap <leader>3 yyPVr-jyypVr-
        nnoremap <leader>4 yypVr=
        nnoremap <leader>5 yypVr-
        nnoremap <leader>6 yypVr^
        nnoremap <leader>7 yypVr"

* `<leader>t` to open TagList.

        nnoremap <leader>t :Tlist<CR>

* `<leader>n` to open NEWDTree.

        nnoremap <leader>n :NERDTree<CR>

### golang

For development in golang, [Gotags](https://github.com/jimweirich/gotags) is used for generating ctags compatible tags because golang is not currently supported by exubelant ctags. Opening `.go` files, `gotags` is used for generating ctags. To use `gotags`, you simply do that:

    go get github.com/jstemmer/gotags

And [rogpeppe/godef](https://github.com/rogpeppe/godef) is used for jumping to code definition.

    go get github.com/rogpeppe/godef

Actually, you can `make install` for this workaround.

vimperator
----------

If you are vimmer, [Vimperator][] makes your web browsing faster and easier. Vimperator is one kind of add-ons for firefox.

[Vimperator]: https://addons.mozilla.org/ja/firefox/addon/vimperator/   "Vimperator :: Add-ons for Firefox"
