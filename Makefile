all: install

install: vim/bundle/bundle prepare tools vimperator/vimperator-plugins link

vim/bundle/vundle:
	git clone http://github.com/gmarik/vundle.git $@

prepare:
	git submodule init
	git submodule update

tools:
	go get -u github.com/peco/peco/cmd/peco
	go get -u github.com/motemen/ghq
	go get -u github.com/jstemmer/gotags
	go get -u github.com/rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	go get -u github.com/nsf/gocode

vimperator/vimperator-plugins:
	git clone https://github.com/vimpr/vimperator-plugins.git $@
	ln -s $@/plugin_loader.js vimperator/plugin/

PWD:=$(shell pwd)
srcs:=vimrc vim vimperator vimperatorrc gitconfig vi zshrc tmux.conf
link:
	$(foreach src,$(srcs),ln -Fs $(PWD)/$(src) $(HOME)/.$(src);)

update-vimperator-plugins:
	cd ./vimperator/vimperator-plugins && git pull origin master

update-oh-my-zsh:
	cd oh-my-zsh && git fetch fork_master && git merge remotes/fork_master/master
