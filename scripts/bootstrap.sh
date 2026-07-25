#!/usr/bin/env bash
set -Eeuo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
INSTALL_URL="${HERMES_INSTALL_URL:-https://hermes-agent.nousresearch.com/install.sh}"

for command in git curl; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command" >&2
    exit 1
  fi
done

mkdir -p "$HERMES_HOME"

if command -v hermes >/dev/null 2>&1; then
  printf 'Hermes is already installed. Updating through the supported CLI.\n'
  hermes update
else
  printf 'Installing Hermes Agent into HERMES_HOME=%s\n' "$HERMES_HOME"
  curl -fsSL "$INSTALL_URL" | HERMES_HOME="$HERMES_HOME" bash -s -- --skip-setup
fi

printf '\nHermes installation is present. Configure credentials interactively with:\n'
printf '  hermes setup\n'
printf 'Then validate with:\n'
printf '  make validate\n'
