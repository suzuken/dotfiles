all: install

install: deps tools vimperator/vimperator-plugins link

vim/bundle/vundle:
	git clone http://github.com/gmarik/vundle.git $@

deps: vim/bundle/vundle

tools:
	go get -u github.com/peco/peco/cmd/peco
	go get -u github.com/motemen/ghq
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
