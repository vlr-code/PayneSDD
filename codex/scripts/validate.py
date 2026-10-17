#!/usr/bin/env python3
"""Static integrity; does not claim behavioral compliance."""
import ast
import hashlib
import json
from pathlib import Path
import re

INSTANCE = Path(__file__).resolve().parents[1]
ROOT = INSTANCE.parent


def main():
    for path in (INSTANCE / "scripts").glob("*.py"):
        ast.parse(path.read_text(), filename=str(path))
    digest = (INSTANCE / "DIGEST.md").read_bytes()
    assert 3000 <= len(digest) <= 7000, len(digest)
    assert re.findall(rb"^## (\d+)\.", digest, re.M) == [str(n).encode() for n in range(1, 10)]
    # The original nine steps and voice remain byte-identical; only the title,
    # adaptation stamp and appended runtime guidance differ.
    original = (ROOT / "DIGEST.md").read_text().split("## 1.", 1)[1].rstrip()
    adapted = digest.decode().split("## 1.", 1)[1].split("\n## Codex runtime", 1)[0].rstrip()
    assert adapted == original, "Original protocol rules changed"
    baseline = json.loads((INSTANCE / "evidence/claude-baseline.json").read_text())
    for name, expected in baseline.items():
        actual = hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
        assert actual == expected, "Claude file changed: " + name
    for name in ("payne-edit", "payne-review"):
        path = INSTANCE / "skills" / name / "SKILL.md"
        text = path.read_text()
        assert text.startswith("---\nname: " + name + "\ndescription: ")
        assert text.count("\n---\n") == 1
    for path in INSTANCE.rglob("*.md"):
        for link in re.findall(r"\]\(([^)]+)\)", path.read_text()):
            if "://" in link or link.startswith("#"):
                continue
            target = link.split("#")[0]
            assert (path.parent / target).exists(), f"Broken reference: {path}: {link}"
    print("Static integrity GREEN; original Claude files unchanged")


if __name__ == "__main__":
    main()
