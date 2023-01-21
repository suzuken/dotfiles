# for homebrew
export PATH=$PATH:/usr/local/bin

plugins=(
  git
  macos
)

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

alias p="popd"

if [ -x "`which go`" ]; then
    # http://blog.kentarok.org/entry/2014/06/03/135300
    export GOPATH=$HOME
    export PATH=$PATH::$GOPATH/bin
fi

# http://d.hatena.ne.jp/kbkbkbkb1/20120429/1335835500
function peco_select_history() {
  local tac_cmd
  which gtac &> /dev/null && tac_cmd=gtac || tac_cmd=tac
  BUFFER=$($tac_cmd ~/.zsh_history | sed 's/^: [0-9]*:[0-9]*;//' \
    | peco --query "$LBUFFER")
  CURSOR=$#BUFFER         # move cursor
  zle -R -c               # refresh
}
zle -N peco_select_history
bindkey '^R' peco_select_history

function peco_src() {
  local src_dir=$(ghq list --full-path | peco --query "$LBUFFER")
  if [ -n "$src_dir" ]; then
      BUFFER="cd $src_dir"
      zle accept-line
  fi
  # zle clean-screen
  zle -R -c               # refresh
}
zle -N peco_src
bindkey '^S' peco_src

# Prompt setting
# PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} %D %T % %{$reset_color%}'
PROMPT='%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%r]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} $(git_prompt_info)
%{$fg[blue]%}$%{$reset_color%} '

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Customize to your needs...
#
#
source $HOME/.zshrc.mine
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
