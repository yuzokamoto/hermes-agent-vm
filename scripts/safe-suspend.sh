#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."

echo "Checking for obvious active agent and package operations..."
if pgrep -af 'apt|dpkg|unattended-upgrade' >/dev/null; then
  echo "Package operation is active; do not suspend." >&2
  pgrep -af 'apt|dpkg|unattended-upgrade' >&2
  exit 1
fi

if command -v hermes >/dev/null 2>&1; then
  hermes doctor || echo "Warning: hermes doctor reported a problem." >&2
fi

bash scripts/backup.sh
sync
cat <<'EOF'
Backup completed and filesystem synchronized.
Review active tmux sessions and Hermes/Kanban workers before suspending VMware.
Automatic worker draining will be added only after verifying the installed Hermes release's supported lifecycle commands.
EOF
