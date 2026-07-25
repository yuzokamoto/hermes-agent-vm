#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."

for step in \
  bootstrap/00-system.sh \
  bootstrap/10-shell.sh \
  bootstrap/20-desktop.sh \
  bootstrap/30-dev-tools.sh \
  bootstrap/40-hermes.sh; do
  echo "==> $step"
  bash "$step"
done

echo
printf '%s\n' \
  'Bootstrap complete.' \
  '1. Reboot the VM.' \
  '2. Run: make configure' \
  '3. Run: make verify'
