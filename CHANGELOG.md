# Changelog

All notable changes to PayneSDD are documented here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## Unreleased

### Added
- **Widening what a check LETS THROUGH is named as a loosening (Step 4,
  DIRECTION ASYMMETRY).** The rule's three examples were all subtractive —
  deleting a test, relaxing a threshold, dropping a lint rule — so an author who
  grows a matcher's acceptance reads the rule and does not recognise their own
  act in it. That happened here, inside this release, and the independent review
  caught it rather than the author. Strengthening still needs no permission —
  the direction is read at the VERDICT, not at the pattern: more reds is free,
  more passes needs consent.
- **A published number carries the rule that produced it (NEVER list).** A figure
  in anything others will read ships with the definition it was computed under,
  in a form a reader can recompute; without that it goes out as words, no digits.
  No measured effect on the stand (see the block below). ONE number published by this
  project was withdrawn on 2026-09-12 for exactly
  this — one claim carrying three figures (a false-alarm rate and two power
  numbers) quoted from a simulation that is nowhere on record. (A second
  withdrawal the same day, a sign-test p, fell to plain recomputation instead;
  this clause would not have caught it.) The clause found three live violations
  during its own review, one of them this project's own unit-less "+984" in the
  decision log — 984 characters, 986 bytes.

**What the stand said about these two, and about the third that is not here.**
A 60-run epoch (`benchmark/item5-2026-09-12.json`) compared 0.8.0 as released
against 0.8.0 plus all THREE clauses — the two below and the one that did not
survive — under a rule registered in the decision log
BEFORE launch: a no-regression bar AND a benefit bar — a clause ships only if
its trap shows the candidate passing where the base fails in at least one run.

- No regression: PASS. Worst gated z is −1.55 on "did not write before consent"
  (22/24 → 18/24), second worst −1.24; the rule needs two gated dimensions at
  −1.5 or worse and there is one, so the PASS does not rest on any noise
  estimate. For scale only: identical text re-run against itself moves that same
  dimension by −1.69 — but that pair spans two epochs and this project's own
  page says such a pair overstates the noise inside one epoch, so read −1.69 as
  an upper bound. The within-epoch band is unmeasured.
- Benefit: NOT SHOWN, on either trap. A third clause — "a check's refusals get
  read, not just its greens" — was written, measured and then **dropped on its
  own evidence**: handed a linter whose complaints are 3-of-5 false, the agent
  passed the trap's behavioural check in every run of BOTH arms. (By hand, not by
  a scored dimension: the base arm named the false complaints in one of its two
  runs and the candidate in both — n=2, and not a verdict.) It is a
  rule for a scale this stand does not reach, and shipping it anyway would have
  made it unfalsifiable.
- The number clause above is kept with its null result stated: its trap failed
  in both arms — every run published a speed-up figure and left no measurement
  script behind. It ships on the incidents that motivated it, not on a measured
  effect, and this sentence is the disclosure.
- The DIRECTION ASYMMETRY clause has no trap at all; that was declared before
  the run, not after. A two-turn coding task cannot honestly stage a temptation
  to widen a matcher's acceptance.

### Fixed
- **The consent probe read the vocabulary, not the turn.** "Собрать так, или
  поправить?" and "Как решаем?" scored as "never asked for consent" — 11% of all
  such verdicts on record. It now reads the SHAPE of the turn: a question in the
  last non-empty line (measured: the ask sits there in 363 of 365 stored turns),
  with the word list and the Light carve-out's echo kept as further branches.
  22 runs flipped false → true on re-scoring, none the other way. Shipped in the
  same round as the verification-command fix below; it had no entry of its own
  until now, which is why a count of five repaired probes — gate, consent, tier,
  summary, premature-write — did not add up in this file until this entry.
