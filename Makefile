all: install

install: deps tools vimperator/vimperator-plugins link

vim/autoload/plug.vim:
	curl -fLo $@ --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

deps: vim/autoload/plug.vim
	mkdir -p $(HOME)/.vimtmp
	mkdir -p $(HOME)/.vimback
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

${HOME}/src/github.com/zsh-users/antigen:
	git clone git@github.com:zsh-users/antigen.git $@

brew:
	brew install wget
	brew install lv
	brew install hub
	brew install go
	brew install zsh
	brew install tig
	brew install tree
	brew cleanup

tools:
	go get -u github.com/peco/peco/cmd/peco
	go get -u github.com/motemen/ghq
	go get -u github.com/nsf/gocode

vimperator/vimperator-plugins:
	git clone https://github.com/vimpr/vimperator-plugins.git $@
	ln -s $@/plugin_loader.js vimperator/plugin/

PWD:=$(shell pwd)
srcs:=vimrc vim vimperator vimperatorrc gitconfig vi zshrc tmux.conf
link: zshrc.mine
	$(foreach src,$(srcs),ln -Fs $(PWD)/$(src) $(HOME)/.$(src);)

$HOME/.zshrc.mine:
	touch $(HOME)/.zshrc.mine

update-vimperator-plugins:
	cd ./vimperator/vimperator-plugins && git pull origin master
