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

# Keep CI deterministic by scanning only high-confidence credential formats.
secret_pattern='BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|gh[pousr]_[A-Za-z0-9]{30,}|sk-[A-Za-z0-9_-]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{30,}'
if git grep -nE "$secret_pattern" -- ':!scripts/validate.sh' ':!.env.example'; then
  printf 'High-confidence secret material detected.\n' >&2
  failed=1
fi

mapfile -t shell_scripts < <(find bootstrap scripts -type f -name '*.sh' -print | sort)
for script in "${shell_scripts[@]}"; do
  bash -n "$script"
done

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
