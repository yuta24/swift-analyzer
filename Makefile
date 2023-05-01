VERSION_FILE := version.txt
BIN_PATH := $(shell swift build -c release --show-bin-path)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":[^#]*? #| #"}; {printf "%-42s%s\n", $$1 $$3, $$2}'

.PHONY: bootstrap
bootstrap: # bootstrap: setup project
	@echo "enum Version { static let value = \"$(shell cat $(VERSION_FILE))\" }" > Sources/SwiftAnalyzer/Version.swift

.PHONY: build
build: # build: build the project for debug
	@swift build -c debug

.PHONY: release
release: # build: build the project for release
	@swift build -c release

.PHONY: archive
archive: release # build: build the project for release
	@zip -j -X swift-analyzer.zip $(BIN_PATH)/swift-analyzer
