#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

load_env() {
  if [[ ! -f "$REPO_ROOT/.env" ]]; then
    echo "Missing .env. Run: cp .env.example .env" >&2
    exit 1
  fi
  set -a
  # shellcheck disable=SC1091
  source "$REPO_ROOT/.env"
  set +a
  : "${TIMEZONE:=America/Sao_Paulo}"
  : "${LOCALE:=en_US.UTF-8}"
  : "${WORKSPACE_ROOT:=$HOME/workspaces}"
  : "${KNOWLEDGE_ROOT:=$HOME/knowledge}"
  : "${HERMES_HOME:=$HOME/.hermes}"
}

require_supported_ubuntu() {
  # shellcheck disable=SC1091
  source /etc/os-release
  if [[ "$ID" != ubuntu ]]; then
    echo "Supported operating system: Ubuntu 24.04 or 26.04 LTS. Found: $PRETTY_NAME" >&2
    exit 1
  fi

  case "$VERSION_ID" in
    24.04*|26.04*) ;;
    *)
      echo "Supported baselines: Ubuntu 24.04 and 26.04 LTS. Found: $PRETTY_NAME" >&2
      exit 1
      ;;
  esac
}

command_exists() { command -v "$1" >/dev/null 2>&1; }
