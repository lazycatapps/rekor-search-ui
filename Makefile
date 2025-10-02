.PHONY: help build build-dist clean-dist build-lpk dev audit clean deploy-lpk deploy all

# Default values
VERSION ?= latest

HELP_FUN = \
	%help; while(<>){push@{$$help{$$2//'options'}},[$$1,$$3] \
	if/^([\w-_]+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/}; \
	print"\033[1m$$_:\033[0m\n", map"  \033[36m$$_->[0]\033[0m".(" "x(20-length($$_->[0])))."$$_->[1]\n",\
	@{$$help{$$_}},"\n" for keys %help; \

help: ##@General Show this help
	@echo -e "Usage: make \033[36m<target>\033[0m\n"
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

dev: ##@Development Run frontend locally for development
	npm run dev

audit: ##@Development Scan frontend for security vulnerabilities
	@echo "Scanning frontend dependencies for vulnerabilities..."
	@CURRENT_REGISTRY=$$(npm config get registry); \
	npm config set registry https://registry.npmjs.org/; \
	npm audit; \
	AUDIT_EXIT=$$?; \
	npm config set registry $$CURRENT_REGISTRY; \
	exit $$AUDIT_EXIT

build: build-dist ##@Build Build frontend dist

build-dist: ##@Build Build frontend into dist directory
	@echo "Building frontend to dist directory..."
	sh build.sh
	@echo "Frontend dist built successfully!"

build-fast: ##@Build Fast build frontend (skip if dist exists)
	@echo "Fast building frontend..."
	sh build.sh fast
	@echo "Fast build completed!"

build-lpk: ##@Build Build LPK package (requires lzc-cli)
	@echo "Building LPK package..."
	lzc-cli project build
	@echo "LPK package built successfully!"

clean: ##@Maintenance Clean dist directory
	@echo "Cleaning dist directory..."
	-rm -rf ./dist
	@echo "Clean completed!"

clean-dist: ##@Maintenance Clean dist directory only
	@echo "Cleaning dist directory..."
	-rm -rf ./dist

deploy-lpk: build-lpk ##@Deploy Deploy LPK only (no rebuild frontend)
	@echo "Deploying LPK package..."
	@LPK_FILE=$$(ls -t *-v*.lpk 2>/dev/null | head -n 1); \
	if [ -z "$$LPK_FILE" ]; then \
		echo "Error: No LPK file found"; \
		exit 1; \
	fi; \
	echo "Installing $$LPK_FILE..."; \
	lzc-cli app install "$$LPK_FILE"
	@echo "Deployment completed!"

deploy: build-dist deploy-lpk ##@Deploy Build frontend and deploy LPK

deploy-fast: build-fast deploy-lpk ##@Deploy Fast build frontend and deploy LPK

all: deploy ##@Aliases Alias for deploy (default target)
