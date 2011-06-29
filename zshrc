# users generic .zshrc file for zsh(1)
#

# import
. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion

# use .localrc for setting specific to one system
# [[ -f ~/.localrc ]] && . ~/.localrc
## load user .zshrc configuration file
#
[[ -f ${HOME}/.zshrc.mine ]] && source ${HOME}/.zshrc.mine
