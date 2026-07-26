#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
source bootstrap/lib.sh
load_env

fail=0
check() {
  local name=$1; shift
  if "$@" >/dev/null 2>&1; then printf 'PASS  %s\n' "$name"; else printf 'FAIL  %s\n' "$name"; fail=1; fi
}

check "Supported Ubuntu LTS" bash -c 'source /etc/os-release; [[ "$ID" == ubuntu && ("$VERSION_ID" == 24.04* || "$VERSION_ID" == 26.04*) ]]'
check "Ubuntu Desktop" dpkg-query -W ubuntu-desktop-minimal
for cmd in git gh tmux mise node npm python3 uv codex claude promptfoo hermes; do
  check "$cmd" bash -lc "command -v $cmd"
done
check "Hermes doctor" bash -lc 'hermes doctor'
check "SSH service" systemctl is-active ssh
check "Firewall" sudo ufw status
check "VMware tools" systemctl is-active open-vm-tools

if [[ ${INSTALL_DOCKER:-true} == true ]]; then
  check "docker" command -v docker
  check "Docker service" systemctl is-active docker
fi

exit "$fail"
