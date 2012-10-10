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

if !isdirectory(expand("~/.vim/bundle/vundle"))
    !mkdir -p ~/.vim/bundle
    !git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    let s:bootstrap=1
endif

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"Plugin Installing
Bundle 'gmarik/vundle'
Bundle 'mattn/webapi-vim'
Bundle 'The-NERD-tree'
Bundle 'The-NERD-Commenter'
Bundle 'Gist.vim'
Bundle 'Rainbow-Parenthesis'
Bundle 'surround.vim'
Bundle 'ref.vim'
Bundle 'PDV--phpDocumentor-for-Vim'
Bundle 'thinca/vim-quickrun'
Bundle 'Shougo/vimproc'
Bundle 'mattn/zencoding-vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Modeliner'
Bundle 'tpope/vim-fugitive'
Bundle 'sudo.vim'
Bundle 'tsaleh/vim-align'
Bundle 'Lokaltog/vim-powerline'
Bundle 'thinca/vim-guicolorscheme'
Bundle 'hallison/vim-markdown'
Bundle 'thinca/vim-quickrun'
Bundle 'TwitVim'
Bundle 'ack.vim'
Bundle 'ShowMarks'
Bundle 'YankRing.vim'
Bundle 'mattn/benchvimrc-vim'
Bundle 'scrooloose/syntastic'
Bundle 'derekwyatt/vim-scala'
Bundle 'majutsushi/tagbar'
Bundle 'msanders/snipmate.vim'
Bundle 'kien/ctrlp.vim'

if exists("s:bootstrap") && s:bootstrap
    unlet s:bootstrap
    BundleInstall
endif

filetype plugin indent on     " required!

" =================
" showmarks_include
" =================
let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" ===========
" " powerline
" ===========
let g:Powerline_symbols = 'fancy'

"==========================
"init
"==========================
autocmd!
set modelines=5

" leader is ,
let mapleader = ","

"==========================
"Tab Char
"==========================
set tabstop=4
set expandtab
set softtabstop=0
set shiftwidth=4
set smarttab


"==========================
"Tab Pages
"==========================
nnoremap <C-t>  <Nop>
nnoremap <C-t>n  :<C-u>tabnew<CR>
nnoremap <C-t>c  :<C-u>tabclose<CR>
nnoremap <C-t>o  :<C-u>tabonly<CR>
nnoremap <C-t>j  :<C-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
nnoremap <C-t>k  gT

"==========================
"view
"==========================
if has('gui_running')
    set t_Co=16
    let g:solarized_termcolors=16
    colorscheme solarized
    " call togglebg#map('<F5>')
endif

" when running on terminal, modify colorscheme
colorscheme slate

set number
set title
"set visualbell
set scrolloff=5

if v:version >= 700
    set cursorline
    " highlight CursorLine guibg=lightblue ctermbg=lightgray
endif

"vim 7.3~
if v:version >= 730
    set relativenumber  "showing relative column number
    set undofile    "creating <FILENAME>.un~
endif
set cmdheight=2

" ======
"  font
" ======
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

" get back from search mode
"
nnoremap <Esc><Esc> :nohlsearch<CR>

" <tab> means %
nnoremap <tab> %

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

" F1 means ESC, too.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
inoremap <C-j> <ESC>
nnoremap <C-j> <ESC>
vnoremap <C-j> <ESC>

nnoremap ; :

au FocusLost * :wa

" in insert mode, jj means <ESC>.
inoremap jj <ESC>

"F2でpasteモードに。pasteするときにインデントを無効化。
" <F2> to paste mode.
set pastetoggle=<F2>

"splitの移動を簡単に。ctrl押しながらhjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Enterでいつでも一行挿入
" <Enter> always means inserting line.
map <S-Enter> O<ESC>
map <Enter> o<ESC>

" Creating underline/overline headings for markup languages
" Inspired by http://sphinx.pocoo.org/rest.html#sections
nnoremap <leader>1 yyPVr=jyypVr=
nnoremap <leader>2 yyPVr*jyypVr*
nnoremap <leader>3 yyPVr-jyypVr-
nnoremap <leader>4 yypVr=
nnoremap <leader>5 yypVr-
nnoremap <leader>6 yypVr^
nnoremap <leader>7 yypVr"

"registerとmarkの確認を楽にする
"http://whileimautomaton.net/2008/08/vimworkshop3-kana-presentation
nnoremap <Space>m :<C-u>marks
nnoremap <Space>r :<C-u>registers

"BundleSearchへのショートカット
" Shortcuts for BundleSearch
nnoremap <Space>s :BundleSearch<Space>

