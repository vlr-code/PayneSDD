#!/usr/bin/env bash
# PayneSDD — re-pin DIGEST.md to the current AGENT.md after a digest review.
#
# The digest is hand-maintained; this stamp is the machine half of the drift
# gate: payne-check.sh goes RED whenever AGENT.md's hash no longer matches the
# pin, forcing a conscious DIGEST.md review on every protocol change. Run this
# ONLY after actually reviewing the digest against the changed AGENT.md.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -f "$ROOT/DIGEST.md" ]; then
  echo "DIGEST.md missing — nothing to stamp; restore it from git first." >&2
  exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
  actual="$(sha256sum "$ROOT/AGENT.md" | cut -d' ' -f1)"
else
  actual="$(shasum -a 256 "$ROOT/AGENT.md" | cut -d' ' -f1)"
fi

if grep -Eq 'pin: AGENT\.md sha256=[0-9a-f]{64}' "$ROOT/DIGEST.md"; then
  tmp="$(mktemp)"
  sed -E "s/pin: AGENT\.md sha256=[0-9a-f]{64}/pin: AGENT.md sha256=${actual}/" \
    "$ROOT/DIGEST.md" > "$tmp"
  # cat, not mv — keep DIGEST.md's own permissions (mktemp files are 0600)
  cat "$tmp" > "$ROOT/DIGEST.md" && rm -f "$tmp"
else
  printf '\n<!-- pin: AGENT.md sha256=%s -->\n' "$actual" >> "$ROOT/DIGEST.md"
fi

echo "DIGEST.md pinned to AGENT.md sha256=${actual}"
