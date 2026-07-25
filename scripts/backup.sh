#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$0")/.."
source bootstrap/lib.sh
load_env

[[ ${BACKUP_ENABLED:-true} == true ]] || { echo "Backups disabled"; exit 0; }
: "${RESTIC_PASSWORD:?RESTIC_PASSWORD is required}"

export RESTIC_PASSWORD
restic -r "$RESTIC_REPOSITORY" backup \
  "$HERMES_HOME" "$WORKSPACE_ROOT" "$KNOWLEDGE_ROOT" \
  --exclude '**/.git/objects' \
  --exclude '**/node_modules' \
  --exclude '**/.venv' \
  --exclude '**/__pycache__'
restic -r "$RESTIC_REPOSITORY" forget --prune \
  --keep-daily "$BACKUP_RETENTION_DAILY" \
  --keep-weekly "$BACKUP_RETENTION_WEEKLY" \
  --keep-monthly "$BACKUP_RETENTION_MONTHLY"