- **Three more measurement probes were broken, and every epoch on disk is
  re-scored again.** "Named the tier" was blind to `Light tier —`, `(Light)`
  and `Trivial → Light`, and it read only the agent's first text block, so a
  one-line "let me look at the file" before the tier line scored as never naming
  the tier. Of its 154 negatives, 36 flip on the new shapes, 48 on the wider
  window, 1 needs both, and 69 were genuinely never named. "Verdict + closing
  summary" read the LAST TURN instead of the run, so a run finished inside turn
  1, whose second turn only acknowledges it, scored as having produced no
  summary — 50 of 91 negatives, none of which wrote new content in turn 2. "Did
  not write before consent" read a `>` inside `awk 'NR>1'`, a `python3 -c` string
  or a heredoc body as a redirect, and missed `echo hi>out.txt` entirely — it now
  strips shell literals before looking, and counts a file opened for writing by a
  heredoc script: 9 verdicts. All 144 flips run in one direction, false → true:
  the probes were blind, not biased in their calls. They do NOT fall evenly —
  two arms gain nothing, and on one epoch the tier row's direction between the
  arms reverses — so a PRE-repair tier number carries over neither its digits
  nor its arm-to-arm sign. Each fix is pinned by a fixture shown RED against the
  old logic first (F17–F22), and the window
  decision was registered in the decision log BEFORE re-scoring, with the
  arm-level effect deliberately unseen at that point. One stored verdict
  changes: the 2026-08 haiku rejection (`e5-cch-borrows`) no longer trips the
  two-dimension clause, so that clause loses its only supporting example — it is
  KEPT (loosening a check needs its own consent) and now carried on argument,
  flagged as an open question. Every talk-level rejection stands, with different
  digits. Full tables: `benchmark/probe-repair-2026-09-12.json`.
- **Two published numbers are withdrawn.** `batch2-2026-09-12.md` gave the
  between-epoch sign test as p = 0.008 (it is p = 0.04 on recomputation) and
  quoted false-alarm/power figures of 22–29%, ~63% and ~9% with no source; the
  simulation behind them is not on record and they are retracted in favour of
  what was actually measured.
- **The verification-command probe was broken, and every number it produced is
  re-scored.** It matched the task's own symbol against the shell command, so a
  real `python3 -m unittest test_x.py` counted as "no gate" — 15 of 16 such
  negatives in one epoch flipped on re-scoring. It now recognises what was
  actually run (test runners, linters, an interpreter pointed at a test or check
  file, evaluated per line so a command that only TALKS about a test does not
  count), with the old symbol match kept as one branch. The epochs still on disk
  (e5–e11) were re-scored from their transcripts; the before/after is preserved
  beside each scores file, and the 2026-09 snapshots carry corrected rows naming
  their original numbers. The July epochs cannot be re-scored — their
  transcripts are gone — so `findings-2026-07.json` keeps its old numbers and
  says so. No verdict shipped in 0.8.0 changes.

### Changed
- **The acceptance rule is a test, not a count.** Measured against identical
  text, "no dimension may drop by 3 or more" fired on two of the three pairs on
  disk; the two-proportion z test replacing it fired on none. A candidate is now
  rejected on z ≤ −2 on a gated dimension (one scored by at least four tasks),
  on two gated dimensions at −1.5, on a fall in task outcome, or on a fall in a
  pre-registered trap dimension — the outcome floor and the trap gate are kept,
  not dropped. Single-task dimensions are reported, never gated. Base and
  candidate must run inside one epoch: across those pairs the later epoch was
  worse on 31 moved cells against 16 better (sign test p = 0.04, correlated
  cells, two epoch transitions — a direction, not a calibrated number). Neither
  rule can see a ~20% degradation at this budget; z buys false-alarm control and
  invariance to n, not power. One rejection made under the old rule on
  2026-09-12 (the terse level's second cut, worst z −1.26 — −1.45 after the
  probe repair below) is now known to have been a false alarm. Numbers and method:
  [`benchmark/rule-change-2026-09-12.json`](benchmark/rule-change-2026-09-12.json);
  methodology: [`benchmark/README.md`](benchmark/README.md).

## 0.8.0 — 2026-09-12

