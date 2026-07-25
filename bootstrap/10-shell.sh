#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
load_env

install -m 0644 config/bash/bashrc "$HOME/.bashrc.d-hermes"
install -m 0644 config/tmux/tmux.conf "$HOME/.tmux.conf"

grep -qF '.bashrc.d-hermes' "$HOME/.bashrc" || cat >> "$HOME/.bashrc" <<'EOF'

# hermes-agent-vm managed shell configuration
[[ -f "$HOME/.bashrc.d-hermes" ]] && source "$HOME/.bashrc.d-hermes"
EOF

if [[ -n ${GIT_USER_NAME:-} ]]; then git config --global user.name "$GIT_USER_NAME"; fi
if [[ -n ${GIT_USER_EMAIL:-} ]]; then git config --global user.email "$GIT_USER_EMAIL"; fi
git config --global init.defaultBranch main
git config --global pull.ff only
git config --global fetch.prune true
git config --global rerere.enabled true
git config --global core.autocrlf input
