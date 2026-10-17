# PayneSDD for Codex

## Adaptation 1.1 — named reviewer registration

2026-10-17 · Tag: `codex-adaptation-1.1` · Fix release for adaptation 1.

The first installer made `payne-quality` visible in the role catalog but did not
register its configuration for the launcher. Native named spawns failed with
`agent type is currently not available`; fallback review worked.

- Registers `agents.payne-quality.config_file` in Codex's `config.toml`.
- Preserves unrelated settings and matching roles; rejects conflicting roles and
  invalid TOML before writing. Backs up settings and rolls back partial updates.
- Requests the named role first in the protocol-edit and review skills.
- Adds four installer regression tests covering registration, existing roles,
  rollback and invalid configuration; all four detected intentional failures.

Validation: native named-role launches succeeded in a fresh CLI without overrides
and in the desktop application after restart, without fallback or copied reviewer
instructions. The combined gate passed all ten tests (nine installer tests and
one test-oracle check); independent review returned SHIP. Evidence:
`codex/evidence/named-role.md` and `codex/evidence/named-role-activation.json`.

Upgrade: run `python3 codex/scripts/install.py` from the repository root, then
restart Codex to reload role settings. TOML parsing needs Python 3.11+; older
launchers can use an already installed Python 3.11–3.14 from PATH or uv.
No interpreter is downloaded. Personal project preferences remain owner-specific.

The protocol's nine steps and adaptation-1 core remain unchanged. No Claude files,
version numbers or releases change; Claude v2.0.2 remains the repository's Latest.

## Adaptation 1 — initial release

2026-10-17 · Tag: `codex-adaptation-1` · Based on PayneSDD v2.0.2.

First separate Codex instance, stored entirely under `codex/`. The original
Claude protocol, configuration and release version remain unchanged. This release
does not replace the repository's Latest release for Claude.

- Preserves the nine protocol steps, Joe persona, plain-language preferences,
  consent before edits and independent review.
- Adds explicit loading through Codex AGENTS.md, `payne-edit` and `payne-review`
  skills, a reviewer definition and Codex-specific dev-mode paths/session IDs.
- Includes an installer that preserves unrelated global instructions, backs up
  AGENTS.md, checks conflicts and supports repeated installation.
- Includes integrity checks, installer tests and a fixed test oracle for the
  small GPT comparison.

Validation: independent review returned SHIP; the combined machine gate passed,
including six tests. Each new test detected a relevant intentional failure.
The small comparison used gpt-6-astra/high: both original and adapted protocols
waited for consent, completed the approved Light task with passing tests, and
stopped to ask about duplicate-payment protection in the underspecified Full task.
This is smoke evidence, not a statistical reliability or token-cost claim.

Known limits: the tested CLI 0.163.0-alpha.10.2 rejected the named `payne-quality`
role. The skills have a verified fallback to an ordinary independent subagent
given the same reviewer instructions. Personal preferences retain the owner's
homework exception and Moonly project path; inspect them before installing in
another environment.

Install from the repository root: `python3 codex/scripts/install.py`.
Check from the repository root: `bash codex/scripts/check.sh`.
Details and evidence are in `codex/README.md` and `codex/evidence/validation.md`.