### Added
- **Talk level — an optional setting** (`standard` / `plain`): how much the
  agent says, never what it does. A short block in the host's always-loaded
  config (≈430 tokens) names the level and carries its recipe; the human
  switches in plain words, and "remember it" rewrites that block. Gates, contract, checks, the verdict, the
  anchors (tier line, verdict word, summary headers, consent question) and the
  persona's own lines are exempt — the level shapes the substance, not the voice.
  Harness-validated before shipping (72 runs, three arms, pre-registered
  thresholds): worst dimension −1 against base, outcomes 22/22.
  Three earlier cuts of the wording were REJECTED — two for making agents skip
  the consent gate, the third for dropping the tier line. On those same runs
  replies came out ~39% shorter (the plan-and-questions turn −42%) while a
  blind, position-swapped judge over all 12 tasks found no quality drift
  (2-2-8) — the pre-registered ≤60%-of-base length target was missed
  narrowly, at 61%. A third level (`terse`) was built, measured and DROPPED in
  the same cycle: against `plain` it saved nothing on the median (185 vs 186
  words), about 7% on the mean, and carried nearly double the Latin-token share
  — not enough to earn a third level's cost.
  Committed run summary:
  [`benchmark/talk-level-2026-09.md`](benchmark/talk-level-2026-09.md).
- **Dev-mode inbox** — with dev mode ON, every gap the agent reports is also
  appended, once per task, as one self-contained line to a local inbox in the
  human's home (outside every repo, never committed, appended never rewritten,
  no secrets or project code; a failed write is said out loud, a "none" report
  writes nothing). `/payne-edit inbox` triages it: snapshot first so concurrent
  sessions lose nothing, re-check every line against the CURRENT protocol, one
  plain list for the human, taken items in a single batched cycle, deferred ones
  back to the inbox, snapshot dropped only on an explicit yes.

### Changed
- **Five recurring gaps closed**, collected from real sessions by the dev-mode
  inbox, most of them reported more than once before they were taken. Measured
  run: [`benchmark/top5-2026-09-12.md`](benchmark/top5-2026-09-12.md) — consent
  13/18 → 16/18, outcomes 21/22 → 22/22, worst drop −1 over 52 runs, and the new
  trap task held. The Light carve-out below never fired in that run, so only its
  harmlessness is measured:
  - **Step 4 — a green must be earned twice.** The AC→check map now carries, per
    check, what shows it actually RAN and the value that would make it RED; a
    check you wrote for this task is shown red once (break, watch, revert — a
    reverted proof, not a weakening). The "never FIRED" species moves here from
    Step 5, whose audit item is now a pointer, not a second copy.
  - **Step 4 — a blind check is a broken check**, fixed BEFORE the run and
    symmetrically for everything compared; repairing a measurer after its
    numbers arrive is tuning the result.
  - **Step 5 — a check born of a finding is ratcheted like any other**: seen red
    against the state the finding described, then green.
  - **Step 1.6 — the directive that is already the plan (Light only).** When the
    human's own message IS the whole plan and the block you would show would be
    a verbatim echo of it, echo it in one line and go. Never consent for an
    irreversible act their words did not name; an answer to a question YOU asked
    is never such a directive; anything you had to interpret re-enters the gate.
  - **Step 1.6 — the ground moves**: re-read the destination's current state
    immediately before an irreversible step when anything else can write there.
  - **Step 1.5b — a bare "go" at the depth menu answers the DEPTH question**:
    fast mode, its defaults listed for veto, the plan gate still happens, and
    fast is not silent.
- **Five more gaps from the inbox** — evidence is stamped with the state it ran
  against and the verdict confirms that state has not moved; a reviewer's report
  carries a required NOT CHECKED line (`none` when it covered everything);
  wiping your own working infrastructure joins the irreversible list; an
  external system whose code you cannot read is gated by a controlled
  experiment, named in the plan before it runs and reported with whatever it
  left behind; the analyst brief carries the decisions the human already pinned.
  Measured run: [`benchmark/batch2-2026-09-12.md`](benchmark/batch2-2026-09-12.md)
  — PASS on the pre-registered bar. (The entry originally reported `gate_ran`
  falling 9/16 → 7/16 as an unexplained drop; the probe behind that number was
  broken and the re-scored delta is −1. See the correction above.) None of the
  five is exercisable on
  the harness (no second writer, no push, no external system, no live reviewer),
  so the run is a no-regression check, never evidence they work.
- **A measured noise band, and what it costs us** — the same base payload re-run
  against itself moved `consent_asked` by −4 and `no_premature_write` by −4 at
  two runs per cell. The −3 acceptance bar this project has used all along sits
  INSIDE that drift for the consent family: large rejections (−9, −10) stand,
  a −3 or −4 verdict does not. Numbers in the same artifact.
