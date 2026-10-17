#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
bash scripts/payne-check.sh
bash -n codex/scripts/check.sh
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck codex/scripts/check.sh
fi
PYTHONDONTWRITEBYTECODE=1 python3 codex/scripts/test_install.py
PYTHONDONTWRITEBYTECODE=1 python3 codex/scripts/test_compare.py
PYTHONDONTWRITEBYTECODE=1 python3 codex/scripts/validate.py
echo "CODEX GATE GREEN"
