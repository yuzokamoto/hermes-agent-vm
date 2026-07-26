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
for cmd in git gh tmux node npm python3 uv docker codex claude promptfoo restic hermes; do
  check "$cmd" command -v "$cmd"
done
check "Hermes doctor" hermes doctor
check "SSH service" systemctl is-active ssh
check "Firewall" sudo ufw status
check "Docker service" systemctl is-active docker
check "VMware tools" systemctl is-active open-vm-tools

if [[ ${BACKUP_ENABLED:-true} == true && -n ${RESTIC_PASSWORD:-} ]]; then
  check "Restic repository" env RESTIC_PASSWORD="$RESTIC_PASSWORD" restic -r "$RESTIC_REPOSITORY" check
fi

exit "$fail"
