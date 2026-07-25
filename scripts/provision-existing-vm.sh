#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root: sudo bash scripts/provision-existing-vm.sh" >&2
  exit 1
fi

TARGET_USER="${TARGET_USER:-hermes}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6 || true)"

if [[ -z "$TARGET_HOME" ]]; then
  echo "User '$TARGET_USER' does not exist." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates curl git xz-utils build-essential jq unzip \
  tmux htop tree rsync restic \
  xfce4 xfce4-goodies dbus-x11 xrdp \
  chromium-browser firefox

systemctl enable --now xrdp
adduser xrdp ssl-cert || true

install -d -m 0750 -o "$TARGET_USER" -g "$TARGET_USER" \
  "$TARGET_HOME/workspaces" \
  "$TARGET_HOME/backups" \
  "$TARGET_HOME/.config/hermes-vm"

sudo -H -u "$TARGET_USER" env \
  HOME="$TARGET_HOME" \
  HERMES_HOME="$TARGET_HOME/.hermes" \
  bash -lc 'curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup'

cat > /etc/profile.d/hermes-vm.sh <<EOF
export HERMES_HOME="$TARGET_HOME/.hermes"
export HERMES_WORKSPACES="$TARGET_HOME/workspaces"
export PATH="$TARGET_HOME/.local/bin:\$PATH"
EOF
chmod 0644 /etc/profile.d/hermes-vm.sh

cat > "$TARGET_HOME/.xsession" <<'EOF'
startxfce4
EOF
chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.xsession"
chmod 0644 "$TARGET_HOME/.xsession"

sudo -H -u "$TARGET_USER" env \
  HOME="$TARGET_HOME" \
  HERMES_HOME="$TARGET_HOME/.hermes" \
  PATH="$TARGET_HOME/.local/bin:$PATH" \
  bash -lc 'hermes doctor || true'

echo
printf '%s\n' \
  "Provisioning complete." \
  "Next steps as $TARGET_USER:" \
  "  hermes setup --portal" \
  "  hermes doctor" \
  "  mkdir -p ~/workspaces/<project>"
