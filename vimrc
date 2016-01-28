" ======================
" vim configuration file
" @author suzuken (https://github.com/suzuken)
"
" README file is here:
"
" suzuken/dotfiles - GitHub
" https://github.com/suzuken/dotfiles
"
" Sorry for writing some comments in Japanese, and I'll translate to English
" later.
" ======================
set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

set shell=bash\ -i
set noerrorbells
set vb t_vb=
" using git instead of https style
let g:vundle_default_git_proto = 'git'

"Plugin Installing
Bundle 'gmarik/vundle'
Bundle 'mattn/webapi-vim'
Bundle 'The-NERD-Commenter'
Bundle 'mattn/gist-vim'
Bundle 'mattn/emmet-vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Modeliner'
Bundle 'tpope/vim-fugitive'
Bundle 'thinca/vim-quickrun'
Bundle 'ShowMarks'
Bundle 'mattn/benchvimrc-vim'
Bundle 'msanders/snipmate.vim'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'puppetlabs/puppet-syntax-vim'
Bundle 'rking/ag.vim'
Bundle 'timcharper/textile.vim'
Bundle 'Shougo/vimproc.vim'
Bundle 'mattn/ctrlp-ghq'
Bundle 'majutsushi/tagbar'
Bundle 'mattn/sonictemplate-vim'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'justinmk/vim-dirvish'

" Plugins for each languages
Bundle 'wting/rust.vim'
Bundle 'derekwyatt/vim-scala'
Bundle 'vim-ruby/vim-ruby'
Bundle 'fatih/vim-go'
Bundle 'vim-php/tagbar-phpctags.vim'
Bundle 'shawncplus/phpcomplete.vim'
Bundle 'sumpygump/php-documentor-vim'
Bundle '2072/PHP-Indenting-for-VIm'
Bundle 'hynek/vim-python-pep8-indent'
Bundle 'sprsquish/thrift.vim'

if exists("s:bootstrap") && s:bootstrap
    unlet s:bootstrap
    BundleInstall
endif

filetype plugin indent on     " required!

" =================
" showmarks_include
" =================
let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

"==========================
"init
"==========================
autocmd!
set modelines=5

" leader is ,
let mapleader = ","

set tabstop=4
set expandtab
set softtabstop=0
set shiftwidth=4
set smarttab
set number
set title
set scrolloff=5

if has('gui_running')
    set t_Co=16
    let g:solarized_termcolors=16
    colorscheme solarized
endif

if v:version >= 700
    set cursorline
endif

if v:version >= 730
    set relativenumber  "showing relative column number
    set undofile    "creating <FILENAME>.un~
endif
set cmdheight=2

" highlight each language in markdown
" http://mattn.kaoriya.net/software/vim/20140523124903.htm
let g:markdown_fenced_languages = [
\  'css',
\  'go',
\  'javascript',
\  'js=javascript',
\  'json=javascript',
\  'ruby',
\  'sass',
\  'xml',
\  'erlang',
\]

if has("gui_gnome")
    set guifont=Ricty\ 12
end

"==========================
"Searching and Moving
"==========================
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault    " always %s/hoge/foo/ means %s/hoge/foo/g
set incsearch
set showmatch
set hlsearch
set wrapscan

" In visual mode, tab means insert <tab> into highlighted block.
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" always escape / and ? in search character.
cnoremap <expr> /
            \ getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?
            \ getcmdtype() == '?' ? '\?' : '?'

"==========================
"Handling long lines
"==========================
set wrap

set formatoptions=qrn1
if v:version >= 730
    set colorcolumn=85 "色づけ
endif

"==========================
"Key Bind
"==========================
" reload vimrc
noremap <C-c><C-c> <C-c>
noremap <C-c><C-e>e :edit $HOME/.vimrc<CR>
noremap <C-c><C-e>s :source $HOME/.vimrc<CR>

" when move to search results, move to center.
noremap n nzz
noremap N Nzz
noremap * *zz
noremap # #zz
noremap g* g*zz
noremap g# g#zz

nnoremap ; :

au FocusLost * :wa

"F2でpasteモードに。pasteするときにインデントを無効化。
" <F2> to paste mode.
set pastetoggle=<F2>

"splitの移動を簡単に。ctrl押しながらhjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" <Enter> always means inserting line.
nnoremap <S-Enter> O<ESC>
nnoremap <Enter> o<ESC>

