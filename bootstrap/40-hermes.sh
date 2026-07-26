#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
load_env

mkdir -p "$HERMES_HOME" "$WORKSPACE_ROOT" "$KNOWLEDGE_ROOT"
chmod 700 "$HERMES_HOME"

curl -fsSL "$HERMES_INSTALL_URL" | bash -s -- --skip-setup

# The Hermes installer updates the interactive shell configuration, but this
# bootstrap process is still running in the original non-interactive shell.
# Add the standard user binary locations immediately so verification works
# without requiring a logout or manual `source ~/.bashrc`.
export PATH="$HOME/.local/bin:$HOME/.hermes/bin:$PATH"
hash -r

if command_exists hermes; then
  hermes doctor || true
else
  echo "Hermes executable was not found after installation." >&2
  echo "Searched user paths: $HOME/.local/bin and $HOME/.hermes/bin" >&2
  exit 1
fi
