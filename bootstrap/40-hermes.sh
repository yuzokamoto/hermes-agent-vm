#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
load_env

mkdir -p "$HERMES_HOME" "$WORKSPACE_ROOT" "$KNOWLEDGE_ROOT"
chmod 700 "$HERMES_HOME"

curl -fsSL "$HERMES_INSTALL_URL" | bash -s -- --skip-setup

if command_exists hermes; then
  hermes doctor || true
else
  echo "Hermes executable was not found after installation." >&2
  exit 1
fi
