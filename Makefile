all: install

PWD := $(shell pwd)

install:
	which chezmoi || brew install chezmoi
	chezmoi init --apply --source $(PWD)

.PHONY: install
