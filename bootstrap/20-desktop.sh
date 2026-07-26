#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
load_env

if ! dpkg-query -W -f='${Status}' ubuntu-desktop-minimal 2>/dev/null | grep -q 'install ok installed'; then
  echo "Ubuntu Desktop is required. Install this repository on Ubuntu Desktop 24.04 or 26.04 LTS." >&2
  exit 1
fi

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  open-vm-tools-desktop fonts-noto fonts-noto-color-emoji
sudo systemctl set-default graphical.target
