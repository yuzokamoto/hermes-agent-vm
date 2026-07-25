#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
load_env

[[ ${INSTALL_GUI:-true} == true ]] || exit 0
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  xfce4 xfce4-goodies lightdm dbus-x11 x11-xserver-utils \
  firefox chromium-browser fonts-noto fonts-noto-color-emoji \
  open-vm-tools-desktop
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm
