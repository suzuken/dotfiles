all: install

install: deps brew tools link

vim/autoload/plug.vim:
	curl -fLo $@ --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

deps: vim/autoload/plug.vim
	mkdir -p $(HOME)/.vimtmp
	mkdir -p $(HOME)/.vimback
	which brew || /usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

${HOME}/src/github.com/zsh-users/antigen:
	git clone git@github.com:zsh-users/antigen.git $@

brew:
	brew install wget lv hub go zsh tig tree the_silver_searcher tmux reattach-to-user-namespace coreutils
	brew cleanup

tools:
	go get -u github.com/peco/peco/cmd/peco
	go get -u github.com/motemen/ghq
	go get -u github.com/nsf/gocode

PWD:=$(shell pwd)
srcs:=vimrc vim gitconfig zshrc tmux.conf
link: ${HOME}/src/github.com/zsh-users/antigen
	$(foreach src,$(srcs),ln -Fs $(PWD)/$(src) $(HOME)/.$(src);)

$HOME/.zshrc.mine:
	touch $(HOME)/.zshrc.mine
