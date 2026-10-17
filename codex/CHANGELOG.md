# PayneSDD for Codex — adaptation 1

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
