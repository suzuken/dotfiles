" ==========
" javascript
" ==========
inoremap <C-P><C-P> :<ESC>call WriteJSDocComment()<CR>i
nnoremap <C-P><C-P> :call WriteJSDocComment()<CR>
vnoremap <C-P><C-P> :call WriteJSDocComment()<CR>

compiler javascriptlint

if !exists('b:undo_ftplugin')
    let b:undo_ftplugin = ''
endif

let b:undo_ftplugin .= '
\ | setlocal makeprg<
\ | setlocal errorformat<
\'
