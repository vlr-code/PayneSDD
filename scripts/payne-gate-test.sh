#!/usr/bin/env bash
# PayneSDD — behavioral test of the Stop-hook wrapper (hooks/payne-gate.sh).
#
# bash -n + shellcheck prove the hook PARSES; this proves it BEHAVES: dormant
# without a marker, blocks on red, counts consecutive blocks, releases after
# PAYNE_MAX_BLOCKS with a user-facing systemMessage, resets on green and on a
# fresh stop chain, blocks when PAYNE_TEST_CMD is unset, and announces a marker
# removed while the gate was red. Wired into scripts/payne-check.sh (AC7).
#
# Usage:  scripts/payne-gate-test.sh [HOOK_DIR]   run the suite (default: hooks/)
#         scripts/payne-gate-test.sh --mutants    red-proof: each deliberately
#             broken hook copy (list in mutants() below) must FAIL the suite (a
#             check never seen failing is unproven — AGENT.md Step 4).
#
# Isolation: every hook call gets an explicit PAYNE_TEST_CMD, CLAUDE_PROJECT_DIR,
# PAYNE_MARKER, PAYNE_MAX_BLOCKS and explicit stdin — nothing inherited (under
# this repo's own Stop-hook an inherited PAYNE_TEST_CMD would recurse into
# payne-check.sh). bash 3.2 compatible (macOS /bin/bash).
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
HOOK_DIR="$ROOT/hooks"
MODE="suite"
case "${1:-}" in
  --mutants) MODE="mutants" ;;
  "") ;;
  *) HOOK_DIR="$(cd "$1" && pwd)" || exit 1 ;;
esac

TMP="$(mktemp -d)" || { echo "FAIL (setup) mktemp -d failed" >&2; exit 1; }
trap 'rm -rf "$TMP"' EXIT

fail=0
ok()  { echo "ok   $1"; }
bad() { echo "FAIL $1 — $2" >&2; fail=1; }
has() { grep -qF -- "$2" "$1"; }
attempts() { cat "$MARKER.attempts" 2>/dev/null || echo "none"; }

# run_hook <stop_hook_active true|false> <PAYNE_TEST_CMD>  → RC, OUT, ERR
run_hook() {
  local active="$1" cmd="$2"
  OUT="$TMP/out"; ERR="$TMP/err"
  PAYNE_TEST_CMD="$cmd" CLAUDE_PROJECT_DIR="$PROJ" PAYNE_MARKER="$MARKER" \
    PAYNE_MAX_BLOCKS=3 bash "$HOOK/payne-gate.sh" >"$OUT" 2>"$ERR" <<JSON
{"session_id":"payne-gate-test","stop_hook_active":$active}
JSON
  RC=$?
}

# json_ok <file> <label>: the systemMessage line must be valid JSON when jq is
# present (degrade like payne-check AC2 — never fail on a missing jq).
json_ok() {
  command -v jq >/dev/null 2>&1 || return 0
  if jq -e '.systemMessage | type == "string"' "$1" >/dev/null 2>&1; then
    ok "$2 systemMessage is valid JSON (jq)"
  else
    bad "$2 systemMessage JSON" "jq rejected: $(cat "$1")"
  fi
}

