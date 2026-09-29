#!/bin/sh
set -eu
expected_name='LEE GYEONG HU'
expected_email='53691249+9oHigh@users.noreply.github.com'
root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  printf 'Run this script inside a Git working tree.\n' >&2
  exit 1
}
cd "$root"
for hook in .githooks/pre-commit .githooks/pre-push; do
  if [ ! -f "$hook" ]; then
    printf 'Required hook is missing: %s\n' "$hook" >&2
    exit 1
  fi
  chmod +x "$hook"
done
git config --local user.name "$expected_name"
git config --local user.email "$expected_email"
git config --local user.useConfigOnly true
git config --local core.hooksPath .githooks
printf 'GitHub attribution guards installed for %s.\n' "$root"
printf 'Identity: %s <%s>\n' "$expected_name" "$expected_email"
