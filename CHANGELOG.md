# Changelog

All notable changes to PayneSDD are documented here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## 0.3.1 — 2026-06-06

### Changed
- **Persona** (optional flavor): the default `AGENT.md` persona is now **Joe** (a
  McClane / Last Boy Scout hybrid, Gavrilov-dub voice) instead of the drill
  instructor — sardonic and uncensored, but bound by the same guardrail: attitude
  never replaces the work, swearing aimed at the work/bug/legacy and never at the
  person, no -isms. Includes a dosed **SIGNATURE LINES** bank (iconic one-liners
  in Gavrilov dub + canon English, one per moment, never spammed) and a recurring
  🚬 cigarette tic punctuating replies. The persona
  dose now **scales with the tier**: thin-layer/1–2-jabs throttle on a real task
  (Light/Full), full voice off the leash in plain chat / Trivial no-code Q&A —
  with two safeguards that never relax (a persona-stripped reply must still be a
  complete honest answer; never invent a fact to land a line). `README.md` and
  `ROLES.md` persona references updated to match. The persona stays optional and
  the protocol (Steps 0–6) is unchanged.

## 0.3.0 — 2026-06-05

### Added
- **Dev mode** (optional, default OFF): a self-improvement capability — the agent
  can edit the canonical PayneSDD repo and commit to it from inside ANY project,
  with explicit approval, via the new `/payne-edit` command. Triggers: the command,
  free text ("improve PayneSDD here" — inferred from context), or a self-noticed
  protocol gap (MANDATORY at task end when dev mode is on — stated even when "none",
  tagged 🔴 Important / 🟡 Medium / 🟢 Optional; never acting without consent).
  Install-time ask + an on/off marker toggle (`~/.claude/.payne-dev-mode`). Changes
  run the full cycle (tier → contract → gate → an independent `payne-quality`
  reviewer agent) before commit, and can optionally bump the version, tag, and cut a
  GitHub release on request. Artifacts: `commands/payne-edit.md`,
  `agents/payne-quality.md`. Never touches the project you're working in.

### Changed
- **Step 4** (machine gate): for a runnable app/GUI a green build + unit tests is
  necessary but NOT sufficient — a smoke-launch is part of the gate, and interactive
  UI that can't be auto-driven is a soft/by-eye gate (stated as such in the verdict).
  When the gate needs a heavy or possibly-absent toolchain (Xcode + simulator, an
  Android SDK, a device), the agent must ASK the human to choose: run the FULL gate,
  or a LIGHTER alternative that installs no extra IDE/deps. Born from the PresetLab
  benchmark, where build + unit tests were green but the app crashed on first launch.

## 0.2.3 — 2026-06-05

### Changed
- Step 4 (machine gate) hardened: before declaring a gate tool unavailable and
  escalating, the agent must FIRST confirm the tool is genuinely absent — check
  what's INSTALLED, not just the active/default config (a tool you failed to find
  is not a missing tool). Closes a failure mode where a shallow probe (e.g.
  `xcode-select -p` reporting Command Line Tools) was mistaken for "no Xcode" when
  full Xcode was installed.

## 0.2.2 — 2026-06-05

### Added
- **Closing summary** (Step 6): every Light/Full task now ends with a compact,
  fluff-free checklist *under* the PASS/ITERATE/ESCALATE verdict word — **Done**
  (`- [x]`), **Remaining** (`- [ ]`, scoped work rolled into a next iteration),
  and **Open questions** (plain bullets — decisions/unknowns that need a human,
  distinct from Remaining work). All three headers are always shown; an empty one
  renders as `- none`, never silently dropped. Honor-system (no hook), emitted to
  the human only — NOT persisted to the decision log. Closes a gap where a large
  task could trail off into a wall of prose with no clear "done vs left" line.
  Trivial tasks are exempt.

### Changed
- README cycle table (Step 6 row), version badge, and Status updated for the
  closing summary; `ROLES.md` notes the summary is part of QA's verdict output.

### Known limits (honest)
- Still not battle-tested.

## 0.2.1 — 2026-06-02

### Changed
- Step 1.5 gains a mandatory fork category for **costly-to-reverse technical
  choices** (platform, language, framework/stack, persistence, key dependencies):
  the agent may decide low-stakes details itself, but must ASK — never silently
  default — when guessing wrong would force a rewrite ("when in doubt, treat it
  as costly and ask"). Reinforced by a new `WHAT YOU NEVER DO` rule and a
  Light-tier note, so it binds on every tier. Closes a gap where the agent could
  pick a stack (e.g. SwiftUI vs UIKit) without asking.

## 0.2.0 — 2026-06-02

### Added
- **Execution tiers** (Step 0): Trivial / Light / Full. The agent proposes the
  tier (one-line justification, human veto/bump). LIGHT is a new
  lightweight-but-verified path — skips the analyst subagent and the depth menu,
  keeps a one-line consent STOP, the FULL machine gate, and a short
  self-adversarial pass. A HARD FLOOR (billing, concurrency, migrations,
  public-facing, SDK, security, …) forces FULL; "when in doubt, bump up" guards
  against self-under-classification.
- **Decision Log (core)** at `.payne/decisions.log` (committed, append-only):
  `[APPROVED]` / `[REJECTED]` / `[DEVIATION]` one-liners the agent writes on any
  Light/Full task. Audit trail, anti-drift, cross-session memory — no script, no
  hook.
- `benchmark/` — a human-checkable benchmark task (a Swift image-downloader app)
  to run through the protocol after big changes, with a plain pass checklist.
- A plain-language communication rule: label internally for traceability, but
  explain to the human in plain words (no undecoded AC / fork-ID shorthand).

### Changed
- Steps 1.5 / 1.6 / 4 / 5 reconciled for tiers: 1.5 (analyst + depth) is
  FULL-tier; the 1.6 consent STOP and the Step 4 machine gate run on both Light
  and Full; Step 5 is an independent subagent on FULL, a self-review on LIGHT.
- README cycle table, `CLAUDE.md`, `ROLES.md` updated for tiers + the decision
  log.

### Known limits (honest)
- Still not battle-tested.

## 0.1.0 — 2026-06-01

First public release.

### Added
- `AGENT.md` — the core operating protocol (Steps 0–6: contract → interrogate &
  depth → plan-approval STOP → machine gate → adversarial pass → verdict), with
  the "verifier is not an oracle" rule and an explicit escalation budget.
- Optional "drill instructor" persona, with a hard dosage rule (substance first).
- `templates/SPEC.template.md` — fixed contract skeleton for Step 1.
- `hooks/payne-gate-core.sh` — portable gate engine: runs your test command,
  red = exit 1. Agent-agnostic.
- `hooks/payne-gate.sh` — Claude Code Stop-hook wrapper: "smart" mode (fires only
  when a `.payne-active` spec marker exists), blocks finishing on a red gate.
- `commands/payne-spec.md`, `commands/payne-review.md` — two Claude Code slash
  commands for Step 1 (start a contract) and Step 5 (adversarial review).
- `ROLES.md` — optional multi-agent overlay (Analyst→Product→Architect→Scrum
  Master→Developer→QA) mapped onto Steps 0–6, for large tasks only.
- `README.md`, `LICENSE` (MIT).

### Known limits (honest)
- **Not battle-tested.** Fresh project, no production mileage yet. Treat as a
  strong protocol, not a proven product.
- **Enforced gate is Claude-Code-only.** The Stop-hook auto-enforcement needs
  Claude Code. On other agents run `hooks/payne-gate-core.sh` on request — there
  the gate is advisory, not blocking.
