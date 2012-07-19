" No audible bell
set vb

" No toolbar
set guioptions-=T

" Use console dialogs
set guioptions+=c

"gvim configuration
if has('gui_macvim')
    set showtabline=2  "// タブを常に表示
    set imdisable      "// IMを無効化
    set transparency=5 "// 透明度を指定
    map <silent> gw :macaction selectNextWindow:
    map <silent> gW :macaction selectPreviousWindow:
    colorscheme macvim

    if has("gui_running")
        set fuoptions=maxvert,maxhorz
        au GUIEnter * set fullscreen
    endif
endif

" Local config
if filereadable($HOME . "/.gvimrc.local")
  source ~/.gvimrc.local
endif