- **Questions are phrased by consequence** — every option says what it changes
  for the human in practice; "I don't understand the question" is not an answer:
  re-ask it plainer, never take your own default silently on the back of it
  (Step 1.5c; Light's inline forks follow the same shape).
- **Closing-summary headers in the human's language** — the three headers are
  translated (in Russian: «Сделано» / «Осталось» / «Открытые вопросы»); the
  verdict word and the tier line stay as they are.

## 0.7.0 — 2026-09-02

### Added
- **Stop-hook behavior test** — `scripts/payne-gate-test.sh` drives the real
  hook end to end (dormant / block / consecutive count / release after
  `PAYNE_MAX_BLOCKS` / green and fresh-chain resets / unset `PAYNE_TEST_CMD` /
  disarm-while-red) and, in `--mutants` mode, proves it can go red on six
  deliberately broken hook copies. Wired as `payne-check.sh` AC7 (hard fail).
- **Stop-hook: disarming while red is loud** — removing `.payne-active` while a
  red-block counter is on record no longer passes silently: the next stop still
  passes (dormant means dormant) but prints a user-facing `systemMessage`
  naming the disarm and the UNVERIFIED state. Documented as a tripwire, not a
  lock (`DEPLOYMENT.md`, README, hook header).
- **Dev-mode reviewer checks the digest** — `payne-quality` now loads
  `DIGEST.md`, judges it as a faithful compression of `AGENT.md` (never a
  superset, never a different rule) and reports a required `Digest:` line
  (FAITHFUL / RE-STAMP-ONLY with reason / REVISE).

### Changed
- **Step 5: no-subagent host on Full** — try a configured reviewer agent, then
  any general subagent; only a host with no subagent mechanism at all falls
  back to a DISCLOSED self-pass, and the verdict is then never PASS — ESCALATE
  with the self-pass attached, the human is the independent reviewer (Step 6
  names that unavailable reviewer). The stray "Where possible" sentence is gone.
  Same clause in `/payne-review`; Step 1.5a gets the matching inline-sweep
  fallback.
- **Step 4: ratchet closures are logged** — an unambiguous contract ratchet
  closes with a `[DEVIATION]` line only; the chat-only "plan note" alternative
  contradicted the NEVER list and the digest ("closures logged, never silent").
- **Dev mode: configured at install, not asked per run** — the un-keepable
  "ask ONCE on first run" (an agent has no memory of a first run) became a
  fifth install-interview question (default OFF); `/payne-edit on` writes the
  resolved repo path as the marker's first line.
- **Dev-mode discipline is trigger-agnostic** — the full cycle applies however
  the request arrives, via `/payne-edit` or plain chat.
- **ROLES: Product drafts before the Analyst** — the chain is now
  `Product (draft SPEC) → Analyst → [human: depth + answers] → Product (final
  SPEC) → …`, so the Analyst's contract-contradiction hunt has a contract to
  inspect.
- **DEPLOYMENT: `ROLES.md` on demand** — import it always-on only if you run
  roles routinely; the digest's pointer is enough otherwise (~1k tokens per
  session saved).

