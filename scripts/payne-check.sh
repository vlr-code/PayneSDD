#!/usr/bin/env bash
# PayneSDD — repo self-check = the machine check for THIS repo (markdown + shell).
#
# From 2.0.0 the protocol is one file, DIGEST.md. The gate checks that it stays
# short and complete, that one version is named everywhere, that the docs point
# at no ghost files, that the shipped shell parses (and lints when shellcheck is
# installed), that local command copies don't drift, and that the dev-mode inbox
# has one path. Run by CI on every push; runnable any time:
#   bash scripts/payne-check.sh
#
# Exit codes: 0 = gate GREEN, 1 = gate RED.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0

# AC1: every shipped shell file must parse under bash (the gate checks itself).
for f in "$ROOT"/scripts/*.sh; do
  if bash -n "$f"; then
    echo "ok   (bash -n)     $f"
  else
    echo "FAIL (bash -n)     $f" >&2
    fail=1
  fi
done

# AC2: shellcheck if present; a missing tool degrades the gate, a broken one fails it.
if command -v shellcheck >/dev/null 2>&1; then
  if ! shellcheck --version >/dev/null 2>&1; then
    echo "FAIL (shellcheck)  $(command -v shellcheck) is present but cannot run" >&2
    fail=1
  elif shellcheck "$ROOT"/scripts/*.sh; then
    echo "ok   (shellcheck)  scripts/*.sh"
  else
    echo "FAIL (shellcheck)  scripts/*.sh" >&2
    fail=1
  fi
else
  echo "note: shellcheck not installed — ran bash -n only (gate degraded, not failed)." >&2
fi

# AC3: one version everywhere — README badge == README "Latest release" == the
# newest entry of the README's ## Status list == top CHANGELOG entry == the
# protocol's own stamp (DIGEST.md).
badge_ver="$(grep -Eo 'version-[0-9]+\.[0-9]+\.[0-9]+' "$ROOT/README.md" | head -n 1 | sed 's/^version-//')"
latest_ver="$(grep -Eo 'Latest release: \*\*v[0-9]+\.[0-9]+\.[0-9]+\*\*' "$ROOT/README.md" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || true)"
list_ver="$(sed -n '/^## Status/,/^## /p' "$ROOT/README.md" | grep -Eo '^- \*\*[0-9]+\.[0-9]+\.[0-9]+\*\*' | head -n 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' || true)"
changelog_ver="$(grep -Eo '^## [0-9]+\.[0-9]+\.[0-9]+' "$ROOT/CHANGELOG.md" | head -n 1 | sed 's/^## //')"
proto_ver="$(grep -Eo '^PayneSDD v[0-9]+\.[0-9]+\.[0-9]+' "$ROOT/DIGEST.md" | head -n 1 | sed 's/^PayneSDD v//')"
if [ -n "$badge_ver" ] && [ "$badge_ver" = "$changelog_ver" ] && [ "$badge_ver" = "$latest_ver" ] && [ "$badge_ver" = "$list_ver" ] && [ "$badge_ver" = "$proto_ver" ]; then
  echo "ok   (version)     badge / Latest release / Status list / CHANGELOG / DIGEST.md stamp all $badge_ver"
else
  echo "FAIL (version)     badge='$badge_ver' Latest='$latest_ver' Status list='$list_ver' CHANGELOG='$changelog_ver' DIGEST.md='$proto_ver' — must all match" >&2
  fail=1
fi

# AC4: every local file the shipped docs link to (markdown links in README,
# MAINTAINING, AGENT, DIGEST, CHANGELOG, commands, agents — resolved from the repo
# root, so docs link root-relative; README image src) and every CLAUDE.md
# @-import must exist — docs may not point at ghosts.
missing="$(
  {
    cat "$ROOT/README.md" "$ROOT/MAINTAINING.md" "$ROOT/AGENT.md" "$ROOT/DIGEST.md" "$ROOT/CHANGELOG.md" "$ROOT"/commands/*.md "$ROOT"/agents/*.md \
      | grep -Eo '\]\([^)]+\)' | sed -E 's/^\]\(//; s/\)$//'
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
  echo "ok   (links)       doc links/images + CLAUDE.md imports all resolve"
else
  echo "FAIL (links)       docs reference missing files:" >&2
  printf '%s\n' "$missing" >&2
  fail=1
fi

# AC5: the protocol stays one short file — a ceiling so it can't bloat back
# (2.0.0 was measured at ~5 KB against 1.0.1's 12 KB digest + 70 KB full file),
# a floor and the nine section headings so a gutted stub can't pass. AGENT.md
# is only a pointer to it.
size="$(wc -c < "$ROOT/DIGEST.md" 2>/dev/null | tr -d ' ')"
sections_ok=1
for n in 1 2 3 4 5 6 7 8 9; do
  grep -q "^## ${n}\. " "$ROOT/DIGEST.md" 2>/dev/null || sections_ok=0
done
if [ "$sections_ok" -ne 1 ]; then
  echo "FAIL (protocol)    DIGEST.md lacks one of its sections «## 1.» … «## 9.»" >&2
  fail=1
elif [ -n "$size" ] && [ "$size" -ge 3000 ] && [ "$size" -le 7000 ]; then
  echo "ok   (protocol)    DIGEST.md ${size} bytes (band 3000-7000), sections 1-9 present"
else
  echo "FAIL (protocol)    DIGEST.md size '${size:-missing}' outside 3000-7000 bytes" >&2
  fail=1
fi
agent_size="$(wc -c < "$ROOT/AGENT.md" 2>/dev/null | tr -d ' ')"
if [ -n "$agent_size" ] && [ "$agent_size" -le 1000 ] && grep -q 'DIGEST\.md' "$ROOT/AGENT.md"; then
  echo "ok   (pointer)     AGENT.md is a ${agent_size}-byte pointer to DIGEST.md"
else
  echo "FAIL (pointer)     AGENT.md must stay a short pointer (<= 1000 bytes) naming DIGEST.md" >&2
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

# AC7: the dev-mode inbox path must be ONE path, named in both places that document it.
# shellcheck disable=SC2016  # a literal grep pattern, not a shell expansion
inbox_paths="$(grep -Eoh '`~/\.payne/[^`]+`' "$ROOT/MAINTAINING.md" "$ROOT/commands/payne-edit.md" | sort -u)"
inbox_n="$(printf '%s\n' "$inbox_paths" | grep -c . || true)"
inbox_ok=0
if [ "$inbox_n" = "1" ]; then
  inbox_ok=1
  for f in MAINTAINING.md commands/payne-edit.md; do
    grep -qF "$inbox_paths" "$ROOT/$f" || inbox_ok=0
  done
fi
if [ "$inbox_ok" = "1" ]; then
  echo "ok   (inbox path)  $inbox_paths — one path, named in MAINTAINING.md and payne-edit.md"
else
  echo "FAIL (inbox path)  found $inbox_n distinct path(s): ${inbox_paths:-none} — both docs must name ONE inbox file" >&2
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "GATE GREEN"
else
  echo "GATE RED" >&2
fi
exit "$fail"
