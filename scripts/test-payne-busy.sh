#!/bin/bash
# Tests of scripts/payne-busy.sh. Run: bash scripts/test-payne-busy.sh   (exit 0 — all green)
# A fake "build" is a sleep renamed to a marker no real process carries; PAYNE_BUSY_ROOT says which
# process tree counts as "mine", so both sides — foreign and own — are exercised on any machine.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
BUSY="$HERE/payne-busy.sh"
MARK="payne_fake_build_$$"
fails=0

check() {  # check <name> <expected exit> <actual exit> <output> [<must contain>]
  if [ "$2" != "$3" ]; then echo "FAIL $1: exit $3, expected $2 — $4"; fails=$((fails + 1)); return; fi
  if [ $# -ge 5 ] && ! printf '%s' "$4" | grep -q -- "$5"; then
    echo "FAIL $1: output lacks «$5» — $4"; fails=$((fails + 1)); return
  fi
  echo "ok   $1"
}

# 1. nothing matches → free
out="$(PAYNE_BUSY_PATTERN="$MARK" bash "$BUSY")"; rc=$?
check "free when nothing matches" 0 "$rc" "$out" "free:"

# a bystander whose tree the fake build does NOT belong to, and the fake build itself
sleep 60 & bystander=$!
bash -c "exec -a $MARK sleep 60" & fake=$!
trap 'kill "$bystander" "$fake" 2>/dev/null' EXIT
sleep 1

# 2. the fake build is outside "my" tree → busy, and it is named
out="$(PAYNE_BUSY_PATTERN="$MARK" PAYNE_BUSY_ROOT="$bystander" bash "$BUSY")"; rc=$?
check "foreign build is reported" 1 "$rc" "$out" "pid $fake"

# 3. the same build inside "my" tree → free
out="$(PAYNE_BUSY_PATTERN="$MARK" PAYNE_BUSY_ROOT="$$" bash "$BUSY")"; rc=$?
check "own build is not reported" 0 "$rc" "$out" "free:"

# 4. no root forced: a build this test started descends from the detected root → free
out="$(PAYNE_BUSY_PATTERN="$MARK" bash "$BUSY")"; rc=$?
check "detected root covers own build" 0 "$rc" "$out" "free:"

# 5. an agent's name in an ancestor's ARGUMENTS is not the session root: a wrapper shell whose command
#    line carries «/codex » (this repo has a codex/ folder) must not cut the own build out of "mine"
out="$(bash -c 'PAYNE_BUSY_PATTERN="$1" bash "$0"; exit $?' "$BUSY" "$MARK" /some/codex dir)"; rc=$?
check "agent name in a wrapper's arguments" 0 "$rc" "$out" "free:"

# 6. the built-in list knows a real command line (no process needed: the list is matched as text)
list="$(grep '^PATTERN=' "$BUSY" | sed 's/^[^-]*:-//; s/}"$//')"
[ -n "$list" ] || { echo "FAIL could not read the built-in list"; fails=$((fails + 1)); }
for cmd in "/usr/bin/xcodebuild test -scheme App" "/opt/x/python3 -m pytest -q" "swift test" "./gradlew assembleDebug" "python3 harness/bench.py --epoch e1"; do
  if printf '%s\n' "$cmd" | grep -Eq -- "$list"; then echo "ok   list matches: $cmd"; else echo "FAIL list misses: $cmd"; fails=$((fails + 1)); fi
done
for cmd in "vim notes-about-xcodebuild.md" "/bin/zsh -l" "node server.js"; do
  if printf '%s\n' "$cmd" | grep -Eq -- "$list"; then echo "FAIL list wrongly matches: $cmd"; fails=$((fails + 1)); else echo "ok   list ignores: $cmd"; fi
done

[ "$fails" -eq 0 ] && echo "ALL GREEN" || echo "$fails FAILED"
exit "$fails"
