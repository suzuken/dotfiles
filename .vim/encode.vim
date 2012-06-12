"=============================================================================
"    Description: UTF-8化と文字コード自動認識設定
"                 http://www.kawaz.jp/pukiwiki/?vimを改変
"         Author: fuenor <fuenor@gmail.com>
"                 http://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-utf8
"  Last Modified: 2011-03-06 13:03
"        Version: 1.18
"=============================================================================

let s:MSWindows = has('win95') + has('win16') + has('win32') + has('win64')
"制御ファイルの読み出し先設定
if isdirectory($HOME . '/.vim')
  let s:CFGHOME=$HOME.'/.vim'
elseif isdirectory($HOME . '/vimfiles')
  let s:CFGHOME=$HOME.'/vimfiles'
elseif isdirectory($VIM . '/vimfiles')
  let s:CFGHOME=$VIM.'/vimfiles'
endif

"vimfiles (.vim) に特定のファイルが存在する場合は以下のように設定される。
"デフォルトはUTF-8
"--------------------------------------------------------------
"| ファイル名    |                                            |
"|---------------|---------------------------------------------
"| cp932         | 内部エンコーディングをcp932に設定。        |
"| cp932+        | 内部エンコーディングがutf-8の時、          |
"|               | 文字コードの自動認識をcp932優先に設定。    |
"| utf-8-console | Windowsの非GUI(コンソール版)をUTF-8に設定。|
"--------------------------------------------------------------
if !has('gui_running') && s:MSWindows
  set termencoding=cp932
  "Windowsの非GUI版は内部エンコーディングをUTF-8にすると漢字入力出来ないので、
  "内部エンコーディングをcp932にする
  if filereadable(s:CFGHOME . '/utf-8-console')
    set encoding=utf-8
  else
    "強制的にcp932に変更
    set encoding=cp932
  endif
elseif filereadable(s:CFGHOME . '/cp932')
  set encoding=cp932
"elseif filereadable(s:CFGHOME . '/utf-8')
"  set encoding=utf-8
else
  "デフォルト
  set encoding=utf-8
endif

"Kaoriya版を使用している時
if has('Kaoriya')
  "WindowsのKaoriya版でUTF-8にしたい場合はruntime/encode_japan.vimを
  "vimfiles/pluginjpへコピーしてencode_kaoriya.vimへリネームする。
  "それからencode_kaoriya.vimの set encoding=japan 以下を改変する。
  "  set encoding=japan
  "  "---- ここから追加 ----
  "  if has('gui_running')
  "    set encoding=utf-8
  "  endif
  "  "---- ここまで追加 ----
  "  call s:CheckIconvCapability()
  "  call s:DetermineFileencodings()

  "制御ファイルが存在する場合
  let file = s:CFGHOME . '/pluginjp/encode_kaoriya.vim'
  if filereadable(file)
    exec 'source '.file
  endif
  finish
endif

"fileencodingsをデフォルトに戻す。
if &encoding == 'utf-8'
  set fileencodings=ucs-bom,utf-8,default,latin1
elseif &encoding == 'cp932'
  set fileencodings=ucs-bom
endif

" 文字コード自動認識のためにfileencodingsを設定する
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  "utf-8優先にする
  if &encoding == 'utf-8'
    if !filereadable(s:CFGHOME . '/cp932+')
      set fileencodings-=utf-8
      let &fileencodings = substitute(&fileencodings, s:enc_jis, s:enc_jis.',utf-8','')
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

unlet s:CFGHOME
let vimrc_set_encoding = 1

" 改行コードの自動認識
"set fileformats=dos,unix,mac

if exists("loaded_ReCheckFENC")
  finish
endif
let loaded_ReCheckFENC = 1

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
      if s:MSWindows
        let &fileencoding='cp932'
      endif
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

"----------------------------------------
" Windowsで内部エンコーディングを cp932以外にしていて、
" 環境変数に日本語を含む値を設定したい場合に使用する
" Let $HOGE=$USERPROFILE.'/ほげ'
"----------------------------------------
command! -nargs=+ Let call Let__EnvVar__(<q-args>)
function! Let__EnvVar__(cmd)
  let cmd = 'let ' . a:cmd
  if has('win32') + has('win64') && has('iconv') && &enc != 'cp932'
    let cmd = iconv(cmd, &enc, 'cp932')
  endif
  exec cmd
endfunction

