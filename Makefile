all: install

install:
	./install.sh

update-vimperator-plugins:
	cd ./vimperator/vimperator-plugins && git pull origin master

update-oh-my-zsh:
	cd oh-my-zsh && git fetch fork_master && git merge remotes/fork_master/master
