#!/bin/bash
# Is another session building or testing on this machine right now?
#
#   bash scripts/payne-busy.sh        exit 0 — free;  exit 1 — busy, one line per foreign process
#
# Run it before a full check. A build or test run started by another agent session (or by a human)
# on the same machine shares simulators, ports, build folders and CPU with yours: your check can go
# red from their work, not from your change. This script only looks — it stops and locks nothing.
#
# Whose process is whose: "mine" is everything that descends from the nearest `claude` or `codex`
# CLI process above this script (one such process per agent session); run from a plain terminal,
# "mine" is what descends from the calling shell. Everything else that matches the list is foreign.
#
#   PAYNE_BUSY_PATTERN  an extended regex that replaces the built-in list of build / test commands
#   PAYNE_BUSY_ROOT     a pid that replaces the detected session root (used by the test)
set -u

PATTERN="${PAYNE_BUSY_PATTERN:-(^|/)xcodebuild( |$)|simctl (boot|install|launch|erase|delete|shutdown)|(^|/)gradlew?( |$)|swift-(build|test)|swift (build|test)|(^|/| )pytest( |$)|-m (pytest|unittest)|(^|/)(npm|pnpm|yarn) (run )?(test|build)|(^|/)jest( |$)|(^|/)cargo (test|build)|(^|/)go test|flutter (test|build)|harness/bench\.py}"

# Two listings: the executable alone (it tells an agent CLI from a shell that merely mentions one in
# its arguments), then the full command line (it is what the list of builds and tests is matched on).
{ ps -axo pid=,comm= | sed 's/^/X /'; ps -axo pid=,ppid=,etime=,command= | sed 's/^/P /'; } |
awk -v me="$$" -v forced="${PAYNE_BUSY_ROOT:-}" -v pat="$PATTERN" '
$1 == "X" { line = $0; sub(/^X +[0-9]+ +/, "", line); exe[$2] = line; next }
{
  pid = $2; parent[pid] = $3; age[pid] = $4
  line = $0; sub(/^P +[0-9]+ +[0-9]+ +[^ ]+ +/, "", line); cmd[pid] = line
}
END {
  # the session root: the nearest claude / codex CLI above this script, else the calling shell
  root = forced
  if (root == "") {
    p = parent[me]; hops = 0
    while (p != "" && p > 1 && hops++ < 64) {
      if (exe[p] ~ /(^|\/)(claude|codex)$/) { root = p; break }
      p = parent[p]
    }
    if (root == "") root = parent[me]
  }
  busy = 0
  for (pid in cmd) {
    if (cmd[pid] !~ pat) continue
    p = pid; mine = 0; hops = 0
    while (p != "" && p > 1 && hops++ < 64) {
      if (p == root) { mine = 1; break }
      p = parent[p]
    }
    if (mine) continue
    busy = 1
    printf "busy: pid %s, running %s — %s\n", pid, age[pid], substr(cmd[pid], 1, 110)
  }
  if (!busy) print "free: no foreign build or test is running"
  exit busy
}'
