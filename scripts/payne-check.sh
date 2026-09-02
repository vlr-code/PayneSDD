#!/usr/bin/env bash
# PayneSDD — repo self-check = the Step 4 machine gate for THIS repo.
#
# The product is markdown + shell, so the gate checks all three: every shipped
# shell file must be syntactically valid (lint-clean if shellcheck is
# available), the Stop-hook must BEHAVE as documented (scripts/payne-gate-test.sh
# incl. its red-proof mutants), and the shipped docs must be internally
# consistent — one version everywhere, no links to ghost files, no drifting
# dogfood copies. Wired as PAYNE_TEST_CMD in .claude/settings.json and run by CI
# on every push; runnable directly any time:  bash scripts/payne-check.sh
#
# Exit codes: 0 = gate GREEN, 1 = gate RED.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0

# AC1: every shipped shell file must parse under bash (hooks AND scripts —
# the gate script checks itself).
for f in "$ROOT"/hooks/*.sh "$ROOT"/scripts/*.sh; do
  if bash -n "$f"; then
    echo "ok   (bash -n)     $f"
  else
    echo "FAIL (bash -n)     $f" >&2
    fail=1
  fi
done

# AC2: shellcheck if present; degrade gracefully if absent (a missing tool is
# NOT a failure — the gate just ran the lighter syntax-only check).
if command -v shellcheck >/dev/null 2>&1; then
  if shellcheck "$ROOT"/hooks/*.sh "$ROOT"/scripts/*.sh; then
    echo "ok   (shellcheck)  hooks/*.sh scripts/*.sh"
  else
    echo "FAIL (shellcheck)  hooks/*.sh scripts/*.sh" >&2
    fail=1
  fi
else
  echo "note: shellcheck not installed — ran bash -n only (gate degraded, not failed)." >&2
fi

# AC3: one version everywhere — README badge == README "Latest release" ==
# top CHANGELOG entry == AGENT.md header stamp. (This class of drift shipped
# before; now it's caught.)
badge_ver="$(grep -Eo 'version-[0-9]+\.[0-9]+\.[0-9]+' "$ROOT/README.md" | head -n 1 | sed 's/^version-//')"
latest_ver="$(grep -Eo 'Latest release: \*\*v[0-9]+\.[0-9]+\.[0-9]+\*\*' "$ROOT/README.md" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || true)"
changelog_ver="$(grep -Eo '^## [0-9]+\.[0-9]+\.[0-9]+' "$ROOT/CHANGELOG.md" | head -n 1 | sed 's/^## //')"
agent_ver="$(grep -Eo '^PayneSDD v[0-9]+\.[0-9]+\.[0-9]+' "$ROOT/AGENT.md" | head -n 1 | sed 's/^PayneSDD v//')"
if [ -n "$badge_ver" ] && [ "$badge_ver" = "$changelog_ver" ] && [ "$badge_ver" = "$latest_ver" ] && [ "$badge_ver" = "$agent_ver" ]; then
  echo "ok   (version)     badge / Latest release / CHANGELOG / AGENT.md stamp all $badge_ver"
else
  echo "FAIL (version)     badge='$badge_ver' Latest='$latest_ver' CHANGELOG='$changelog_ver' AGENT.md='$agent_ver' — must all match" >&2
  fail=1
fi

# AC4: every local file the README links to (markdown links + image src) and
# every CLAUDE.md @-import must exist — docs may not point at ghosts.
missing="$(
  {
    grep -Eo '\]\([^)]+\)' "$ROOT/README.md" | sed -E 's/^\]\(//; s/\)$//'
    grep -Eo 'src="[^"]+"' "$ROOT/README.md" | sed -E 's/^src="//; s/"$//'
    sed -n 's/^@//p' "$ROOT/CLAUDE.md"
  } | while IFS= read -r p; do
        # leading "(" + no apostrophes here: bash 3.2 reparses this block
        case "$p" in (http://*|https://*|mailto:*) continue ;; esac
        p="${p%%\#*}"   # strip anchors; pure-anchor links become empty
        [ -n "$p" ] && [ ! -e "$ROOT/$p" ] && printf '%s\n' "$p"
      done
)"
if [ -z "$missing" ]; then
  echo "ok   (links)       README links/images + CLAUDE.md imports all resolve"
else
  echo "FAIL (links)       docs reference missing files:" >&2
  printf '%s\n' "$missing" >&2
  fail=1
fi

# AC5: DIGEST.md (the always-on compression of AGENT.md) must exist, be pinned
# to the CURRENT AGENT.md, and stay inside its size band — a ceiling so it
# can't bloat back into a second full file, and a floor so a gutted stub can't
# pass. The digest is hand-maintained, so the pin forces a review on every
# AGENT.md edit (re-pin AFTER the review: scripts/payne-digest-stamp.sh).
if [ -f "$ROOT/DIGEST.md" ]; then
  pin="$(grep -Eo 'pin: AGENT\.md sha256=[0-9a-f]{64}' "$ROOT/DIGEST.md" | grep -Eo '[0-9a-f]{64}' || true)"
  if command -v sha256sum >/dev/null 2>&1; then
    agent_sha="$(sha256sum "$ROOT/AGENT.md" | cut -d' ' -f1)"
  else
    agent_sha="$(shasum -a 256 "$ROOT/AGENT.md" | cut -d' ' -f1)"
  fi
  digest_size="$(wc -c < "$ROOT/DIGEST.md" | tr -d ' ')"
  if [ -n "$pin" ] && [ "$pin" = "$agent_sha" ] && [ "$digest_size" -le 10500 ] && [ "$digest_size" -ge 8000 ]; then
    echo "ok   (digest)      DIGEST.md pinned to current AGENT.md, ${digest_size} chars (band 8000-10500)"
  else
    echo "FAIL (digest)      pin/size mismatch (pin='${pin:-none}', AGENT.md=${agent_sha}, size=${digest_size}, band 8000-10500) — AGENT.md changed? review DIGEST.md, then run scripts/payne-digest-stamp.sh" >&2
    fail=1
  fi
else
  echo "FAIL (digest)      DIGEST.md missing — it ships with the repo; restore it from git" >&2
  fail=1
fi

# AC6: dogfood copies must not drift — any local .claude/commands/*.md that
# shadows a canonical commands/*.md must be byte-identical to it.
copy_fail=0
for c in "$ROOT"/.claude/commands/*.md; do
  [ -e "$c" ] || continue   # glob matched nothing
  base="$(basename "$c")"
  if [ -f "$ROOT/commands/$base" ] && ! diff -q "$c" "$ROOT/commands/$base" >/dev/null; then
    echo "FAIL (copy-sync)   .claude/commands/$base differs from commands/$base — delete the copy or re-sync it" >&2
    copy_fail=1
    fail=1
  fi
done
[ "$copy_fail" -eq 0 ] && echo "ok   (copy-sync)   no drifting local command copies"

# AC7: the Stop-hook must BEHAVE, not just parse — dormant / block / consecutive
# count / release / green + fresh-chain resets / unset cmd / disarm-while-red —
# and the suite must be able to go red: each deliberately broken hook copy in
# its --mutants mode must FAIL it (a check never seen failing is unproven).
# Hard fail.
if bash "$ROOT/scripts/payne-gate-test.sh" >/dev/null 2>&1 \
   && bash "$ROOT/scripts/payne-gate-test.sh" --mutants >/dev/null 2>&1; then
  echo "ok   (hook-test)   payne-gate.sh behavior suite green, every mutant red"
else
  echo "FAIL (hook-test)   scripts/payne-gate-test.sh (suite or --mutants) — details:" >&2
  bash "$ROOT/scripts/payne-gate-test.sh" 2>&1 | grep '^FAIL' >&2 || true
  bash "$ROOT/scripts/payne-gate-test.sh" --mutants 2>&1 | grep '^FAIL' >&2 || true
  fail=1
fi

exit "$fail"