" representing Tagbar.
nnoremap <leader>t :TagbarToggle<CR>

" NERDTreeを表示
" representing NERDTree
nnoremap <leader>n :NERDTree<CR>

" default key-bind of opening comamnd-line window makes typo frequently.
" So, using qqq prefix for those.
nnoremap qqq: <Esc>q:
nnoremap qqq/ <Esc>q/
nnoremap qqq? <Esc>q?
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

"==========================
"language
"==========================

set encoding=utf-8
source $HOME/.vim/encode.vim

set fileformats=unix,dos,mac

"ambiwidthがある場合、doubleに設定
if exists('&ambiwidth')
    set ambiwidth=double
endif

"==========================
"Folding
"==========================
" Folding rules {{{
set foldenable                  " enable folding
set foldcolumn=2                " add a fold column
set foldmethod=marker           " detect triple-{ style fold markers
set foldlevelstart=0            " start out with everything folded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                " which commands trigger auto-unfold
function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
    return line . ' …' . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
set foldtext=MyFoldText()
" }}}

" ******************************
"            Leader
" ******************************
" white spaceをtrailする
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" Ackへのショートカット
nnoremap <leader>a :Ack
" htmlで良く使う。タグに囲まれたものを一気に選択。
nnoremap <leader>ft Vatzf
" CSSプロパティを並べ替え
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
" TextMateの<Ctrl-Q>。ワンライナーに書き換え。
nnoremap <leader>q gqip
" 直前に貼り付けたコードを再選択。インデントとか入れるときに便利。
nnoremap <leader>v V`]


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
"set completeopt=menu,preview,menuone

"==========================
"Programming
"==========================
set showmatch "対応する括弧を表示
"set cindent "Cのインデント
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
set statusline=[%L]\ %t\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l/%L "ステータスラインの表示内容


"==========================
"Window
"==========================
set splitright "Window Split時に新Windowを右に表示
set splitbelow "Window Split時に新windowを下に表示

"==========================
"Dictionary
"==========================
set dictionary=/usr/share/dict/words
autocmd FileType php :set dictionary=~/.dictionary/phpdoc

"==========================
"File Type
"==========================
syntax on "シンタックスハイライト
au FileType perl call PerlType()
"" ファイルタイプに応じてテンプレートを自動読み込み
autocmd BufNewFile * silent! 0r $HOME/.vim/templates/%:e.tpl
" バッファを開いた時に、カレントディレクトリを自動で移動
" autocmd BufEnter * execute ":lcd " . expand("%:p:h")



"visualeditの設定
"set virtualedit+=block

" ---------------------------
"python
" ---------------------------
if has('autocmd')
    autocmd FileType python setl autoindent
    autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    autocmd FileType python setl tabstop=4 expandtab shiftwidth=4 softtabstop=4
endif

" Execute python script C-P
function! s:ExecPy()
    exe "!" . &ft . " %"
:endfunction
command! Exec call <SID>ExecPy()
autocmd FileType python map <silent> <C-P> :call <SID>ExecPy()<CR>

" ----
" html
" ----
if has('autocmd')
    autocmd FileType html :compiler tidy
    autocmd FileType html :setlocal makeprg=tidy\ -raw\ -quiet\ -errors\ --gnu-emacs\ yes\ \"%\"
endif

" ---
" css
" ---
if has('autocmd')
    autocmd FileType css :compiler css
endif


" ---
" scala
" ---
if has('autocmd')
    autocmd BufNewFile,BufRead *.scala set filetype=scala
endif

"==========================
"help
"==========================
set helplang=en

"**************************
"plugin
"**************************

"==========================
"ref.vim
"==========================
let g:ref_phpmanual_path=$HOME . '/.dictionary/phpdoc/'
let g:ref_phpmanual_cmd="w3c -dump %s"
let g:ref_use_vimproc=0
let g:ref_jquery_cmd="w3c -dump %s"
let g:ref_alc_cmd="w3c -dump %s"

"Ref alc
nnoremap <space>ra :<C-u>Ref alc<Space>
nnoremap <space>rp :<C-u>Ref phpmanual<Space>

" ========
" Quickrun
" ========
" Initialization
let g:quickrun_config = {}

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

" =====
" after
" =====
" when saving, erase spaces at end of lines.
autocmd BufWritePre * :%s/\s\+$//ge
"----------------------------------------------------
"" host specific
"----------------------------------------------------
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif


function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
  echo s:uri
  if s:uri != ""
    exec "!open \"" . s:uri . "\""
  else
    echo "No URI found in line."
  endif
endfunction

map <Leader>w :call HandleURI()<CR>
