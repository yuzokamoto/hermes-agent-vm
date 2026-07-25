SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help bootstrap validate deploy

help:
	@printf '%s\n' \
	  'make bootstrap  Install or update Hermes Agent for the current user' \
	  'make validate   Validate repository files and the local Hermes installation' \
	  'make deploy     Run bootstrap followed by validation'

bootstrap:
	@bash scripts/bootstrap.sh

validate:
	@bash scripts/validate.sh

deploy: bootstrap validate
