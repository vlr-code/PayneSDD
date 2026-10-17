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

    def test_role_registration_preserves_config_and_repeats(self):
        runtime = self.home / "config.toml"
        original = '# personal\nmodel = "chosen-model"\n[agents]\nmax_threads = 3\n'
        runtime.write_text(original)
        runtime.chmod(0o600)
        self.run_install()
        result = runtime.read_text()
        self.assertTrue(result.startswith(original))
        data = installer.parse_toml(result)
        self.assertEqual(data["model"], "chosen-model")
        self.assertEqual(data["agents"]["max_threads"], 3)
        self.assertEqual(Path(data["agents"]["payne-quality"]["config_file"]), installer.INSTANCE / "agents/payne-quality.toml")
        self.assertEqual(runtime.stat().st_mode & 0o777, 0o600)
        self.assertEqual([p.read_text() for p in (self.home / "payne-backups").glob("*.config.toml")], [original])
        self.run_install()
        self.assertEqual(runtime.read_text(), result)

    def test_existing_role_preserved_or_conflict_rejected(self):
        runtime = self.home / "config.toml"
        for prefix in ('[agents."payne-quality"]\n', "[agents.'payne-quality']\n"):
            original = prefix + 'config_file = "/unrelated/reviewer.toml"\n'
            runtime.write_text(original)
            with self.assertRaises(ValueError):
                self.run_install()
            self.assertEqual(runtime.read_text(), original)
            self.assertEqual(self.config.read_text(), self.original)
            self.assertFalse((self.home / "payne-backups").exists())
        original = installer.register_role('', self.home).replace('description = ', 'nickname_candidates = ["Joe"]\ndescription = ')
        runtime.write_text(original)
        self.run_install()
        self.assertEqual(runtime.read_text(), original)

    def test_config_rollback_on_later_failure(self):
        runtime = self.home / "config.toml"
        for original in (None, 'model = "keep"\n'):
            if original is None:
                runtime.unlink(missing_ok=True)
            else:
                runtime.write_text(original)
            real = installer.atomic_write
            def fail_agents(path, content):
                if path == self.config:
                    raise OSError("injected AGENTS write failure")
                return real(path, content)
            with patch.object(installer, "atomic_write", fail_agents):
                with self.assertRaises(OSError):
                    self.run_install()
            self.assertEqual(runtime.read_text() if runtime.exists() else None, original)
            self.assertEqual(self.config.read_text(), self.original)
            self.assertFalse((self.home / ".payne-dev-mode").exists())
            self.assertFalse((self.skills / "payne-review").exists())

    def test_invalid_or_inline_toml_rejected_without_writes(self):
        runtime = self.home / "config.toml"
        for original in ('model = [', 'agents = { max_threads = 3 }\n'):
            runtime.write_text(original)
            with self.assertRaises(ValueError):
                self.run_install()
            self.assertEqual(runtime.read_text(), original)
            self.assertEqual(self.config.read_text(), self.original)
            self.assertFalse((self.home / "payne-backups").exists())


if __name__ == "__main__":
    unittest.main()
