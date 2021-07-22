" ======================
" vim configuration file
" @author suzuken (https://github.com/suzuken)
"
" suzuken/dotfiles - GitHub
" https://github.com/suzuken/dotfiles
" ======================

" use https://github.com/junegunn/vim-plug
call plug#begin()

"Plugin Installing
Plug 'mattn/webapi-vim'
Plug 'vim-scripts/The-NERD-Commenter'
Plug 'mattn/gist-vim'
Plug 'mattn/emmet-vim'
Plug 'vim-scripts/Modeliner'
Plug 'tpope/vim-fugitive'
Plug 'thinca/vim-quickrun'
Plug 'vim-scripts/ShowMarks'
Plug 'mattn/benchvimrc-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'Shougo/vimproc.vim'
Plug 'mattn/ctrlp-ghq'
Plug 'majutsushi/tagbar'
Plug 'mattn/sonictemplate-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-dirvish'
Plug 'plasticboy/vim-markdown'
Plug 'uarun/vim-protobuf'

Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'garbas/vim-snipmate'

let g:snipMate = { 'snippet_version' : 0 }

" Plugins for each languages
Plug 'puppetlabs/puppet-syntax-vim'
Plug 'wting/rust.vim', {'for': 'rust'}
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
Plug 'fatih/vim-go',  {'for': 'go'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'ekalinin/Dockerfile.vim'

call plug#end()

filetype plugin indent on

" =================
" showmarks_include
" =================
let g:showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

"==========================
"init
"==========================
set modelines=5

let mapleader = ","

set tabstop=4
set expandtab
set softtabstop=0
set shiftwidth=4
set smarttab
set number
set title
set scrolloff=5
set ambiwidth=double
set visualbell

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
\  'sql',
\  'perl',
\  'php',
\]

"==========================
"Searching and Moving
"==========================
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
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

"==========================
"Key Bind
"==========================
" reload vimrc
" http://learnvimscriptthehardway.stevelosh.com/chapters/07.html
noremap <C-c><C-c> <C-c>
noremap <C-c><C-e>e :edit $MYVIMRC<CR>
noremap <C-c><C-e>s :source $MYVIMRC<CR>

" when move to search results, move to center.
noremap n nzz
noremap N Nzz
noremap * *zz
noremap # #zz
noremap g* g*zz
noremap g# g#zz

nnoremap ; :

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

    autocmd BufNewFile,BufRead *.q set filetype=sql

    autocmd BufNewFile,BufRead *.twig set filetype=html
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
endif

"==========================
"help
"==========================
set helplang=en

augroup my_dirvish_events
    au!
    au User DirvishEnter let b:dirvish.showhidden = 1
augroup END

let g:dirvish_relative_paths = 1

"==========================
"NERDcommenter.vim
"==========================
let g:NERDSpaceDelims = 1
let g:NERDShutUp = 1

" =====================================================
"" ctags
" =====================================================
set tags=tags

" =====================================================
"" sonictemplate
" =====================================================
let g:sonictemplate_vim_template_dir = [
\ '$HOME/.vim/templates',
\]

" =====================================================
"" tagbar
" =====================================================
noremap <leader>t :<c-u>TagbarToggle<cr>

" =====================================================
"" ack.vim
" =====================================================
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

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

" quickrun
let g:quickrun_config = {}

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
  echo s:uri
  if s:uri != ""
    exec "!open \"" . s:uri . "\""
  else
    echo "No URI found in line."
  endif
endfunction

map <Leader>w :call HandleURI()<CR>

" http://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
" set full path of current buffer to unamed register
nmap cp :let @" = expand("%")
