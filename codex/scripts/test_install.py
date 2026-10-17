#!/usr/bin/env python3
import importlib.util
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("payne_install", HERE / "install.py")
installer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(installer)


class Installation(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home"
        self.skills = Path(self.temp.name) / "skills"
        self.home.mkdir()
        self.config = self.home / "AGENTS.md"
        self.original = "# Personal\nKeep this.\n\n" + installer.LEGACY + "\nold rules\n## Nested\nold\n\n# Machine\nKeep that.\n"
        self.config.write_text(self.original)

    def run_install(self):
        installer.install(self.home, self.skills)

    def test_preserve_backup_live_links_repeat_and_off(self):
        self.run_install()
        result = self.config.read_text()
        self.assertTrue(result.startswith("# Personal\nKeep this.\n\n"))
        self.assertTrue(result.endswith("# Machine\nKeep that.\n"))
        self.assertNotIn("old rules", result)
        backups = list((self.home / "payne-backups").glob("*.AGENTS.md"))
        self.assertEqual([b.read_text() for b in backups], [self.original])
        self.assertEqual((self.skills / "payne-review").resolve(), installer.INSTANCE / "skills/payne-review")
        self.assertEqual((self.home / "agents/payne-quality.toml").read_bytes(), (installer.INSTANCE / "agents/payne-quality.toml").read_bytes())
        marker = self.home / ".payne-dev-mode"
        marker.unlink()
        self.run_install()
        self.assertEqual(self.config.read_text(), result)
        self.assertFalse(marker.exists())

    def test_collision_is_no_write(self):
        self.skills.mkdir()
        (self.skills / "payne-review").mkdir()
        with self.assertRaises(ValueError):
            self.run_install()
        self.assertEqual(self.config.read_text(), self.original)
        self.assertFalse((self.home / "agents").exists())
        self.assertFalse((self.home / "payne-backups").exists())

    def test_shadow_and_bad_managed_block_rejected(self):
        override = self.home / "AGENTS.override.md"
        override.write_text("other rules")
        with self.assertRaises(ValueError):
            self.run_install()
        override.unlink()
        self.config.write_text(installer.START)
        with self.assertRaises(ValueError):
            self.run_install()
        self.assertEqual(self.config.read_text(), installer.START)

    def test_failure_rolls_back_links_and_marker(self):
        real = installer.atomic_write
        def fail_config(path, content):
            if path == self.config:
                raise OSError("injected config write failure")
            return real(path, content)
        with patch.object(installer, "atomic_write", fail_config):
            with self.assertRaises(OSError):
                self.run_install()
        self.assertEqual(self.config.read_text(), self.original)
        self.assertFalse((self.skills / "payne-review").exists())
        self.assertFalse((self.home / ".payne-dev-mode").exists())

    def test_fresh_install_and_toggle(self):
        self.config.unlink()
        self.run_install()
        env = dict(os.environ, CODEX_HOME=str(self.home))
        for action, expected in [("status", "ON"), ("off", "OFF"), ("on", "ON")]:
            result = subprocess.run([sys.executable, str(HERE / "dev_mode.py"), action], env=env, capture_output=True, text=True, check=True)
            self.assertTrue(result.stdout.startswith(expected))


if __name__ == "__main__":
    unittest.main()
