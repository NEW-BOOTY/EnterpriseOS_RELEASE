.PHONY: all brew deps build test package clean
all: build

brew:
	@which brew >/dev/null 2>&1 || (echo "Installing Homebrew..."; NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")

deps:
	@echo "Installing dependencies..."
	@which jq >/dev/null 2>&1 || brew install jq
	@which yq >/dev/null 2>&1 || brew install yq
	@which git >/dev/null 2>&1 || brew install git

build:
	@echo "Building..."
	@mkdir -p generated

test:
	@echo "Running tests..."
	@bash -n setup.sh

package:
	@echo "Packaging..."
	@tar -czf package.tgz *

clean:
	@rm -rf generated package.tgz
