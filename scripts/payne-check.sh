#!/usr/bin/env bash
# PayneSDD — repo self-check = the Step 4 machine gate for THIS repo.
#
# This repository is markdown + shell with NO test suite, so the objective check
# (AGENT.md Step 4) is: the shell hooks must be syntactically valid, and
# lint-clean if shellcheck is available. Wired as PAYNE_TEST_CMD in
# .claude/settings.json; runnable directly any time:  bash scripts/payne-check.sh
#
# Exit codes: 0 = gate GREEN, 1 = gate RED (a hook failed syntax or shellcheck).
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0

# AC5: every hook must parse under bash.
for f in "$ROOT"/hooks/*.sh; do
  if bash -n "$f"; then
    echo "ok   (bash -n)    $f"
  else
    echo "FAIL (bash -n)    $f" >&2
    fail=1
  fi
done

# shellcheck if present; degrade gracefully if absent (a missing tool is NOT a
# failure — it just means the gate ran the lighter syntax-only check).
if command -v shellcheck >/dev/null 2>&1; then
  if shellcheck "$ROOT"/hooks/*.sh; then
    echo "ok   (shellcheck) hooks/*.sh"
  else
    echo "FAIL (shellcheck) hooks/*.sh" >&2
    fail=1
  fi
else
  echo "note: shellcheck not installed — ran bash -n only (gate degraded, not failed)." >&2
fi

exit "$fail"
