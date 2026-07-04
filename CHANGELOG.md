# Changelog

All notable changes to PayneSDD are documented here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## Unreleased

### Changed
- **Step 5 anti-loophole**: a source-tied adversarial finding is not downgraded
  by the author's own rationale ("intentional" / "left it per YAGNI") — the
  symmetric counterpart to "the verifier is not an oracle", now closing the
  author side too. Borrowed from obra/superpowers' task-reviewer "Do Not Trust
  the Report".

### Added
- **Dev-mode clause-authoring rule** (`/payne-edit`): "match the form to the
  failure" — name the failure a clause targets, then pick the form (prohibition,
  positive recipe, structural slot, predicate conditional) that fits it, since
  the wrong form backfires. Borrowed from obra/superpowers' writing-skills.

## 0.6.0 — 2026-07-03

### Added
- **`DIGEST.md` — the always-on digest**: a ~2.4k-token compressed floor of the
  protocol (tiers + hard floor, every gate, the never-do list, the voice) for
  always-loaded / token-metered setups — ~29% of the full file's 8.1k tokens.
  Opens with the loading rule: on any Light/Full task, read the full `AGENT.md`
  BEFORE the contract. The digest is the floor; `AGENT.md` stays the single
  source of truth. A shipped, tested implementation of the `DEPLOYMENT.md`
  slim-core pattern.
- **Digest drift gate**: `DIGEST.md` carries a sha256 pin of `AGENT.md`;
  `scripts/payne-check.sh` goes RED on any `AGENT.md` edit until the digest is
  re-reviewed and re-pinned (`scripts/payne-digest-stamp.sh`), and enforces a
  size band (8,000–10,500 chars) so the digest can neither bloat back into a
  second full file nor be gutted to a stub that still passes.
- **Measured token costs** (README "Token cost — measured"): live behavioral
  tests — real `claude -p` runs, mechanical scoring — show the digest holds
  every gate the full file holds (no premature code on a hard-floor probe,
  consent before code, cheap trivial answers, persona intact) at roughly a
  quarter of the always-on cost. Committed run summary:
  `benchmark/token-tests-0.6.0.md`.

### Changed
- **Step 0**: the tier is named in your FIRST line — even when missing inputs
  force you to ask before doing anything else. One line, backported from the
  digest's operationalization of the existing "classify out loud" rule.

## 0.5.1 — 2026-07-03

### Added
- **Failure → contract ratchet** (Step 4 + Step 5): a failed gate — or an accepted
  adversarial finding — must ask whether it exposed a hole the contract never
  covered (a missed edge case, a missing negative AC). If yes, the clause plus the
  named check that proves it land FIRST, then the code fix. A bug class the
  contract never learns is a bug you fix twice.
- **Caller-drift check in the fork sweep** (Step 1.5a): when the delivery surface /
  public API already exists, check the new shape against its CURRENT callers
  (cite the caller, file:line) instead of assuming they still match.
- **Compact subagent reports** (Step 5): every protocol subagent (analyst,
  adversarial, quality reviewer) returns one line per finding/fork — source tie +
  claim + proposed fix, an explicit "none" when empty. The main thread's context
  is the budget they spend.

## 0.5.0 — 2026-07-02

