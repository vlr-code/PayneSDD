#!/usr/bin/env python3
from pathlib import Path
import tempfile
import unittest
from compare import oracle


class TrustedOracle(unittest.TestCase):
    def test_agent_cannot_weaken_oracle(self):
        with tempfile.TemporaryDirectory() as name:
            folder = Path(name)
            (folder / "test_labels.py").write_text("")
            (folder / "labels.py").write_text('def normalize_label(value):\n    return "WRONG"\n')
            self.assertNotEqual(oracle(folder).returncode, 0)
            (folder / "labels.py").write_text('def normalize_label(value):\n    if not isinstance(value, str):\n        raise TypeError\n    return value.strip()\n')
            self.assertEqual(oracle(folder).returncode, 0)


if __name__ == "__main__":
    unittest.main()
