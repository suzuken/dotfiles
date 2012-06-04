" ---------------------------
" php
" ---------------------------
let g:pdv_cfg_Type = "string"
let g:pdv_cfg_Package = ""
let g:pdv_cfg_Version = "$id$"
let g:pdv_cfg_Author = "Kenta Suzuki <suzuken326@gmail.com>"
let g:pdv_cfg_Copyright = "Copyright (C) 2012 Trippiece, Inc. All Rights Reserved."
let g:pdv_cfg_License = "PHP Version 5.3 {@link http://www.php.net/license/5_3.txt}"
inoremap <C-P><C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P><C-P> :call PhpDocSingle()<CR>
vnoremap <C-P><C-P> :call PhpDocRange()<CR>

" setting for PHPUnit
" http://www.phpunit.de/manual/current/en/
" see also http://d.hatena.ne.jp/ruedap/20110225/vim_php_phpunit_quickrun
augroup QuickRunPHPUnit
  autocmd!
  " all *test.php files are defined filetype as phpunit.
  autocmd BufWinEnter,BufNewFile *test.php set filetype=php.unit
  autocmd BufWinEnter,BufNewFile *Test.php set filetype=php.unit
augroup END

let g:quickrun_config = {}

" quickrun.vimで実行したPHPUnitの結果にグリーンバーを出す - Inquisitive!
" http://d.hatena.ne.jp/uk_oasis/20110928/1317217247
" make outputter for coloring output message.
let phpunit_outputter = quickrun#outputter#buffer#new()
function! phpunit_outputter.init(session)
  " call original process
  call call(quickrun#outputter#buffer#new().init, [a:session], self)
endfunction

function! phpunit_outputter.finish(session)
  " set color
  highlight default PhpUnitOK         ctermbg=Green ctermfg=White
  highlight default PhpUnitFail       ctermbg=Red   ctermfg=White
  highlight default PhpUnitAssertFail ctermfg=Red
  call matchadd("PhpUnitFail","^FAILURES.*$")
  call matchadd("PhpUnitOK","^OK.*$")
  call matchadd("PhpUnitAssertFail","^Failed.*$")
  call call(quickrun#outputter#buffer#new().finish, [a:session], self)
endfunction

" regist outputter to quickrun
call quickrun#register_outputter("phpunit_outputter", phpunit_outputter)

" PHPUNIT
let g:quickrun_config['php.unit'] = {
      \ 'command': 'phpunit',
      \ 'outputter': 'phpunit_outputter',
      \ }


" ===========================
" smartchr settings for php
" ===========================
inoremap <buffer><expr> - smartchr#one_of(' - ', '->', '-')
