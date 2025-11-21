.PHONY: deps build test package

deps:
	go mod tidy
	cd python/license_scanner && poetry install

build:
	go build -o ../../pkg/chimera ./...
	poetry -C python/license_scanner build

test:
	go test ./... -v
	poetry -C python/license_scanner run pytest

package:
	cp chimera ../../pkg/