suite() {
  HOOK="$1"
  PROJ="$TMP/proj"; rm -rf "$PROJ"; mkdir -p "$PROJ"
  MARKER="$PROJ/.payne-active"

  run_hook false "exit 1"
  if [ "$RC" -eq 0 ] && [ ! -s "$OUT" ]; then ok "T1 no marker → dormant (exit 0, silent)"
  else bad "T1 dormant without marker" "rc=$RC out=$(cat "$OUT")"; fi

  touch "$MARKER"
  run_hook false "exit 1"
  if [ "$RC" -eq 2 ] && [ "$(attempts)" = "1" ] && has "$ERR" "block 1 of 3"; then ok "T2 red → exit 2, block 1 of 3"
  else bad "T2 first red block" "rc=$RC attempts=$(attempts) err=$(cat "$ERR")"; fi

  run_hook true "exit 1"
  if [ "$RC" -eq 2 ] && [ "$(attempts)" = "2" ]; then ok "T3 consecutive red → block 2"
  else bad "T3 second red block" "rc=$RC attempts=$(attempts)"; fi

  run_hook true "exit 1"
  if [ "$RC" -eq 2 ] && [ "$(attempts)" = "3" ]; then ok "T4 consecutive red → block 3 (still blocks)"
  else bad "T4 third red block" "rc=$RC attempts=$(attempts)"; fi

  run_hook true "exit 1"
  if [ "$RC" -eq 0 ] && has "$OUT" '"systemMessage"' && has "$OUT" "RELEASED" && [ "$(attempts)" = "none" ]; then
    ok "T5 4th consecutive red → RELEASED (exit 0, systemMessage, counter cleared)"
  else bad "T5 release after PAYNE_MAX_BLOCKS" "rc=$RC attempts=$(attempts) out=$(cat "$OUT")"; fi
  json_ok "$OUT" "T5"

  printf '2\n' > "$MARKER.attempts"
  run_hook false "exit 1"
  if [ "$RC" -eq 2 ] && [ "$(attempts)" = "1" ]; then ok "T6 fresh stop chain → counter restarts at 1"
  else bad "T6 fresh-chain reset" "rc=$RC attempts=$(attempts)"; fi

  run_hook true "true"
  if [ "$RC" -eq 0 ] && [ ! -s "$OUT" ] && [ "$(attempts)" = "none" ]; then ok "T7 green → exit 0, counter cleared"
  else bad "T7 green resets" "rc=$RC attempts=$(attempts) out=$(cat "$OUT")"; fi

  run_hook false ""
  if [ "$RC" -eq 2 ] && [ "$(attempts)" = "1" ] && has "$ERR" "PAYNE_TEST_CMD is unset"; then ok "T8 empty PAYNE_TEST_CMD → blocks (UNVERIFIED is not green)"
  else bad "T8 unset test command" "rc=$RC attempts=$(attempts) err=$(cat "$ERR")"; fi

  rm -f "$MARKER"
  run_hook false "exit 1"
  if [ "$RC" -eq 0 ] && has "$OUT" '"systemMessage"' && has "$OUT" "removed while the gate was RED" \
     && has "$OUT" "1 red block" && [ "$(attempts)" = "none" ]; then
    ok "T9 marker removed while red → exit 0 + systemMessage (1 red block), counter cleared"
  else bad "T9 disarm while red" "rc=$RC attempts=$(attempts) out=$(cat "$OUT")"; fi
  json_ok "$OUT" "T9"

  run_hook false "exit 1"
  if [ "$RC" -eq 0 ] && [ ! -s "$OUT" ]; then ok "T10 dormant again after disarm (no repeated alarm)"
  else bad "T10 dormant after disarm" "rc=$RC out=$(cat "$OUT")"; fi
}

# Red-proof: each mutant breaks ONE behavior class (wrapper or core); the suite
# must go red on it.
mutants() {
  local m d target
  for m in M1_release_boundary M2_green_never_clears M3_marker_inverted M4_disarm_silent \
           M5_fresh_chain_ignored M6_unset_cmd_passes; do
    d="$TMP/$m"; mkdir -p "$d"
    cp "$ROOT/hooks/payne-gate.sh" "$ROOT/hooks/payne-gate-core.sh" "$d/"
    target="payne-gate.sh"
    # shellcheck disable=SC2016  # the $ signs are sed literals, not expansions
    case "$m" in
      M1_release_boundary)   sed -i.bak 's/-gt "\$MAX_BLOCKS"/-ge "$MAX_BLOCKS"/' "$d/payne-gate.sh" ;;
      M2_green_never_clears) sed -i.bak '/green resets the consecutive-block budget/d' "$d/payne-gate.sh" ;;
      M3_marker_inverted)    sed -i.bak 's/if \[ ! -f "\$MARKER" \]; then/if [ -f "$MARKER" ]; then/' "$d/payne-gate.sh" ;;
      M4_disarm_silent)      sed -i.bak '/was removed while the gate was RED/d' "$d/payne-gate.sh" ;;
      M5_fresh_chain_ignored) sed -i.bak 's/if \[ "\$STOP_ACTIVE" = true \] \&\& \[ -f "\$ATTEMPTS" \]; then/if [ -f "$ATTEMPTS" ]; then/' "$d/payne-gate.sh" ;;
      M6_unset_cmd_passes)   target="payne-gate-core.sh"
                             sed -i.bak '/PAYNE_TEST_CMD is unset/,/^  exit 1$/ s/^  exit 1$/  exit 0/' "$d/payne-gate-core.sh" ;;
    esac
    if cmp -s "$d/$target" "$ROOT/hooks/$target"; then
      bad "$m" "mutation did not apply — $target drifted from the sed pattern"; continue
    fi
    if bash "$SELF" "$d" >/dev/null 2>&1; then bad "$m" "suite stayed GREEN on a broken hook"
    else ok "$m → suite went RED as required"; fi
  done
}

if [ "$MODE" = "mutants" ]; then mutants; else suite "$HOOK_DIR"; fi
if [ "$fail" -eq 0 ]; then echo "payne-gate-test: all green ($MODE)"; else echo "payne-gate-test: FAILED ($MODE)" >&2; fi
exit "$fail"
