all: install

install: deps brew link

vim/autoload/plug.vim:
	curl -fLo $@ --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

deps: vim/autoload/plug.vim
	mkdir -p $(HOME)/.vimtmp
	mkdir -p $(HOME)/.vimback
	which brew || /usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

brew:
	brew install wget lv hub go zsh tig tree the_silver_searcher tmux reattach-to-user-namespace coreutils ghq peco node
	brew cleanup

PWD:=$(shell pwd)
srcs:=vimrc vim gitconfig zshrc tmux.conf ideavimrc ctags
link:
	$(foreach src,$(srcs),ln -Fs $(PWD)/$(src) $(HOME)/.$(src);)

$HOME/.zshrc.mine:
	touch $(HOME)/.zshrc.mine

.PHONY: install deps brew link
