# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy"
# ZSH_THEME="imajes"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git svn mvn golang)

source $ZSH/oh-my-zsh.sh

if [ -x /usr/bin/rlwrap ]; then
    alias mysql='/usr/bin/rlwrap -a -pRED mysql --pager='less -S''
fi

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# zshで特定のコマンドをヒストリに追加しない条件を柔軟に設定する - mollifier delta blog
# http://mollifier.hatenablog.com/entry/20090728/p1
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    # 以下の条件をすべて満たすものだけをヒストリに追加する
    [[ ${#line} -ge 4
        && ${cmd} != (m|man)
    ]]
}

function chpwd() { ls }

alias j="autojump"
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

if [ -x "`which go`" ]; then
    export GOROOT=`go env GOROOT`

    # http://blog.kentarok.org/entry/2014/06/03/135300
    export GOPATH=$HOME
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

# http://d.hatena.ne.jp/kbkbkbkb1/20120429/1335835500
function percol_select_history() {
  local tac_cmd
  which gtac &> /dev/null && tac_cmd=gtac || tac_cmd=tac
  BUFFER=$($tac_cmd ~/.zsh_history | sed 's/^: [0-9]*:[0-9]*;//' \
    | percol --match-method regex --query "$LBUFFER")
  CURSOR=$#BUFFER         # move cursor
  zle -R -c               # refresh
}
zle -N percol_select_history
bindkey '^R' percol_select_history

function search-document-by-percol(){
  DOCUMENT_DIR="\
$HOME/Documents
$HOME/Dropbox"
  SELECTED_FILE=$(echo $DOCUMENT_DIR | xargs find | \
    grep -E "\.(pdf|txt|odp|odt|ods)$" | percol --match-method regex)
  if [ $? -eq 0 ]; then
    open $SELECTED_FILE
  fi
}
alias sd='search-document-by-percol'

function percol_src() {
  local src_dir=$(ghq list --full-path | percol --query "$LBUFFER")
  if [ -n "$src_dir" ]; then
      BUFFER="cd $src_dir"
      zle accept-line
  fi
  # zle clean-screen
  zle -R -c               # refresh
}
zle -N percol_src
bindkey '^S' percol_src

# Customize to your needs...
#
#
source $HOME/.zshrc.mine
