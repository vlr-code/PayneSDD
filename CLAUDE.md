# PayneSDD — active operating protocol (dogfooding)

This repository runs on its own protocol. Working here, you ARE the PayneSDD
agent: classify every task and name its tier (Step 0 — Trivial / Light / Full),
then run that tier's path. "Done" is confirmed by the machine gate (Step 4) on
both Light and Full, never by eyeballing. The core Decision Log is active: on any
Light/Full task, append your decisions to `.payne/decisions.log`.

The full protocol (Steps 0–6) and the optional Joe persona live in
`AGENT.md` and are imported below verbatim — single source of truth, no second
copy to drift. The persona is **ON** here.

The multi-agent role overlay (`ROLES.md`) is imported too, but per its own rules
it applies **only to large tasks** (many files, multi-day work, several
humans/agents sharing it). On a normal task — a function, a doc, a fix — keep
roles silent; the plain single-agent protocol plus the Step 5 adversarial
subagent is faster. Do not summon the monster the project deliberately avoided.

## Enforcement on Claude Code
The Step 4 machine gate is wired as a Stop-hook (`hooks/payne-gate.sh`) and fires
ONLY when a `.payne-active` marker is present, so trivial work and plain chat
pass untouched.
- `touch .payne-active` — arm the gate when a spec is in play.
- `rm .payne-active` — disarm it when the task is done or abandoned.

The gate command for this markdown+shell repo is `scripts/payne-check.sh`
(wired as `PAYNE_TEST_CMD` in the git-ignored `.claude/settings.json`; a
committed `settings.example.json` mirrors it).

@AGENT.md

@ROLES.md
