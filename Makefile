# Set up sensible defaults from https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
ifeq ($(origin .RECIPEPREFIX), undefined)
$(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

# Note: you need to put $$ here to pass $ to Bash

.PHONY: all
all:
> @for INF in $$(find . -name "*.txt"); do OUTF="$${INF%.txt}.html"; awk -f parse.awk $$INF | awk -f render.awk > $$OUTF ; done

.PHONY: clean
clean:
> @find . -type f -name "*.html" -exec rm -f {} \;