### Fixed
- **The enforced gate is now honest and loop-safe** (hooks + snippets + docs).
  The Stop-hook reads its stdin JSON and honors `stop_hook_active`; a stuck-red
  gate blocks up to `PAYNE_MAX_BLOCKS` times (default 3 — the Step 2 iteration
  budget), then RELEASES the stop with an explicit UNVERIFIED / ESCALATE message
  instead of looping (Claude Code force-ends after 8 consecutive blocks anyway —
  the old "literally cannot end" overclaim is gone). The hook path is quoted (a
  project path with a space used to fail OPEN: exit 127 = no gate), the user
  command runs in a fresh shell via `bash -c` (the core's `set -u`/`pipefail` no
  longer leak false REDs), and the snippets ship a `timeout` (a timed-out hook
  silently doesn't block). Honest escalation documented: disarm the marker on
  done, abandoned, or ESCALATED with the red log attached.
- **The self-gate now checks the product, not just two hook files**
  (`scripts/payne-check.sh`): syntax+shellcheck for `hooks/` AND `scripts/`, one
  version everywhere (badge = Latest = CHANGELOG = the new `AGENT.md` header
  stamp), README links and `CLAUDE.md` imports must resolve, dogfood command
  copies must match canon. Plus the first CI (`.github/workflows/gate.yml`) —
  the gate runs on every push and PR.
- **Install docs actually install** (README): a copy-the-hooks step, where slash
  commands / the `payne-quality` agent / `ROLES.md` go, a
  `settings.example.json` pointer, the "(git-ignored)" falsehood about
  `.claude/settings.json` corrected (`settings.local.json` is the personal
  variant), and a security note — `PAYNE_TEST_CMD` is executed on every stop,
  review changes to it like code.

### Changed
- **Contract sweeps** (AGENT.md — Step 1): edge cases are found by a fixed sweep
  (boundary, adjacency, empty, encoding, ordering, precision, idempotency,
  concurrency), not inspiration; and prohibitions are behavior — "must NEVER do
  X" gets a negative AC (`WHEN … SHALL NOT`), distinct from Non-goals (scope).
- **The adversarial pass audits the tests themselves** (Step 5 +
  `/payne-review`): deleted/empty assertions, skips, loosened
  matchers/thresholds, mocks faking the unit under test — how green was reached
  is in scope. On Light, the self-review re-reads the actual diff from disk and
  breaks it as someone else's code — fake the independence you don't have.
- **Consistency fixes across the protocol**: the Light tier note now names
  behavior/data-semantics forks as never-defaulted (synced with 0.4.1); the 1.6
  gate says code = Step 3+ (matching ROLES' placement); ROLES' QA outputs a
  *recommended* verdict — the main thread adjudicates and issues Step 6; the
  decision-log "closing verdict line" contradiction removed; dev-mode
  SELF-NOTICED deduped into PROACTIVITY; `/payne-edit`'s "a typo may be Trivial"
  carve-out removed (the hard floor applies — a typo just has 0 forks);
  `payne-spec`/`payne-edit` opt out of model auto-invocation (the skills merge);
  the SPEC template caught up with EARS ACs and executable references; `AGENT.md`
  carries a version stamp the gate verifies; README/`DEPLOYMENT.md` document the
  zero-footprint variant, `@`-import install, and the `/goal` zero-install gate;
  assorted doc drift repaired (ROLES `PRD`→`SPEC` and "medium task", DEPLOYMENT
  word count, benchmark gate note, README tagline dedup + benchmark link).

## 0.4.7 — 2026-06-27

### Changed
- **README overhaul — plainer opening, deeper protocol, less water.** Reworked the
  landing copy: a new plain-language **"What you get"** opening that says what a
  programmer gains over raw-prompt / vibe-coding (plan agreed before code, "done"
  proven by the machine, an independent skeptic) instead of three paragraphs
  restating the same idea. The **cycle table** now describes what each step actually
  enforces today — EARS acceptance criteria, the AC→check coverage matrix, the
  simplicity rule, no-progress loop-stop, independent adversarial — pointing to
  `AGENT.md` for the full rules rather than duplicating them. The **worked example**
  expanded into a concrete password-reset walkthrough (real `WHEN…SHALL` criteria,
  coverage at the gate, source-tied findings). The **Status** changelog dump trimmed
  from ~40 lines to recent highlights + a pointer to `CHANGELOG.md`. Docs only — no
  protocol rule changed.

## 0.4.6 — 2026-06-27

### Added
- **A "Simplicity & Scope" rule in execution** (AGENT.md — Step 3). The protocol
  guarded *scope* (don't add features outside the contract) and *duplication* (the
  ratchet), but nothing stopped an agent from over-engineering a single
  implementation — speculative abstraction, unrequested config/flexibility,
  handling for impossible states, "1000 lines where 100 would do." Now: write the
  minimum that SATISFIES THE CONTRACT, not the minimum possible — and contracted
  edge cases / error paths / earned abstractions explicitly STAY (the Step-4 gate
  enforces them, so the rule only trims gold-plating, never required behavior).
  Plus a surgical-scope clause: don't silently refactor adjacent code you weren't
  asked to; surface foreign broken/dead code instead of silently fixing or ignoring
  it. Distilled from the most-cited LLM-coding-agent failure mode (over-building) —
  a point Karpathy made in a tweet, recirculated as a community "guidelines"
  distillation (not a file he authored).

## 0.4.5 — 2026-06-27

### Changed
- **The iteration loop now stops when it's stuck, not only when it's out of tries**
  (AGENT.md — Step 2 + Step 6). The budget already capped auto-iterations by count;
  now NO-PROGRESS (two iterations that don't move the same failing check) is a
  distinct escalation trigger alongside budget-exhausted — don't burn a try
  repeating what just failed. Borrowed from agent-loop safety practice (OpenHands'
  "same action repeated without progress" pathological-state detection).
- **The protocol's quality reviewer (`payne-quality`) now loads what it checks**
  (agents/payne-quality.md). Its cross-reference lens (versions / step numbers /
  CHANGELOG / cycle table must line up) was blind to anything outside the diff; it
  is now told to load the whole change plus every cross-referenced file before
  judging — so it can actually catch the breakage that lens exists for.

## 0.4.4 — 2026-06-27

### Changed
- **Dehydration pass — ~20 lines of redundancy trimmed from the always-loaded
  protocol, zero rules changed** (AGENT.md 553 → 533 lines). Removed: the install
  instructions + optional-add-ons catalog (already covered, better, by the README —
  AGENT.md now points there); the second full copy of the "costly-to-reverse" rule
  (kept the operational one in Step 1.5a, reduced the WHAT-YOU-NEVER-DO entry to a
  prohibition + pointer); several tier-applicability restatements collapsed to
  pointers (the Step 4 header already says ALL TIERS; the Step 1.5c / 1.6 "Exception"
  tails just pointed at their own tier notes). CLAUDE.md's ROLES paraphrase collapsed
  to a pointer. Deliberately KEPT: the WHAT-YOU-NEVER-DO digest, ROLES gate
  restatements, the "if you need a paragraph…" aphorism — load-bearing reinforcement,
  not bloat. Driven by an independent two-auditor anti-bloat review.

## 0.4.3 — 2026-06-27

### Changed
- **Acceptance criteria get a structured, machine-mappable shape** (AGENT.md —
  Step 1). Each AC should use the form `WHEN <condition> the system SHALL
  <observable behavior>` (and `IF <failure> THEN ...` for error/edge paths) — a
  shape that maps 1:1 to a Step-4 check and that a vague criterion can't be cast
  into. Distilled from a spec-driven-tooling landscape scan (EARS notation in AWS
  Kiro; SHALL + Given/When/Then scenarios in OpenSpec; requirement-quality
  checklists in GitHub Spec Kit).
- **Acceptance-criteria coverage is surfaced and enforced** (AGENT.md — Step 4).
  The gate must map EVERY acceptance criterion to the check that proves it and show
  that AC→check mapping; an AC with no check is an unverified gap, not a pass. Makes
  the long-standing "each AC → a check" rule mechanical instead of assumed. (Pairs
  with the new structured AC shape above.)
- **The analyst now hunts internal contradictions in the contract** (AGENT.md —
  Step 1.5a). Beyond enumerating decision forks, it flags clauses that conflict (one
  rule forbids what another requires; an AC no edge-case resolution satisfies) so
  they're fixed at contract time, not discovered in Step 5 after the code is written.
- All three refinements distilled from the spec-driven-tooling landscape scan
  (Spec Kit `/analyze` coverage matrix; Kiro's "Analyze Requirements" pass).

## 0.4.2 — 2026-06-27

### Changed
- **Soft-gate is now a justified last resort, not a default** (AGENT.md — Step 4).
  Before settling for a SOFT / by-eye gate on a runnable app/GUI, the agent must
  make an honest attempt to close the loop automatically (drive the real artifact
  end-to-end — spawn the CLI/binary as a subprocess over stdin/stdout, script the
  run) so the agent, not a human validator, sees the result. Only genuinely
  undriveable interactive UI stays SOFT. Closes a permissive escape hatch.
- **Source of truth prefers an executable reference** (AGENT.md — Step 1). When a
  reference implementation or golden dataset exists, diff against it rather than
  docs/eyeballing, and build that comparison harness first, before the main code.
- Both refinements distilled from the JPoint 2026 talk "своя СУБД за час с Claude
  Code" (functional tests vs a reference DB; human-as-validator anti-pattern).

## 0.4.1 — 2026-06-15

### Changed
- **"Costly-to-reverse" rule broadened** (AGENT.md — "WHAT YOU NEVER DO" + the
  Step 1.5a fork categories, kept in sync) — now also covers BEHAVIOR / DATA-SEMANTICS
  forks (analytics event timing/payload, what & when to persist or send, which
  business-logic branch fires), not only technical/stack choices: when more than one
  reasonable reading exists, ASK — even on a small ambiguous follow-up. Born from a
  host-project session that unilaterally chose analytics-event timing and filed the
  rejected alternative as an "open question."
- **Step 6 "Open questions" guard** (AGENT.md) — that section is only for decisions
  still OPEN (nothing built on them yet); a behavior-changing fork must be ASKED before
  coding (re-enter the Step 1.6 gate), never resolved in code and then logged there.
- **README status** — badge + Status section updated from "early · not battle-tested"
  to "actively used on real projects"; the protocol now drives real day-to-day work.

## 0.4.0 — 2026-06-15

### Added
- **Source-over-memory precedence** (AGENT.md, "WHAT YOU NEVER DO") — extended the
  API-honesty rule: when a fresh source of truth contradicts what the agent remembers
  or assumes, the source wins, and never invent an API/parameter absent from it.
- **Step 3 "duplication ratchet"** (AGENT.md) — at the 2nd+ copy of a non-trivial
  block, STOP and propose extracting it into one shared place as part of the current
  task, instead of silently pasting the Nth copy or deferring de-dup. The human still
  decides; the proposal is mandatory. Born from a host-project session that copy-pasted
  one flow into 5 files across 3 tasks before de-dup was raised.
- **`DEPLOYMENT.md`** — an optional guide for running PayneSDD on a token-metered
  / always-on agent (a chat bot, a metered API): the **slim-core** pattern — the
  Step 0 tier classifier + the two persona-honesty safeguards (complete honest
  answer; never invent a fact) stay always-loaded, the full protocol (Steps 1–6 +
  decision log) is read **on demand** only when a task is Light/Full. Most chat pays ~0 protocol tokens; full discipline stays one read
  away. Linked from the README add-ons table. Born from porting PayneSDD onto an
  OpenClaw + Kimi Telegram bot.

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
