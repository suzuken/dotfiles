let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" golang
if $GOROOT != ''
  exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
  autocmd FileType go :set completeopt=menu,preview
endif

" indent
au BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

" override default gd option of vim-go, use split
nmap gs <Plug>(go-def-split)
let g:go_def_reuse_buffer=1

augroup QuickRunGoTest
  autocmd!
  autocmd BufWinEnter,BufNewFile *test.go set filetype=go.test
augroup END
let g:quickrun_config['go.test'] = {'command': 'go', 'cmdopt': 'test -v'}
