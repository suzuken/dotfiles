" ---------------------------
" php
" ---------------------------
let g:pdv_cfg_Type = "string"
" let g:pdv_cfg_Package = ""
" let g:pdv_cfg_Version = "$id$"
" let g:pdv_cfg_Author = "Kenta Suzuki <Ke-Suzuki@voyagegroup.com>"
" let g:pdv_cfg_Copyright = "Copyright (C) 2013 Adingo, Inc. All Rights Reserved."
" let g:pdv_cfg_License = "PHP Version 5.3 {@link http://www.php.net/license/5_3.txt}"
" inoremap <C-P><C-D> <ESC>:call PhpDoc()<CR>i
nnoremap <C-P><C-D> :call PhpDoc()<CR>
" vnoremap <C-P><C-D> :call PhpDocRange()<CR>

" setting for PHPUnit
" http://www.phpunit.de/manual/current/en/
" see also http://d.hatena.ne.jp/ruedap/20110225/vim_php_phpunit_quickrun
augroup QuickRunPHPUnit
  autocmd!
  " all *test.php files are defined filetype as phpunit.
  autocmd BufWinEnter,BufNewFile *test.php set filetype=php.unit
  autocmd BufWinEnter,BufNewFile *Test.php set filetype=php.unit
augroup END
" PHPUnit
let g:quickrun_config['php.unit'] = {'command': 'phpunit'}

