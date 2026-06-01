#!/usr/bin/env bash
# PayneSDD — Claude Code Stop-hook WRAPPER around the portable gate core.
#
# Runs when the agent tries to FINISH a turn. "Smart" mode: the gate fires ONLY
# when a spec marker is present, so trivial tasks and plain chat pass untouched.
# On red tests it BLOCKS the stop (exit 2) — the agent literally cannot end on a
# failing gate. The actual test run lives in payne-gate-core.sh (portable).
#
# ── Install (Claude Code) ─────────────────────────────────────────────────
# 1. chmod +x hooks/payne-gate.sh hooks/payne-gate-core.sh
# 2. Set your test command, e.g. in .claude/settings.json "env":
#       "PAYNE_TEST_CMD": "swift test"        (or "npm test", "pytest -q", …)
# 3. Register the hook in .claude/settings.json:
#    {
#      "hooks": {
#        "Stop": [
#          { "hooks": [ { "type": "command",
#                         "command": "$CLAUDE_PROJECT_DIR/hooks/payne-gate.sh" } ] }
#        ]
#      }
#    }
# ── Activate the gate for a task ──────────────────────────────────────────
#   touch .payne-active     when a spec is in play
#   rm .payne-active        when the task is done / abandoned
#
# Other agents (Cursor/Cline) have no Stop-hook — call hooks/payne-gate-core.sh
# directly instead (see README). There the gate is on-request, not enforced.
#
# Exit codes: 0 = let the stop proceed; 2 = BLOCK the stop, feedback to agent.

set -uo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
MARKER="${PAYNE_MARKER:-$PROJECT_DIR/.payne-active}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# No active spec → gate is dormant. Trivial work and chat pass untouched.
[ -f "$MARKER" ] || exit 0

# Delegate the actual check to the portable core; translate red (1) → block (2).
if bash "$HERE/payne-gate-core.sh"; then
  exit 0
else
  exit 2   # block the stop; Claude Code feeds the core's stderr back to the agent
fi
