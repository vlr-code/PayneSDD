#!/usr/bin/env python3
"""Small, explicit Codex-only dev-mode toggle (Python 3.9+)."""
import argparse
import os
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["on", "off", "status"])
    args = parser.parse_args()
    instance = Path(__file__).resolve().parents[1]
    home = Path(os.environ.get("CODEX_HOME", str(Path.home() / ".codex"))).expanduser()
    marker = home / ".payne-dev-mode"
    if marker.is_symlink():
        raise SystemExit("Refusing symlinked dev-mode marker")
    if marker.exists() and marker.read_text().splitlines() != [str(instance)]:
        raise SystemExit("Marker belongs to another instance; no change made")
    if args.action == "on":
        home.mkdir(parents=True, exist_ok=True)
        marker.write_text(str(instance) + "\n")
    elif args.action == "off":
        marker.unlink(missing_ok=True)
    print("ON " + str(instance) if marker.exists() else "OFF")


if __name__ == "__main__":
    main()
