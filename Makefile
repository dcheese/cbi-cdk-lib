

.PHONY: login help install build publish test clean

ORG=ConstellationBrands

default: help

login:
	npm login --scope=$(ORG) --auth-type=legacy --registry=https://npm.pkg.github.com

install: ## Install dependencies
	npm install

build: install ## Builds the package
	npm run build

publish: build ## Publish a major release
	npm publish

test: install ## Run the test
	npm test

clean: ## Removes all build, test artifacts
	rm -rf build \
	rm -rf node_modules
	find . -name '*.js' ! -name 'jest.config.js' -exec rm -fr {} + 
	find . -name '*.d.ts' -exec rm -fr {} + 
	find . -name '*~' -exec rm -f {} +
help:
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''

