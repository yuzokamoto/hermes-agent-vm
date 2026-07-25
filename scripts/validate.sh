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

if git grep -nE 'BEGIN (RSA|OPENSSH|EC) PRIVATE KEY' -- ':!scripts/validate.sh'; then
  printf 'Private key material detected.\n' >&2
  failed=1
fi

python3 - <<'PY' || failed=1
import re
import subprocess
import sys

pattern = re.compile(r"(?i)\b[A-Z0-9_]*(API_KEY|TOKEN|SECRET|PASSWORD)\b\s*=\s*(.+)$")
allowed_prefixes = ("$", "${", "<", "CHANGE_ME", "REPLACE_ME", "YOUR_", "example")
findings = []

result = subprocess.run(
    ["git", "grep", "-nEI", r"(API_KEY|TOKEN|SECRET|PASSWORD)[[:space:]]*="],
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.DEVNULL,
    check=False,
)

for line in result.stdout.splitlines():
    path, _, text = line.partition(":")
    if path in {".env.example", "scripts/validate.sh"}:
        continue
    match = pattern.search(text)
    if not match:
        continue
    value = match.group(2).strip().strip('"\'')
    if not value or value.startswith(allowed_prefixes) or value.lower() in {"true", "false", "disabled"}:
        continue
    if len(value) >= 12:
        findings.append(line)

if findings:
    print("Potential hardcoded credential material detected:", file=sys.stderr)
    print("\n".join(findings), file=sys.stderr)
    raise SystemExit(1)
PY

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
