install_prefix := ${HOME}/.local
install_dir := ${install_prefix}/share/nautilus/scripts/

.PHONY: clean

clean:
	rm -rf dist/

deps:
	go mod tidy

build: deps
	go build -o dist/taildrop cmd/main.go

install: build
	cp dist/taildrop $(install_dir)
	cp scripts/* $(install_dir)
	gio set -t 'string' $(install_dir)/Taildrop 'metadata::custom-icon' 'file://$(install_dir)/taildrop.png'

all: clean deps build
