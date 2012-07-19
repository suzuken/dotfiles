"----------------------------------------------------
"" smartchr
" @see http://d.hatena.ne.jp/ampmmn/20080925/1222338972
"----------------------------------------------------

" 演算子の間に空白を入れる
" inoremap <buffer><expr> < search('^#include\%#', 'bcn')? ' <': smartchr#one_of(' < ', ' << ', '<')
" inoremap <buffer><expr> > search('^#include <.*\%#', 'bcn')? '>': smartchr#one_of(' > ', ' >> ', '>')
inoremap <buffer><expr> + smartchr#one_of(' + ', '++', '+')
" inoremap <buffer><expr> - smartchr#one_of(' - ', '--', '-')
" inoremap <buffer><expr> / smartchr#one_of(' / ', '// ', '/')
" *はポインタで使うので、空白はいれない
inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
inoremap <buffer><expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')
inoremap <buffer><expr> , smartchr#one_of(', ', ',')
" 3項演算子の場合は、後ろのみ空白を入れる
inoremap <buffer><expr> ? smartchr#one_of('? ', '?')
inoremap <buffer><expr> : smartchr#one_of(': ', '::', ':')

" =の場合、単純な代入や比較演算子として入力する場合は前後にスペースをいれる。
" 複合演算代入としての入力の場合は、直前のスペースを削除して=を入力
" inoremap <buffer><expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
                " \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
                " \ : smartchr#one_of(' = ', ' == ', '=')

" 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
" 「->」は入力しづらいので、..で置換え
" inoremap <buffer><expr> . smartchr#loop('.', '->', '...')
" 行先頭での@入力で、プリプロセス命令文を入力
inoremap <buffer><expr> @ search('^\(#.\+\)\?\%#','bcn')? smartchr#one_of('#define', '#include', '#ifdef', '#endif', '@'): '@'

inoremap <buffer><expr> " search('^#include\%#', 'bcn')? ' "': '"'
" if文直後の(は自動で間に空白を入れる
inoremap <buffer><expr> ( search('\<\if\%#', 'bcn')? ' (': '('
