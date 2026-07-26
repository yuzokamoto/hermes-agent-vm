#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
source bootstrap/lib.sh
load_env

required=(WORKSTATION_USER GIT_USER_NAME GIT_USER_EMAIL)
for key in "${required[@]}"; do
  [[ -n ${!key:-} ]] || { echo "Missing required .env value: $key" >&2; exit 1; }
done

[[ "$WORKSTATION_USER" == "$USER" ]] || {
  echo "WORKSTATION_USER=$WORKSTATION_USER does not match the current user: $USER" >&2
  exit 1
}

install -d -m 700 "$HERMES_HOME/policies" "$HERMES_HOME/profiles" "$HERMES_HOME/context"
install -m 0600 hermes/policies/safety.yaml "$HERMES_HOME/policies/safety.yaml"
install -m 0600 hermes/context/WORKSTATION.md "$HERMES_HOME/context/WORKSTATION.md"
cp -a hermes/profiles/. "$HERMES_HOME/profiles/"

if [[ ${BACKUP_ENABLED:-true} == true ]]; then
  [[ -n ${RESTIC_PASSWORD:-} ]] || {
    echo "RESTIC_PASSWORD is required when BACKUP_ENABLED=true" >&2
    exit 1
  }
  repository="${RESTIC_REPOSITORY/#\$HOME/$HOME}"
  mkdir -p "$repository"
  RESTIC_PASSWORD="$RESTIC_PASSWORD" restic -r "$repository" snapshots >/dev/null 2>&1 || \
    RESTIC_PASSWORD="$RESTIC_PASSWORD" restic -r "$repository" init
fi

cat <<'EOF'
Automated configuration installed.
Complete the interactive authentications you actually use:
  gh auth login
  codex login
  claude auth login
  hermes auth

Then initialize Hermes and verify the workstation:
  hermes skills list
  make verify
EOF
