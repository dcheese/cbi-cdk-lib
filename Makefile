

.PHONY: help deploy destroy build clean node_modules

stackName=cbi-cdk-eks
configFile="dev.json"

domain=sandbox
repository=cdk
namespace=cdk-solution
package=cdk-eks
version=0.0.0

help:
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''

deploy: build ## Deploys the stack to the default account and region
	cdk deploy --require-approval never -c stackName=${stackName} -c configFile=${configFile}

destroy: ## Removes the default stack 
	cdk destroy -c stackName=${stackName}

install:
	npm install

build: install ## Run the CDK test apps 
	npm run build

unpublish:
	- aws codeartifact delete-package-versions --domain $(domain) --repository $(repository) --format npm --package $(package) --namespace $(namespace) --versions ${version}

publish: build
	npm publish

docs: build
	npx typedoc --plugin typedoc-plugin-markdown --theme markdown --out docs lib --excludeNotDocumented
	
test: install ## Builds the CDK app 
	npm test

clean: ## Removes all build, test artifacts
	rm -rf docs/*
	rm -rf cdk.context.json \
	rm -rf build \
	rm -rf node_modules
	find . -name '*.js' ! -name 'jest.config.js' -exec rm -fr {} + 
	find . -name '*.d.ts' -exec rm -fr {} + 
	find . -name '*.pyc' -exec rm -fr {} + 
	find . -name '__pycache__' -exec rm -fr {} + 
	find . -name '*~' -exec rm -f {} +
