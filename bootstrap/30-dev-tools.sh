#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
load_env

if ! command_exists mise; then
  sudo add-apt-repository -y ppa:jdxcode/mise
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mise
fi

install -d -m 700 "$HOME/.config/mise"
install -m 0600 mise.toml "$HOME/.config/mise/config.toml"
mise install --minimum-release-age "${PACKAGE_MINIMUM_RELEASE_AGE:-3d}"

if [[ ${INSTALL_DOCKER:-true} == true ]] && ! command_exists docker; then
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io docker-compose-v2
  sudo usermod -aG docker "$USER"
  sudo systemctl enable --now docker
fi

if [[ ${INSTALL_TAILSCALE:-false} == true ]] && ! command_exists tailscale; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi
