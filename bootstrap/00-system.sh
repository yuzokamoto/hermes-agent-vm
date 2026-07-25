#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ${EUID} -eq 0 ]]; then
  echo "Run as the regular workstation user, not root." >&2
  exit 1
fi

source "$(dirname "$0")/lib.sh"
load_env
require_ubuntu_2404

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential ca-certificates curl wget gnupg jq unzip zip p7zip-full \
  git git-lfs gh ripgrep fd-find fzf bat tree htop btop ncdu tmux \
  shellcheck shfmt python3 python3-venv python3-pip pipx sqlite3 \
  openssh-server ufw fail2ban unattended-upgrades restic open-vm-tools
sudo apt-get autoremove -y

sudo timedatectl set-timezone "$TIMEZONE"
sudo locale-gen "$LOCALE"
sudo update-locale LANG="$LOCALE"
sudo systemctl enable --now ssh fail2ban unattended-upgrades
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw --force enable

mkdir -p "$WORKSPACE_ROOT" "$KNOWLEDGE_ROOT" "$HOME/.local/bin"
echo "Base system configured. Reboot after make bootstrap completes."
