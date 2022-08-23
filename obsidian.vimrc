" copy this file to VAULT_ROOT/.obsidian.vimrc
" see https://github.com/esm7/obsidian-vimrc-support in detail

set clipboard=unnamed

" behavior like :q in vim
exmap q obcommand workspace:close
exmap vs obcommand workspace:split-vertical
exmap sp obcommand workspace:split-horizontal

exmap reload obcommand app:reload
exmap b obcommand app:go-back
exmap f obcommand app:go-forward

exmap tabnext obcommand cycle-through-panes:cycle-through-panes
nmap gt :tabnext
exmap tabprev obcommand cycle-through-panes:cycle-through-panes-reverse
nmap gT :tabprev