" Creating underline/overline headings for markup languages
" Inspired by http://sphinx.pocoo.org/rest.html#sections
nnoremap <leader>1 yyPVr=jyypVr=
nnoremap <leader>2 yyPVr*jyypVr*
nnoremap <leader>3 yyPVr-jyypVr-
nnoremap <leader>4 yypVr=
nnoremap <leader>5 yypVr-
nnoremap <leader>6 yypVr^
nnoremap <leader>7 yypVr"

"==========================
"language
"==========================
set encoding=utf-8
source $HOME/.vim/encode.vim

set fileformats=unix,dos,mac

set ambiwidth=double

"==========================
"clipboard
"==========================
set clipboard+=autoselect

"==========================
"special Key
"==========================
set list
set listchars=tab:>-,trail:-,extends:<,precedes:<
highlight specialKey ctermfg=darkgray

"==========================
"Input
"==========================
set backspace=indent,eol,start
set formatoptions+=mM
set autoindent
set smartindent

"==========================
"Command
"==========================
set wildmenu
set wildmode=full:list

"==========================
"Programming
"==========================
set showmatch "対応する括弧を表示
set foldmethod=syntax
set grepprg=internal "内蔵grep

"==========================
"Backup
"==========================
set autowrite
set hidden
set backup
set backupdir=$HOME/.vimback
set directory=$HOME/.vimtmp
set history=10000
set updatetime=500
"set viminfo=""
let g:svbfre = '.\+'

"==========================
"Status Line
"==========================
set showcmd "ステータスラインにコマンドを表示
set laststatus=2 "ステータスラインを常に表示

"==========================
"Window
"==========================
set splitright "Window Split時に新Windowを右に表示
set splitbelow "Window Split時に新windowを下に表示

"==========================
"File Type
"==========================
syntax on "シンタックスハイライト

if has('autocmd')
    autocmd BufNewFile * silent! 0r $HOME/.vim/templates/%:e.tpl

    autocmd FileType python setl autoindent
    autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    autocmd FileType python setl tabstop=4 expandtab shiftwidth=4 softtabstop=4

    autocmd FileType html :compiler tidy
    autocmd FileType html :setlocal makeprg=tidy\ -raw\ -quiet\ -errors\ --gnu-emacs\ yes\ \"%\"
    autocmd FileType html setl tabstop=2 expandtab shiftwidth=2 softtabstop=2

    autocmd BufNewFile,BufRead *.scala set filetype=scala
    autocmd FileType scala setl tabstop=2 expandtab shiftwidth=2 softtabstop=2

    autocmd BufNewFile,BufRead *.q set filetype=sql

    autocmd BufNewFile,BufRead *.twig set filetype=html
endif

"==========================
"help
"==========================
set helplang=en

let g:quickrun_config = {}

augroup my_dirvish_events
    au!
    au User DirvishEnter let b:dirvish.showhidden = 1
augroup END

"==========================
"NERDcommenter.vim
"==========================
let NERDSpaceDelims = 1
let NERDShutUp = 1

" =====================================================
"" ctags
" =====================================================
set tags=tags

" =====================================================
"" snipMate.vim
" =====================================================
let g:snips_author = 'Kenta Suzuki'

" =====================================================
"" tagbar
" =====================================================
noremap <leader>t :<c-u>TagbarToggle<cr>

" =====================================================
"" ctrlp.vim
" =====================================================
let g:ctrlp_regexp = 0
let g:ctrlp_extensions = ['tag', 'buffertag', 'dir', 'mixed', 'bookmarkdir']
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|class)$',
    \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
    \ }

" ctrlp-ghq
" https://github.com/mattn/ctrlp-ghq
noremap <leader>g :<c-u>CtrlPGhq<cr>

" jad
" installation required http://varaneckas.com/jad/
augr class
    au!
    au bufreadpost,filereadpost *.class %!jad -noctor -ff -i -p %
    au bufreadpost,filereadpost *.class set readonly
    au bufreadpost,filereadpost *.class set ft=java
    au bufreadpost,filereadpost *.class normal gg=G
    au bufreadpost,filereadpost *.class set nomodified
augr END

"----------------------------------------------------
"" host specific
"----------------------------------------------------
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^>,;:]*')
  " let s:uri = matchstr(getline("."), '/https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/')
  echo s:uri
  if s:uri != ""
    exec "!open \"" . s:uri . "\""
  else
    echo "No URI found in line."
  endif
endfunction

" automatically create directory
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'))
  function! s:auto_mkdir(dir)  " {{{
    if !isdirectory(a:dir)
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

map <Leader>w :call HandleURI()<CR>

" http://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
" set full path of current buffer to unamed register
nmap cp :let @" = expand("%")
