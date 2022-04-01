.PHONY: clean

clean:
	rm -rf dist/

deps:
	go mod tidy

build: deps
	go build -o dist/taildrop cmd/main.go

install: build
	cp dist/taildrop ~/.local/share/nautilus/scripts/
	cp scripts/* ~/.local/share/nautilus/scripts/

all: clean deps build
