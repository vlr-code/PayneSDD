#!/usr/bin/env bash
# PayneSDD — gate CORE (portable, agent-agnostic).
#
# Runs your test command and reports a verdict. This file has NO Claude-Code
# specifics: no Stop-hook semantics, no marker logic. It is the shared engine.
#   - Claude Code uses it via the hook wrapper `payne-gate.sh` (auto, enforced).
#   - Cursor / Cline / any other agent or a human can run THIS directly, e.g.
#     in a "run before finishing" rule or by hand:  hooks/payne-gate-core.sh
#
# Config: PAYNE_TEST_CMD  — the gate command (e.g. "swift test", "npm test",
#         "pytest -q"). PROJECT_DIR defaults to $CLAUDE_PROJECT_DIR or $PWD.
#
# Exit codes: 0 = gate GREEN. 1 = gate RED (or no command configured).
# (The hook wrapper translates 1 → 2 to block a Claude Code stop.)

set -uo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
TEST_CMD="${PAYNE_TEST_CMD:-}"

if [ -z "$TEST_CMD" ]; then
  echo "PayneSDD gate: PAYNE_TEST_CMD is unset — no objective check to run." >&2
  echo "Set it (e.g. 'swift test', 'npm test', 'pytest -q'), or the gate is UNVERIFIED." >&2
  exit 1
fi

echo "PayneSDD gate: running → $TEST_CMD" >&2
GATE_LOG="$(cd "$PROJECT_DIR" && eval "$TEST_CMD" 2>&1)"
GATE_RC=$?

if [ $GATE_RC -ne 0 ]; then
  echo "──────────────────────────────────────────────────────────" >&2
  echo "PayneSDD GATE FAILED (exit $GATE_RC). You may NOT declare done." >&2
  echo "Fix the CAUSE — do not weaken or bypass the check. Then run the gate again." >&2
  echo "── gate output (tail) ──" >&2
  echo "$GATE_LOG" | tail -n 30 >&2
  exit 1
fi

echo "PayneSDD gate: green." >&2
exit 0
