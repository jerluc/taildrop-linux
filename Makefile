cur_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
install_prefix := ${HOME}/.local
nautilus_scripts_dir := ${install_prefix}/share/nautilus/scripts
install_dir := ${nautilus_scripts_dir}/.bin

.PHONY: clean

clean:
	rm -rf $(cur_dir)/dist/

deps:
	go mod tidy

build: deps
	go build -o $(cur_dir)/dist/taildrop $(cur_dir)/cmd/main.go

install: build
	mkdir -p $(install_dir)
	mkdir -p $(nautilus_scripts_dir)
	cp $(cur_dir)/dist/taildrop $(install_dir)
	cp scripts/* $(nautilus_scripts_dir)
	gio set -t 'string' $(nautilus_scripts_dir)/Taildrop 'metadata::custom-icon' 'file://$(nautilus_scripts_dir)/taildrop.png'

all: clean deps build
