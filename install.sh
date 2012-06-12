#!/bin/sh
cd $(dirname $0)

# install vundle.git
if [ ! -f ~/.vim/bundle/vundle ]; then
    git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi

# update submodule
git submodule init
git submodule update
if [ -f oh-my-zsh ]; then
    cd oh-my-zsh
    git checkout master
fi

# create symbolic link
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ] && [ $dotfile != '.gitmodules']
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done
