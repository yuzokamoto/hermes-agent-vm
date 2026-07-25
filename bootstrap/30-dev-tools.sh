#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
load_env

if ! command_exists uv; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
if ! command_exists node; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
fi
sudo npm install -g @openai/codex @anthropic-ai/claude-code promptfoo

if [[ ${INSTALL_DOCKER:-true} == true ]] && ! command_exists docker; then
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker "$USER"
  sudo systemctl enable --now docker
fi

if [[ ${INSTALL_TAILSCALE:-false} == true ]] && ! command_exists tailscale; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi
