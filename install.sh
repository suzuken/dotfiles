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

# create symbolic link
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != 'Rakefile' ] && [ $dotfile != 'README.md' ] && [ $dotfile != '.*.sample' ] && [ $dotfile != 'install.*' ]; then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done
