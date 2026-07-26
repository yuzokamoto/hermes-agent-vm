SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help bootstrap configure verify safe-suspend eval validate

help:
	@printf '%s\n' \
	  'make bootstrap      Configure a clean Ubuntu 24.04 VMware workstation' \
	  'make configure      Install managed Hermes policy and guide OAuth setup' \
	  'make verify         Run workstation health and dependency checks' \
	  'make safe-suspend   Verify and sync before suspending VMware' \
	  'make eval           Run prompt/provider regression evaluations' \
	  'make validate       Check Bash syntax, blocking ShellCheck errors and environment contract'

bootstrap:
	@bash scripts/bootstrap-workstation.sh

configure:
	@bash scripts/configure-workstation.sh

verify:
	@bash scripts/verify-workstation.sh

safe-suspend:
	@bash scripts/safe-suspend.sh

eval:
	@npx promptfoo eval -c evals/promptfooconfig.yaml

validate:
	@find bootstrap scripts -type f -name '*.sh' -print0 | xargs -0 -n1 bash -n
	@find bootstrap scripts -type f -name '*.sh' -print0 | xargs -0 shellcheck -S error -x -e SC1091
	@test -f .env.example
	@grep -q '^WORKSTATION_USER=' .env.example
