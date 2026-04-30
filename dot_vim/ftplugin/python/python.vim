" settings for python
set encoding=utf8
set expandtab

" PEP 8 Indent rule
set textwidth=0
set tabstop=8
set softtabstop=4
set shiftwidth=4
set smarttab
set nosmartindent
set autoindent
setl cindent
setl textwidth=80
setl colorcolumn=80

set ruler
set commentstring=\ #\ %s
set foldlevel=0
syntax on

autocmd BufNewFile,BufRead *_test.py compiler nose

let g:quickrun_config['*'] = {'runner': 'vimproc'}
