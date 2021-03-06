SHELL := /bin/bash
SUDO ?= sudo
DOCKER ?= docker
F := github.com/modcloth/go-fileutils
TARGETS := $(F)

GINKGO_PATH ?= "."

export GINKGO_PATH

default: test

.PHONY: all
all: clean build test

.PHONY: clean
clean:
	go clean -i -r $(TARGETS) || true

.PHONY: test
test: fmtpolice

.PHONY: deps
deps:
	go get github.com/golang/lint/golint

.PHONY: fmtpolice
fmtpolice: deps fmt lint

.PHONY: fmt
fmt:
	@echo "----------"
	@echo "checking fmt"
	@set -e ; \
	  for f in $(shell git ls-files '*.go'); do \
	  gofmt $$f | diff -u $$f - ; \
	  done

.PHONY: linter
linter:
	go get github.com/golang/lint/golint

.PHONY: lint
lint: linter
	@echo "----------"
	@echo "checking lint"
	@for file in $(shell git ls-files '*.go') ; do \
	  if [[ "$$($(GOPATH)/bin/golint $$file)" =~ ^[[:blank:]]*$$ ]] ; then \
	  echo yayyy >/dev/null ; \
	  else $(MAKE) lintv && exit 1 ; fi \
	  done

.PHONY: lintv
lintv:
	@echo "----------"
	@for file in $(shell git ls-files '*.go') ; do $(GOPATH)/bin/golint $$file ; done
