VERSION_FILE := version.txt

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":[^#]*? #| #"}; {printf "%-42s%s\n", $$1 $$3, $$2}'

.PHONY: bootstrap
bootstrap: # bootstrap: setup project
	@echo "enum Version { static let value = \"$(shell cat $(VERSION_FILE))\" }" > Sources/SwiftAnalyzer/Version.swift

.PHONY: build
build: # build: build the project
	swift build -c debug
