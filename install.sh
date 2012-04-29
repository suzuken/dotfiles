#!/bin/sh
cd $(dirname $0)

# install vundle.git
git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# create symbolic link
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done
