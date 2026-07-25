#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
source bootstrap/lib.sh
load_env

required=(WORKSTATION_USER GIT_USER_NAME GIT_USER_EMAIL)
for key in "${required[@]}"; do
  [[ -n ${!key:-} ]] || { echo "Missing required .env value: $key" >&2; exit 1; }
done

install -d -m 700 "$HERMES_HOME/policies" "$HERMES_HOME/profiles" "$HERMES_HOME/context"
install -m 0600 hermes/policies/safety.yaml "$HERMES_HOME/policies/safety.yaml"
install -m 0600 hermes/context/WORKSTATION.md "$HERMES_HOME/context/WORKSTATION.md"
cp -a hermes/profiles/. "$HERMES_HOME/profiles/"

if [[ ${BACKUP_ENABLED:-true} == true ]]; then
  if [[ -z ${RESTIC_PASSWORD:-} ]]; then
    echo "RESTIC_PASSWORD is required when BACKUP_ENABLED=true" >&2
    exit 1
  fi
  mkdir -p "${RESTIC_REPOSITORY/#\$HOME/$HOME}"
  RESTIC_PASSWORD="$RESTIC_PASSWORD" restic -r "$RESTIC_REPOSITORY" snapshots >/dev/null 2>&1 || \
    RESTIC_PASSWORD="$RESTIC_PASSWORD" restic -r "$RESTIC_REPOSITORY" init
fi

cat <<'EOF'
Automated configuration installed.
Complete these interactive authentications now:
  gh auth login
  codex login
  claude auth login
  hermes setup

When WhatsApp is enabled, configure the Hermes gateway with Baileys and restrict it to WHATSAPP_ALLOWED_NUMBER.
Then run: make verify
EOF
