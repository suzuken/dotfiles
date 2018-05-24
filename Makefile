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
	brew install wget lv hub go zsh tig tree the_silver_searcher tmux reattach-to-user-namespace coreutils ghq peco
	brew cleanup

cask:
	brew cask install chrome
	which docker || brew install docker
	which code || brew cask install visual-studio-code

tools:
	go get -u github.com/nsf/gocode

PWD:=$(shell pwd)
srcs:=vimrc vim gitconfig zshrc tmux.conf ideavimrc ctags
link: ${HOME}/src/github.com/zsh-users/antigen
	$(foreach src,$(srcs),ln -Fs $(PWD)/$(src) $(HOME)/.$(src);)

$HOME/.zshrc.mine:
	touch $(HOME)/.zshrc.mine

.PHONY: install deps brew tools link
