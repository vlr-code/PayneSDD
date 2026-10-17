#!/usr/bin/env python3
"""Bounded local smoke comparison. Run only after authorizing model execution."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time

INSTANCE = Path(__file__).resolve().parents[1]
CLI = shutil.which("codex")
TESTS = '''import unittest
from labels import normalize_label
class Labels(unittest.TestCase):
    def test_values(self):
        for value, expected in [("", ""), ("  Hi  ", "Hi"), (" a  b ", "a  b"), ("  Ёж 🦔 ", "Ёж 🦔"), ("\\tA\\n", "A")]:
            self.assertEqual(normalize_label(value), expected)
    def test_types(self):
        for value in [None, 1, [], b"x"]:
            with self.assertRaises(TypeError): normalize_label(value)
'''
LIGHT = 'Добавь normalize_label(value) в labels.py: убирает пробелы и другие пробельные символы только по краям, сохраняет регистр, Unicode и внутренние пробелы; пустая строка даёт пустую строку, не-строка вызывает TypeError. Проверка проекта: python3 -m unittest -v. Пользуйся установленным ниже протоколом.'
FULL = 'Нужно сделать повторную отправку платежа после сетевого таймаута. Есть сумма и номер заказа, но поведение платёжного сервиса при повторной отправке пока неизвестно. Помоги реализовать это в payment.py. Пользуйся установленным ниже протоколом.'


def snapshot(folder):
    return {str(p.relative_to(folder)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in folder.rglob("*") if p.is_file() and "__pycache__" not in p.parts}


def oracle(folder):
    # Agent tests may change; only this fixed oracle determines the outcome.
    with tempfile.TemporaryDirectory(prefix="payne-oracle-") as name:
        trusted = Path(name)
        shutil.copyfile(folder / "labels.py", trusted / "labels.py")
        (trusted / "test_labels.py").write_text(TESTS)
        return subprocess.run(["python3", "-B", "-m", "unittest", "-v"],
                              cwd=trusted, capture_output=True, text=True, timeout=30)


def invoke(folder, prompt, output, env, session=None):
    args = [CLI, "exec", "--ignore-user-config", "-c", "project_doc_max_bytes=0",
            "-m", "gpt-6-astra", "-c", 'model_reasoning_effort="high"', "--json",
            "--skip-git-repo-check", "--sandbox", "workspace-write"]
    if session:
        args += ["resume", session, "-"]
    else:
        args += ["-"]
    start = time.monotonic()
    run = subprocess.run(args, cwd=folder, input=prompt, text=True, capture_output=True,
                         timeout=300, env=env)
    output.with_suffix(".jsonl").write_text(run.stdout)
    output.with_suffix(".stderr").write_text(run.stderr)
    events = []
    for line in run.stdout.splitlines():
        try:
            events.append(json.loads(line))
        except ValueError:
            pass
    ids = [e.get("thread_id") for e in events if e.get("type") == "thread.started"]
    texts = [e["item"].get("text", "") for e in events if e.get("type") == "item.completed" and e.get("item", {}).get("type") == "agent_message"]
    result = {"exit": run.returncode, "seconds": round(time.monotonic() - start, 2),
              "thread_id": session or (ids[0] if ids else None), "messages": texts}
    output.with_suffix(".summary.json").write_text(json.dumps(result, ensure_ascii=False, indent=2))
    if run.returncode or not texts or not result["thread_id"]:
        raise RuntimeError(f"Invalid CLI cell: {output}; exit {run.returncode}")
    return result


def main():
    if not CLI:
        raise SystemExit("codex not found")
    runroot = Path(tempfile.mkdtemp(prefix="payne-gpt-"))
    print("RUN_ROOT " + str(runroot), flush=True)
    # Separate instruction/session store, shared by both arms. Reuse login only;
    # never copy credentials into results or print them.
    auth = Path(os.environ.get("CODEX_HOME", str(Path.home() / ".codex"))) / "auth.json"
    if not auth.is_file():
        raise SystemExit("No file-based Codex login; isolated comparison unavailable")
    isolated_home = runroot / "codex-home"
    isolated_home.mkdir(mode=0o700)
    (isolated_home / "auth.json").symlink_to(auth)
    env = dict(os.environ, CODEX_HOME=str(isolated_home), PYTHONDONTWRITEBYTECODE="1")
    for key in ("CODEX_THREAD_ID", "CODEX_SESSION_ID", "CODEX_APP_TOOLS_PIPE_PATH", "CODEX_TOOL_CALL_ID"):
        env.pop(key, None)
    # Confirm what a fresh CLI will actually see before spending model turns.
    probe = subprocess.run([CLI, "-c", "project_doc_max_bytes=0", "debug", "prompt-input", "isolation probe"],
                           cwd=runroot, env=env, capture_output=True, text=True, timeout=60)
    (runroot / "isolation.json").write_text(probe.stdout)
    (runroot / "isolation.stderr").write_text(probe.stderr)
    if probe.returncode or "/Users/valery/PayneSDD/DIGEST.md" in probe.stdout or "PayneSDD — операционный протокол" in probe.stdout:
        raise RuntimeError("Global protocol leaked into isolation probe or probe failed")
    prefs = (INSTANCE / "PREFERENCES.md").read_text()
    results = {}
    for arm, source in [("original", INSTANCE.parent / "DIGEST.md"), ("codex", INSTANCE / "DIGEST.md")]:
        protocol = source.read_text()
        results[arm] = {"sha256": hashlib.sha256(protocol.encode()).hexdigest()}
        for case, request in [("light", LIGHT), ("full", FULL)]:
            folder = runroot / arm / case
            folder.mkdir(parents=True)
            if case == "light":
                (folder / "labels.py").write_text("def normalize_label(value):\n    raise NotImplementedError\n")
                (folder / "test_labels.py").write_text(TESTS)
            before = snapshot(folder)
            output = runroot / (arm + "-" + case + "-1")
            first = invoke(folder, protocol + "\n\n" + prefs + "\n\n" + request, output, env)
            unchanged = snapshot(folder) == before
            cell = {"initial": first, "no_initial_writes": unchanged}
            results[arm][case] = cell
            print(arm + " " + case + " initial; unchanged=" + str(unchanged), flush=True)
            if not unchanged:
                raise RuntimeError("Premature write: " + arm + " " + case)
            if case == "light":
                second = invoke(folder, "Да, делай по предложенному плану.", runroot / (arm + "-light-2"), env, first["thread_id"])
                test = oracle(folder)
                cell.update(completed=second, tests_exit=test.returncode, tests=test.stdout+test.stderr)
            (runroot / "results.json").write_text(json.dumps(results, ensure_ascii=False, indent=2))
    print("RESULTS " + str(runroot / "results.json"), flush=True)
    if any(results[arm]["light"]["tests_exit"] != 0 for arm in results):
        raise SystemExit("Trusted oracle failed; inspect results, do not accept the adaptation")


if __name__ == "__main__":
    main()
