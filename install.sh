#!/bin/sh
cd $(dirname $0)

# install vundle.git
if [ ! -f "$PWD/vim/bundle/vundle" ]; then
    git clone http://github.com/gmarik/vundle.git "$PWD/vim/bundle/vundle"
fi

# update submodule
git submodule init
git submodule update
if [ -f "$PWD/oh-my-zsh" ]; then
    cd .oh-my-zsh
    git checkout master
    cd ..
fi

go get github.com/peco/peco/cmd/peco

go get github.com/motemen/ghq
go get github.com/jstemmer/gotags
go get github.com/rogpeppe/godef

# load vimperator plugins
if [[ ! -f "$PWD/vimperator/vimperator-plugins" ]]; then
    git clone https://github.com/vimpr/vimperator-plugins.git vimperator/vimperator-plugins
    ln -s $PWD/vimperator/vimperator-plugins/plugin_loader.js $PWD/vimperator/plugin/
fi

# create symbolic link
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != 'Rakefile' ] && [ $dotfile != 'README.md' ] && [ $dotfile != '.*.sample' ] && [ $dotfile != 'install.*' ]; then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done
