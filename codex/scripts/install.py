#!/usr/bin/env python3
"""Install only the Codex instance, preserving other global instructions."""
import argparse
import hashlib
import os
from pathlib import Path
import tempfile

INSTANCE = Path(__file__).resolve().parents[1]
START = "<!-- PayneSDD Codex: begin -->"
END = "<!-- PayneSDD Codex: end -->"
LEGACY = "# PayneSDD — операционный протокол (глобально, на лету)"


def block():
    return f"""{START}
# PayneSDD for Codex — подключён отдельно
Во всех проектах, кроме `/Users/valery/homework`, в начале сессии явно прочитай:
- `{INSTANCE / 'DIGEST.md'}` — обязательный протокол;
- `{INSTANCE / 'PREFERENCES.md'}` — простой язык, Joe и нулевой след;
- `{INSTANCE / 'MAINTAINING.md'}` — изменение протокола и dev mode.
Это инструкция прочитать живые файлы, не автоматический @-импорт. Если файл
недоступен, сообщи об этом; не утверждай, что протокол загружен. После сжатия
контекста сохраняй согласованный контракт и согласие. В /Users/valery/homework
обычный чат, всё Trivial. Не копируй PayneSDD в проекты.
Навыки: $payne-edit и $payne-review. Для независимого разбора используй доступный
инструмент субагентов, передав контракт и инструкции payne-quality. Само наличие
файла агента не означает, что проверка состоялась. Системные ограничения действуют.
Dev mode определяет маркер в CODEX_HOME (по умолчанию ~/.codex); номер сессии —
CODEX_THREAD_ID. Прямое указание пользователя о режиме имеет приоритет.
{END}"""


def render(old):
    if START in old or END in old:
        if old.count(START) != 1 or old.count(END) != 1 or old.index(END) < old.index(START):
            raise ValueError("Malformed managed block; no changes made")
        left, rest = old.split(START)
        _, right = rest.split(END)
        return left + block() + right
    if LEGACY in old:
        if old.count(LEGACY) != 1:
            raise ValueError("Ambiguous old PayneSDD block")
        left, rest = old.split(LEGACY)
        # Replace only the old PayneSDD top-level section; preserve the next one.
        import re
        match = re.search(r"(?m)^# (?!#)", rest)
        right = rest[match.start():] if match else ""
        return left + block() + "\n\n" + right
    return old.rstrip() + ("\n\n" if old.strip() else "") + block() + "\n"


def atomic_write(path, content):
    fd, name = tempfile.mkstemp(prefix=".payne-", dir=path.parent)
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(content)
        os.chmod(name, path.stat().st_mode & 0o777 if path.exists() else 0o600)
        os.replace(name, path)
    finally:
        Path(name).unlink(missing_ok=True)


def install(home, skills):
    home, skills = home.expanduser().absolute(), skills.expanduser().absolute()
    config = home / "AGENTS.md"
    marker = home / ".payne-dev-mode"
    override = home / "AGENTS.override.md"
    if override.exists() and override.read_text().strip():
        raise ValueError("AGENTS.override.md would shadow the installation; no changes made")
    for path in (config, marker):
        if path.is_symlink() or (path.exists() and not path.is_file()):
            raise ValueError(f"Refusing non-regular target: {path}")
    old = config.read_bytes() if config.exists() else None
    old_text = (old or b"").decode("utf-8")
    new = render(old_text).encode("utf-8")
    # A repeat install respects a deliberately disabled marker.
    enable = START not in old_text
    if marker.exists() and marker.read_text().splitlines() != [str(INSTANCE)]:
        raise ValueError("Dev marker belongs to another instance; no changes made")
    links = {
        skills / "payne-edit": INSTANCE / "skills/payne-edit",
        skills / "payne-review": INSTANCE / "skills/payne-review",
        home / "agents/payne-quality.toml": INSTANCE / "agents/payne-quality.toml",
    }
    for dest, source in links.items():
        if not source.exists():
            raise ValueError(f"Missing source: {source}")
        if (dest.exists() or dest.is_symlink()) and not (dest.is_symlink() and dest.resolve() == source):
            raise ValueError(f"Existing unrelated installation: {dest}; no changes made")
    for name in ("DIGEST.md", "PREFERENCES.md", "MAINTAINING.md"):
        if not (INSTANCE / name).is_file():
            raise ValueError(f"Missing source: {name}")
    created = []
    config_changed = False
    try:
        home.mkdir(parents=True, exist_ok=True)
        if old is not None and old != new:
            backup = home / "payne-backups" / (hashlib.sha256(old).hexdigest() + ".AGENTS.md")
            backup.parent.mkdir(parents=True, exist_ok=True)
            if backup.exists() and backup.read_bytes() != old:
                raise ValueError("Backup content mismatch")
            if not backup.exists():
                atomic_write(backup, old)
            print("BACKUP " + str(backup))
        for dest, source in links.items():
            if not dest.is_symlink():
                dest.parent.mkdir(parents=True, exist_ok=True)
                dest.symlink_to(source, target_is_directory=source.is_dir())
                created.append(dest)
        if enable and not marker.exists():
            atomic_write(marker, (str(INSTANCE) + "\n").encode())
            created.append(marker)
        if old != new:
            atomic_write(config, new)
            config_changed = True
    except Exception:
        if config_changed:
            if old is None:
                config.unlink(missing_ok=True)
            else:
                atomic_write(config, old)
        for path in reversed(created):
            path.unlink(missing_ok=True)
        raise
    print("INSTALLED " + str(INSTANCE))


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--codex-home", type=Path, default=Path(os.environ.get("CODEX_HOME", str(Path.home() / ".codex"))))
    parser.add_argument("--skills-home", type=Path, default=Path.home() / ".agents/skills")
    args = parser.parse_args()
    try:
        install(args.codex_home, args.skills_home)
    except (OSError, ValueError) as error:
        raise SystemExit(str(error))
