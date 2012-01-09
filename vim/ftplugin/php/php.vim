" ---------------------------
" php
" ---------------------------
let g:pdv_cfg_Type = "string"
let g:pdv_cfg_Package = ""
let g:pdv_cfg_Version = "$id$"
let g:pdv_cfg_Author = "Kenta Suzuki <suzuken326@gmail.com>"
let g:pdv_cfg_Copyright = "Copyright (C) 2011 Kenta Suzuki. All Rights Reserved."
let g:pdv_cfg_License = "PHP Version 5.3 {@link http://www.php.net/license/5_3.txt}"
inoremap <C-P><C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P><C-P> :call PhpDocSingle()<CR>
vnoremap <C-P><C-P> :call PhpDocRange()<CR>

" ===========================
" smartchr settings for php
" ===========================
inoremap <buffer><expr> - smartchr#one_of(' - ', '->', '-')
