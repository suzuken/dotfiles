#!/usr/bin/env bash
set -euo pipefail

PLUG="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG" ]; then
    mkdir -p "$(dirname "$PLUG")"
    curl -fLo "$PLUG" \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