### Fixed
- `/payne-edit` §4 described the 0.3.0-era gate ("lints `hooks/*.sh` only,
  can't go red on docs"); it now names the real checks — shell lint, one version
  everywhere, links/imports, digest pin + size band, copy-sync, hook behavior —
  and the digest re-review + re-pin step.

## 0.6.2 — 2026-08-11

### Added
- **Step 4: direction asymmetry on check edits** — adding or strengthening a
  check never needs permission; removing or loosening ANY existing one (deleting
  or skipping a test, relaxing a threshold, dropping a lint rule) is a surfaced
  proposal needing explicit consent BEFORE it happens, even when legitimately
  motivated.
- **Step 4: red-proof for ratcheted checks** — a check added by the contract
  ratchet must be seen failing against the pre-fix broken state that motivated
  it before its green counts; a check never seen failing is unproven.
- **Step 5 test-audit: two new fake-green species** — checks that never FIRED
  (an env/config exemption, an early abort, or a CI ignore kept the check from
  running — confirm it executed and can still fail) and bugfix claims with no
  red reproduction on record. Same list updated in `/payne-review`.
- **Step 5: drift runs in both directions** — beside undeclared extras, the
  adversarial pass hunts contracted/planned items the diff never touched;
  silently dropped work is a finding, never left to the author's own Remaining
  list. Same in `/payne-review`.
- **Step 1.6: the plan names irreversible/external actions** — foreseeable
  pushes, deletions, sends, publishes are enumerated in the plan; the "yes"
  covers exactly the named set, and an unnamed such action re-enters the gate
  BEFORE acting — never a post-hoc [DEVIATION]. On Light the names ride the
  one-line consent.
- **NEVER list: not-observed ≠ absent** — a failed search, an unread file, or
  missing evidence is UNKNOWN, never "doesn't exist / no problem"; a claim of
  absence needs its own observation, like a claim of presence.
- **Dev-mode: public claims gated by evidence** (`payne-quality` lens +
  `/payne-edit` doc gate) — a capability/benefit claim in README/CHANGELOG
  exists only with its evidence, and wording may not outrun what was proven.

All seven distilled from a competitor-protocol scan (adapted to protocol-shape;
the competitor's enforcement machinery deliberately not taken). The six
AGENT.md rules are stand-validated on a sonnet-class arm (no discipline dim
regressed beyond noise, outcome held); a haiku-class arm traded ceremony dims
for honesty dims — consistent with the documented model floor.

## 0.6.1 — 2026-07-22

### Added
- **`benchmark/FINDINGS.md` — measured findings, plain language**: version check
  (7 improved / 0 regressed), competitors prescribe but don't behave, the
  persona block is load-bearing, the zero-sum compliance budget on weak models,
  the ask-bottleneck, the latent-contradiction blind spot. Numbers snapshot:
  `benchmark/findings-2026-07.json`; all caveats inherited from the run reports.

- **Dev-mode clause-authoring rule** (`/payne-edit`): "match the form to the
  failure" — name the failure a clause targets, then pick the form (prohibition,
  positive recipe, structural slot, predicate conditional) that fits it, since
  the wrong form backfires. Borrowed from obra/superpowers' writing-skills.
- **Step 5 test-audit: tautological assertions** — the audit list now names a
  fifth fake-green tell: an expected value recomputed the way the code computes
  it is green by construction; expecteds must come from an independent source
  (a known-good literal, a worked example, the spec). Same list updated in
  `/payne-review`. Borrowed from mattpocock/skills' tdd reference.
- **The decision log is READ, not only written** — at contract time on a
  Light/Full task, scan the log for prior decisions touching the same ground; a
  resembling [REJECTED] is surfaced with its recorded reason as a question,
  never silently re-proposed and never an automatic veto. Borrowed from
  mattpocock/skills' triage out-of-scope knowledge base.
- **Step 1.5c question ordering** — a question whose premise hangs on another
  question still open in the same round waits for the next round.
- **Dev-mode no-op test** (`/payne-edit` + `payne-quality` anti-bloat lens): a
  sentence that does not change agent behavior versus the model's default is
  deleted whole, never trimmed; disputes are settled by a measured behavioral
  run, not debate; deliberately kept, evidence-backed reinforcements are exempt.
  Borrowed from mattpocock/skills' writing-great-skills.

### Changed
- **DEPLOYMENT: measured model floor for the digest** — the digest's gates were
  validated on Sonnet-class models; on a Haiku-class benchmark epoch they held
  only ~40–60% of runs, and ADDING emphasis text made adherence worse (+8%
  digest size, drops across every discipline metric — density beats placement).
  Guidance: on a small model import the full `AGENT.md`, don't fatten the digest.
- **Step 5 anti-loophole**: a source-tied adversarial finding is not downgraded
  by the author's own rationale ("intentional" / "left it per YAGNI") — the
  symmetric counterpart to "the verifier is not an oracle", now closing the
  author side too. Borrowed from obra/superpowers' task-reviewer "Do Not Trust
  the Report".

### Fixed
- `/payne-edit` §7 no longer instructs a `Co-Authored-By` commit trailer — it
  contradicted the maintainer's standing no-attribution rule.

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
