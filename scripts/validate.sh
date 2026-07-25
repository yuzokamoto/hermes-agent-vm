#!/usr/bin/env bash
set -Eeuo pipefail

failed=0

require_file() {
  if [[ ! -f "$1" ]]; then
    printf 'Missing required file: %s\n' "$1" >&2
    failed=1
  fi
}

required_files=(
  README.md
  AGENTS.md
  Makefile
  .gitignore
  .env.example
  bootstrap/lib.sh
  scripts/bootstrap-workstation.sh
  scripts/configure-workstation.sh
  scripts/validate.sh
  scripts/verify-workstation.sh
)

for file in "${required_files[@]}"; do
  require_file "$file"
done

# Detect private keys and likely hardcoded credentials. Assignments that reference
# environment variables or documented placeholders are intentionally allowed.
if git grep -nE 'BEGIN (RSA|OPENSSH|EC) PRIVATE KEY' -- ':!scripts/validate.sh'; then
  printf 'Private key material detected.\n' >&2
  failed=1
fi

credential_candidates=$(git grep -nEi '[A-Za-z0-9_]*(API_KEY|TOKEN|SECRET|PASSWORD)[[:space:]]*=' -- \
  ':!scripts/validate.sh' ':!.env.example' || true)

if [[ -n $credential_candidates ]]; then
  hardcoded_candidates=$(printf '%s\n' "$credential_candidates" | grep -Ev \
    '=[[:space:]]*("|'"'"')?(\$|\$\{|<|CHANGE_ME|REPLACE_ME|YOUR_|example|disabled|false|true|$)' || true)
  if [[ -n $hardcoded_candidates ]]; then
    printf '%s\n' "$hardcoded_candidates"
    printf 'Potential hardcoded credential material detected.\n' >&2
    failed=1
  fi
fi

mapfile -t shell_scripts < <(find bootstrap scripts -type f -name '*.sh' -print | sort)
for script in "${shell_scripts[@]}"; do
  bash -n "$script"
done

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -x "${shell_scripts[@]}"
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
