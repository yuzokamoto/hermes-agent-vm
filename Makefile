SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

TOFU_DIR := infra/opentofu

.PHONY: help bootstrap validate deploy infra-init infra-plan infra-apply infra-destroy

help:
	@printf '%s\n' \
	  'make bootstrap      Install or update Hermes Agent for the current user' \
	  'make validate       Validate repository files and the local Hermes installation' \
	  'make deploy         Run bootstrap followed by validation' \
	  'make infra-init     Initialize OpenTofu providers' \
	  'make infra-plan     Preview VM infrastructure changes' \
	  'make infra-apply    Provision or update the VM' \
	  'make infra-destroy  Destroy the managed VM infrastructure'

bootstrap:
	@bash scripts/bootstrap.sh

validate:
	@bash scripts/validate.sh

infra-init:
	@tofu -chdir=$(TOFU_DIR) init

infra-plan: infra-init
	@tofu -chdir=$(TOFU_DIR) plan

infra-apply: infra-init
	@tofu -chdir=$(TOFU_DIR) apply

infra-destroy: infra-init
	@tofu -chdir=$(TOFU_DIR) destroy

deploy: bootstrap validate
