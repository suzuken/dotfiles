all: install

install:
	./install.sh

update-oh-my-zsh:
	cd oh-my-zsh && git fetch fork_master && git merge remotes/fork_master/master
