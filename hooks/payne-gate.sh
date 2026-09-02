#!/usr/bin/env bash
# PayneSDD — Claude Code Stop-hook WRAPPER around the portable gate core.
#
# Runs when the agent tries to FINISH a turn. "Smart" mode: the gate fires ONLY
# when a spec marker is present, so trivial tasks and plain chat pass untouched.
# On red tests it BLOCKS the stop (exit 2) and feeds the failure back to the
# agent — honestly bounded: after PAYNE_MAX_BLOCKS consecutive red blocks
# (default 3, mirroring the Step 2 iteration budget) the stop is RELEASED with
# an explicit UNVERIFIED / ESCALATE warning instead of looping forever. (Claude
# Code itself force-ends the turn after 8 consecutive Stop-hook blocks — see
# the Stop-hook docs on `stop_hook_active`.) The actual test run lives in
# payne-gate-core.sh (portable).
#
# ── Install (Claude Code) ─────────────────────────────────────────────────
# 0. Copy hooks/payne-gate.sh AND hooks/payne-gate-core.sh into your project
#    (keep them side by side — the wrapper calls the core).
# 1. chmod +x hooks/payne-gate.sh hooks/payne-gate-core.sh
# 2. Set your test command, e.g. in .claude/settings.json "env":
#       "PAYNE_TEST_CMD": "swift test"        (or "npm test", "pytest -q", …)
# 3. Register the hook in .claude/settings.json — quote the path (it may
#    contain spaces) and set "timeout" (seconds) above your suite's worst
#    case: a timed-out hook silently does NOT block.
#    {
#      "hooks": {
#        "Stop": [
#          { "hooks": [ { "type": "command",
#                         "command": "\"$CLAUDE_PROJECT_DIR\"/hooks/payne-gate.sh",
#                         "timeout": 1800 } ] }
#        ]
#      }
#    }
# ── Activate the gate for a task ──────────────────────────────────────────
#   touch .payne-active     when a spec is in play
#   rm .payne-active        when the task is done, abandoned, or honestly
#                           ESCALATED (Step 6, red log attached — an honest
#                           escalation is not a gate bypass)
#   Removing the marker while the gate is RED (a block counter on record) is
#   allowed but LOUD: the next stop passes and prints a systemMessage to the
#   USER naming the disarm and the UNVERIFIED state. A tripwire for the human,
#   not a lock on the agent.
#
# The marker is per-project: one armed task per repo at a time — parallel
# sessions in the same checkout share the gate.
#
# Other agents (Cursor/Cline) have no Stop-hook — call hooks/payne-gate-core.sh
# directly instead (see README). There the gate is on-request, not enforced.
#
# Exit codes: 0 = let the stop proceed; 2 = BLOCK the stop, feedback to agent.

set -uo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
MARKER="${PAYNE_MARKER:-$PROJECT_DIR/.payne-active}"
ATTEMPTS="$MARKER.attempts"
MAX_BLOCKS="${PAYNE_MAX_BLOCKS:-3}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Stop-hook input arrives as JSON on stdin. stop_hook_active=true means Claude
# Code is ALREADY continuing because a Stop hook blocked — the docs say to
# check it to avoid blocking on a condition that will never resolve.
INPUT=""
[ -t 0 ] || INPUT="$(cat 2>/dev/null || true)"
STOP_ACTIVE=false
if grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true' <<<"$INPUT"; then
  STOP_ACTIVE=true
fi

# No active spec → gate is dormant. Trivial work and chat pass untouched.
if [ ! -f "$MARKER" ]; then
  if [ -f "$ATTEMPTS" ]; then
    # The marker vanished while a red-block counter is still on record: the
    # gate was DISARMED while RED, not passed. Dormant means dormant — never
    # block here — but make it visible: systemMessage reaches the HUMAN (Claude
    # never sees exit-0 stdout on Stop). The counter is cleared, so this fires
    # once per disarm.
    SPENT="$(cat "$ATTEMPTS" 2>/dev/null || true)"
    case "$SPENT" in ''|*[!0-9]*) SPENT=0 ;; esac
    rm -f "$ATTEMPTS"
    printf '{"systemMessage":"PayneSDD gate: .payne-active was removed while the gate was RED (%s red block(s) on record) — the gate was disarmed, not passed. The result is UNVERIFIED unless the agent honestly ESCALATED with the red log; treat any done-claim accordingly."}\n' "$SPENT"
    exit 0
  fi
  exit 0
fi

# Delegate the actual check to the portable core.
if bash "$HERE/payne-gate-core.sh"; then
  rm -f "$ATTEMPTS"   # green resets the consecutive-block budget
  exit 0
fi

# Red gate. Count CONSECUTIVE blocks — a fresh stop chain (stop_hook_active
# false) resets the count — so a stuck-red gate escalates per Step 2 instead
# of blocking forever.
COUNT=0
if [ "$STOP_ACTIVE" = true ] && [ -f "$ATTEMPTS" ]; then
  COUNT="$(cat "$ATTEMPTS" 2>/dev/null || true)"
  case "$COUNT" in ''|*[!0-9]*) COUNT=0 ;; esac
fi
COUNT=$((COUNT + 1))

if [ "$COUNT" -gt "$MAX_BLOCKS" ]; then
  rm -f "$ATTEMPTS"
  # All MAX_BLOCKS blocks are spent (Step 2 iteration budget): release the
  # stop, loudly UNVERIFIED. Blocking again would only repeat what just
  # failed; the call belongs to the human now. systemMessage → the user.
  printf '{"systemMessage":"PayneSDD gate: still RED after %s consecutive blocks — stop RELEASED, result is UNVERIFIED (Step 2 budget spent). The agent was told to escalate with the red log; treat any done-claim accordingly."}\n' "$MAX_BLOCKS"
  exit 0
fi

printf '%s\n' "$COUNT" > "$ATTEMPTS"
echo "PayneSDD gate: block $COUNT of $MAX_BLOCKS. Fix the CAUSE and run the gate again; after block $MAX_BLOCKS the next stop on this same red gate is RELEASED as UNVERIFIED — then you must ESCALATE (Step 6) with this log as evidence, never claim done." >&2
exit 2
