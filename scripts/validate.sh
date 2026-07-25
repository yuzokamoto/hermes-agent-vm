#!/usr/bin/env bash
set -Eeuo pipefail

failed=0

require_file() {
  if [[ ! -f "$1" ]]; then
    printf 'Missing required file: %s\n' "$1" >&2
    failed=1
  fi
}

for file in README.md AGENTS.md Makefile scripts/bootstrap.sh scripts/validate.sh .gitignore .env.example; do
  require_file "$file"
done

if git grep -nE '(BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|[A-Za-z0-9_]*(API_KEY|TOKEN|SECRET|PASSWORD)=[^[:space:]$<{][^[:space:]]*)' -- ':!scripts/validate.sh' ':!.env.example'; then
  printf 'Potential secret material detected.\n' >&2
  failed=1
fi

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck scripts/*.sh
else
  printf 'Notice: shellcheck is not installed; skipping shell lint.\n'
fi

if command -v hermes >/dev/null 2>&1; then
  hermes --version
  hermes doctor
else
  printf 'Notice: Hermes is not installed locally; runtime checks skipped.\n'
fi

if (( failed != 0 )); then
  exit 1
fi

printf 'Repository validation passed.\n'
