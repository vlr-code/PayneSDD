# Changelog

All notable changes to PayneSDD are documented here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## 2.0.0 — 2026-10-07

### Changed
- **The protocol is one short file.** `DIGEST.md` now holds the whole protocol
  (~1.3k tokens by tiktoken o200k_base, 5,070 bytes): name the tier; write a short contract that puts
  the tricky spots — contradictions, missing data, assumptions, risks — first
  and asks about them; ask before code (one line on Light, a plan block naming
  every irreversible act on Full); prove "done" with the machine check and its
  criterion → check map; break the result (a self-review on Light, an
  independent reviewer on Full); run long work through the manager (each change
  checked by its own tests, the full check and the review at check points, no
  «ok?» for a change the human dictated, nothing dropped); close with a verdict
  and the three-header summary; questions in one block at the end; Joe in a
  few lines. There is no second file to read: the full protocol (`AGENT.md`,
  ~16.7k tokens) and the rule that a Full task reads it are gone; `AGENT.md` is
  now a pointer to `DIGEST.md`. Why: the maintainer asked whether the protocol
  was overdoing it — on the stand the measure of the work itself (outcome)
  stayed inside each pair's acceptance cut across 0.9.8, 1.0.0 and its fix
  (z +0.52, −1.0, −0.48 against cuts of about −2.2)
  (benchmark/verdict-word-2026-10-06.json), while releases moved the ritual
  measures.
  Measured on the local stand in one epoch of 27 tasks, two runs per text
  ([`benchmark/slim-2026-10-07.json`](benchmark/slim-2026-10-07.json), every
  definition and the reading rules registered before the runs): against 1.0.1
  the one-file text passed the acceptance rule (worst measure: checks run, 38
  of 42 against 40, z −0.85, reached by about 88% of random splits of that
  epoch), flagged contradictions in 8 of 8 against 8 of 8, and used 0.56 of the
  input tokens (13.4M against 24.1M) in 0.63 of the mean wall time per run (100
  s against 159 s) — beyond the bar registered before the run, a bar taken from
  another epoch's same-text halves (this comparison's own noise not measured).
  In a 13-turn dialog, three runs each, nothing was forgotten in any run; the
  manager held in 2 of 3 runs against 1.0.1's 3 of 3 (the miss: 5 reviews after
  the first build where the bar is 4), at 0.23 of the tokens and 0.46 of the
  time. A 12-task first look preceded it (a PASS without an admissible cut;
  contradictions flagged 2 of 4 against 4 of 4 there). The shipped file changes
  the title line and adds a version line to the measured text.
- **Rewritten for one file:** README (install is one `@DIGEST.md` line),
  `scripts/payne-check.sh` (the protocol's size band is 3,000–7,000 bytes, the
  version stamp now lives in `DIGEST.md`, `AGENT.md` must stay a pointer),
  `/payne-review`, `/payne-edit` and the `payne-quality` reviewer, and the
  repo's own `CLAUDE.md`. The rules for changing the protocol — the decision
  log, the independent review, measurement on the stand, releases, dev mode and
  its inbox — move to `MAINTAINING.md`; they are not part of the protocol an
  agent runs on a project.
- **Upgrading from 1.x:** import `DIGEST.md` and delete a host line that points
  at `AGENT.md` (a config that loaded `AGENT.md` whole must switch); remove a
  `payne-spec` command copy or link; a copied Stop-hook is no longer maintained;
  a talk-level block still works but its «AGENT.md, TALK LEVEL» pointer is stale;
  dev mode in other projects needs `@…/MAINTAINING.md` in the host config.

### Removed
- The full protocol text in `AGENT.md`, `ROLES.md`, `DEPLOYMENT.md`, the
  enforced Stop-hook (`hooks/`) with its behavior suite and
  `settings.example.json`, `scripts/payne-digest-stamp.sh`, the `/payne-spec`
  command and `templates/SPEC.template.md`. Every rule not in `DIGEST.md` is
  gone from the protocol, among them: the analyst subagent and the depth
  choice, the look-back before outward acts, the decision log in user projects
  (projects no longer keep `.payne/decisions.log`), the ratchets, the helper
  subagent for heavy checks, the no-subagent fallback, the talk level, dev mode
  (now in `MAINTAINING.md`), the measurement-method rules and the long examples.
  All of it stays in the git history (v1.0.1).

## 1.0.1 — 2026-10-07

### Fixed
- **A task closes with its verdict word again (DIGEST.md, Step 6).** The
  digest's Step 6 line now opens with «Light and Full close with ONE verdict
  word as the reply's headline ("**PASS** — <result>")», the manager's Full
  sentence follows it, and the summary sits «under the verdict word». In 1.0.0
  that line opened with the Full manager sentence, and a Light task — which in
  1.0.0 runs on the digest alone — closed without its verdict word far more
  often (counted after the run: 18 of 1.0.0's 23 misses were Light replies with
  the summary headers but no verdict word). Measured on the local stand in one
  epoch of 0.9.8 as installed (19bab52), 1.0.0 and this fix
  (27 tasks, two runs per text, 162 runs;
  [`benchmark/verdict-word-2026-10-06.json`](benchmark/verdict-word-2026-10-06.json),
  with every definition and the reading rule registered before the run): the
  acceptance rule REJECTED 1.0.0 against 0.9.8 on all three seeds — the
  closing verdict with its summary came in 21 of 44 runs against 37 (z −3.60;
  random splits of that epoch reach it in 0.07%), and no other measure came
  near the cut (next lowest: strict consent, 8 of 8 → 6 of 8, z −1.51); with
  the fix it came in 39 of 44 (z +4.12 against 1.0.0, above the bar the rule
  set), and the fix passed the acceptance rule against both texts (its lowest
  measure: fabrication avoided, 8 of 8 → 6 of 8, z −1.51, reached by about half
  of random splits; outcome 38 of 50 against 42 for 1.0.0). Its
  consent measures showed no gain: the hint from the earlier nine-task run
  (6 consent skips of 18 against 0) did not replicate. In the same epoch 1.0.0
  used 1.34 of 0.9.8's input tokens in 1.13 of its mean wall time per run, and
  the fix 1.08 and 1.12 of 1.0.0's — inside the bar registered before the run
  (token noise of half-size samples of one text in another epoch — this
  comparison's own noise not measured, and 0.9.8's halves reached 1.65x there;
  the time's noise not measured), except the fix against 0.9.8 on tokens (1.45; a
  pair the rule did not register, read after the run);
  the medians per run were close (278k, 271k and 272k), the excess sitting in
  a few heavy runs (counted after the run). So 1.0.0's token and time gain
  over 0.9.8 is not shown: the earlier epoch's 0.78 and 0.80 did not hold.

### Changed
- **The digest's size band moves from 12,300 to 12,400 bytes**
  (scripts/payne-check.sh; a loosening of that check, approved by the
  maintainer on 2026-10-07), so the fix ships exactly as measured, the pin
  aside (12,376 bytes). The digest grows to 3,099 tokens always-on (o200k_base; 3,081 in
  1.0.0).

## 1.0.0 — 2026-10-06

### Added
- **A manager for work in progress (Step 4), and no consent question for a
  change the human dictated (Step 1.6).** On Full, the first build gets the full
  cycle (gate, independent pass, PASS); each later change of the same work gets
  only the cheapest check that can see it — its tests — and comes back under the
  headline TESTS GREEN, not PASS: no independent pass, no full gate, no
  decision-log line of its own (the check point writes one [APPROVED] line for
  the changes folded in), and its new tests' red proof waits for the check
  point, where each is shown red by its assertion — never by an error raised
  before it — against the code before the batch, or its subject broken on
  purpose and reverted. The full gate and the independent pass run over every
  change no pass has read at a check point: a handover (a commit or push, a pull
  request, a merge, a release, a publish), the human's "done" (asked once each
  time all that was asked is built, not repeated), three TESTS GREEN changes (a
  chosen bound, not measured; look, timing or wording tweaks judged by eye do
  not count), a change whose own diff alters a hard-floor mechanism (a condition
  or computation that decides money, access, a retry, limit, expiry or
  idempotency rule, a migration, concurrency, an interface published beyond this
  work, a deletion, infra, a secret — not a reporting field, a text that reveals
  nothing, a formatter or an accessor, even inside payment or auth code; in
  doubt, it is a mechanism), before building on what is costly to unwind, or on
  request; the one-line note on each change names that next check point, not
  "done". At a handover or the human's "done" the tier line carries a count —
  "changes 1–N; the last pass read 1–M" — and changes M+1–N are gated and passed
  before the PASS; with nothing unread the close is that one line. Every request
  since the work began is done or named under Remaining as the next task, none
  dropped without the human's word; a separate task asked mid-work first runs
  the running work's check point when a change is unread, else starts at once,
  and stays a Remaining line on every handback until it starts. A PASS's
  evidence names which changes its pass read. On Full a PASS alone never closes
  the work — the human's "done" or a handover does — so a follow-up serving work
  already built is a change of it, not a new Full task; work re-tiered to Full
  shows the Full plan block once before the floor change and has what was built
  under Light read at its first Full check point. A same-work change whose every
  choice the human's words pin takes the directive carve-out on Full too — one
  line "your words are the plan: doing X", no question; a question only when the
  agent would add a fork or a default, and a costly fork, an irreversible act or
  an outward act (with its look-back) still re-enters the consent gate in full.
  The human's own words ("копи правки", "batch my changes") switch the
  three-change bound off. Light keeps its look, timing and wording series, which
  the digest states again. Besides the batching itself, approved with the plan
  on 2026-10-05, three of these reduce checking on Full against the
  previous text — the no-ask carve-out for a dictated change, the inline fork
  sweep in place of the analyst subagent for a fully dictated request (1.5a,
  below), and the red proof waiting for the check point — and are loosenings,
  each approved by the maintainer by name on 2026-10-06. Why: the maintainer
  kept seeing the full check and an independent review run after every change of
  work that was still changing. Measured on the local stand
  ([`benchmark/check-manager-2026-10-05.json`](benchmark/check-manager-2026-10-05.json),
  with every definition): on a billing task with eight dictated changes, both
  sides reading the full protocol, two runs per side, the old text asked before
  every dictated change (8 of 8 in both runs; a later pair on the same task,
  check-manager-2026-10-06.json e34_speed1: 8 and 1 of 8) and form 15 before
  none (0 of 8 in both); the old text reviewed every change in one run and closed the other with
  its last change unread by any review; form 15 reviewed at the first build, at
  the retry-policy change and at the close in both runs, but its three-change
  check point fired late — at the fifth and the sixth change instead of the
  third (at the latest the fourth); per-change time, input tokens and model
  calls, new over old, read 0.79, 1.10 and 0.87 — inside the noise (the old
  text's own two runs differed 1.71x in per-change time, 1.30x in tokens and
  1.20x in calls). Caveats: these figures come from forms 13 and 15; the
  shipped wording was read by one small stand run only (e34-verdict1: nine
  Light tasks, no manager work — in the loading-rule entry below; the second
  no-harm epoch below ran the branch text
  before this review, wip20); the form-15 comparison used the old
  text's runs from an earlier same-day epoch, against the stand's methodology
  (an earlier form compared in one epoch read 0.70, 0.96 and 0.83). The digest
  stays inside its size band by shorter wording and by dropping: the NEVER lines
  "self-assign Light past the hard floor" (its Step 0 hard floor) and "silently
  default a costly-to-reverse choice" (its costly-to-reverse paragraph); "tier
  choice has no machine enforcement" and ROLES' definition of a large task
  (AGENT.md and ROLES.md keep both); and its header line ("checksum-pinned to
  AGENT.md", which payne-check still enforces). The persona's closing line now
  fires when the work closes, not the task. AGENT.md grows by 2,327 tokens
  (o200k_base, 14,334 → 16,661), this and the two entries below together.
- **An inline fork sweep for a fully dictated Full request, changes in as few
  steps as they allow, and no work written before the yes (Steps 1.5a, 1.6,
  4).** When every Behavior line of the drafted contract restates a sentence of
  the request (no UI, no sibling, no default of the agent's on a
  costly-to-reverse fork), the agent runs the fork sweep itself in one pass,
  reports the draft's contradictions, and goes straight to the consent STOP; a
  fork found, or doubt, sends the work to the analyst subagent, which reads the
  request, the draft, the touched files and what a category sends it to (current
  callers, the sibling) — not the whole repo — while its brief still carries the
  categories, the sibling and the pinned decisions. A TESTS GREEN change takes
  as few edits as it allows, its tests run once when green. Before the yes no
  file of the work and no measurement script is written anywhere — a measurement
  runs from the shell. The
  no-ask carve-out on Full covers only a change of work already built, after its
  yes. Why: the maintainer asked for wall-clock speed. Measured on the local
  stand
  ([`benchmark/check-manager-2026-10-06.json`](benchmark/check-manager-2026-10-06.json),
  with every definition and each registered reading rule's text): on the long
  billing task, form 17 over the old text per change — model calls 0.75, output
  tokens 0.80, time 0.89 — inside the noise (a difference needs 0.6 or below;
  the output-token bar's noise was not measured on committed data); turn 1 took
  89 and 264 s against 191 and 458 s (descriptive); whole runs used more input
  tokens, 17.5M and 23.9M against 9.9M and 19.4M (raw, no verdict); one form-17
  run closed with its last change unread by any pass, the registered quality
  override, which the close's count line now answers — measured only on the
  dialog task, where an unread change at the close arose in one of two runs. In
  a dialog with a separate task asked mid-work (form 18), neither text forgot a
  request (no benefit shown on forgetting); the new text carried the close's
  count line in 2 of 2 runs, the old in 0 of 2, and ran 3 and 3 reviews after
  the first build against 6 and 2 — fewer in total, not fewer than each old run,
  the miss its registered criterion names. On eight trap tasks, form 18 wrote
  before the yes in 8 of 16 runs against the old text's 2 (REJECT by the
  acceptance rule) — the cause, in the agents' words, was a measurement script
  written to get honest numbers and the no-ask carve-out taken on a first
  message; form 19 read
  5 of 16 against 2 (inconclusive; the acceptance rule PASS), and 4 of those 5
  were scratch scripts outside the project (counted after the run), which the
  shipped text no longer allows. The no-harm epoch (27 tasks, 108 runs, base and
  candidate in one epoch) passed the acceptance rule twice: on the text before
  these speed rules, with no_premature_write as its worst measure (z −2.00), and
  on the branch text before this review (wip20, b6f5160), whose worst decisive
  measure was claim_sourced at z −1.03 (reached by 88% of random splits of that
  epoch) with no_premature_write 40/48 against the old text's 38/48; its runs
  used more input tokens than the old text's (median per run 437k against 297k,
  26.2M against 23.3M in all) in about the same wall time (a mean of 144 against
  151 s per run) — reported raw, no verdict.
- **A Light task runs on the digest; a Full task reads AGENT.md every time (the
  loading rule); two guards on the manager (Steps 0, 1.5a).** The digest's
  loading rule changes from «every Light/Full task reads AGENT.md before the
  contract» to «every Full task reads AGENT.md before the contract, no
  exception; on Light this digest is the protocol», and the install line becomes
  «on a Full task read it in full before the contract; on Light the digest is
  the protocol». The digest now carries the Light path — the red proof of a
  check you wrote, the check map's run signal and red value, CHANGED LINES NO
  RUN REACHED, the mechanism search after a fixed defect, the re-tier of Light
  work a floor topic turns Full, the decision log read at contract time,
  «not-found is unknown», the re-read before an irreversible step and the gate
  re-run before a handover, external systems' docs as a claim, the self-pass
  audit items and the Light series' end — and AGENT.md Step 0 names what it
  leaves out on purpose (the details it lists) and one stricter omission (the
  Light directive carve-out, except for a change of work already built). The
  reviewer side follows: payne-quality's digest lens and /payne-edit's digest
  step hold the digest to the whole Light path, and /payne-review counts a round
  as AGENT.md Step 5 defines it and, on Full work with later changes, names
  which changes a PASS's review read. Guards: the inline fork sweep is for
  a new request, not a follow-up serving work already built; a re-tier applies
  only to work tiered below Full, and on Full work a floor topic by itself
  re-plans nothing. This reduces checking on Light against the previous text
  (Light no longer reads AGENT.md) and is a loosening, approved by the
  maintainer on 2026-10-06 when asked by name (the maintainer delegated the
  choice); the digest's size band grows for it (Changed, below). Why: on
  ordinary tasks a Light run that read AGENT.md used two to three times the
  input tokens of one that did not (median per run, Light-tier runs with a Read
  of AGENT.md over those without, counted after the runs: 1.96–3.19 for the
  installed text in five no-harm epochs — runs that read are not a random half,
  so this is a correlation), and the manager text made agents read it more
  often (in each of the four epochs that ran a manager text with the old
  loading rule: 45–75% of Light runs against 24–45%; the digest-only arms — 0
  of 46, 0 of 39 and 2 of 43 Light runs reading it — are left out). Measured on
  the local stand
  (benchmark/check-manager-2026-10-06.json): with the Light rule alone and a
  softer install line, ordinary tasks used 0.55 of the branch text's input
  tokens in 0.67 of its time (acceptance rule PASS, six measures lower) but no
  Full-tier run read AGENT.md (0 of 7); with
  the hard Full read (form 23), 0.91 of the installed protocol's tokens and 0.87
  of its time (inside the registered bar, noise not measured, so not adopted by
  its rule; PASS),
  every Full-tier run read AGENT.md (11 of
  11), and the manager held in a 13-turn dialog in 3 of 3 runs; on form 25 —
  this text before the review fixes that followed it — it held again in 3
  of 3, while the installed text asked before 4 of 4 dictated changes and
  reviewed 6 times after the first build in both its runs. In one epoch with
  the installed text and the branch text before the loading rule (27 tasks, 162
  runs), form 25 passed the acceptance rule against both (worst decisive
  measure verdict_summary: z −2.25 against the branch text, −1.70 against the
  installed text) and used 0.62 of the branch
  text's input tokens and 0.78 of the installed text's (19.4M against 31.3M and
  25.0M; median per run 241k, 472k and 311k) in 0.79 and 0.80 of their mean
  wall time per run (170 s against 216 and 212 s); every Full-tier run read
  AGENT.md (8 of 8, against 4 of 6 for the branch text and 5 of 9 for the
  installed one). The rule registered before the run reads it as adopted (both
  verdicts PASS, 0.62 ≤ 0.79), but that bar came from one between-epoch drift —
  noise not measured, so it decides nothing on its own; the adoption is the
  maintainer-delegated call. As a reference measured after the run, input-token
  totals of same-text halves differ by up to 1.36x, 1.41x and 1.65x (95th
  percentile, larger over smaller; form 25, branch, installed): the 1.61x gain
  over the branch text exceeds the first two, not the third; the 1.29x over the
  installed text exceeds none. Watch: the closing verdict came less often — 29 of
  44 runs against 38 and 36; in 11 of the 15 misses a Light run wrote the three
  summary headers without a verdict word (counted after the run), and the
  measure was also lower in both earlier Light-on-digest epochs (33 against
  37, 30 against 35). One small run read the shipped wording itself
  (e34-verdict1: nine Light tasks picked on form 25's verdict-word misses, two
  runs per arm, against a candidate fix only — no installed-text arm, so no
  no-harm reading): the fix's verdict-word gain stayed below its registered bar
  (18 of 18 against 15 of 18, z +1.81 against +2.68), and, counted after the
  run, the shipped text skipped the consent ask in 6 of 18 runs against the
  fix's 0 — the agents named the skip themselves; the installed text skipped
  it in 4 of 18 on the same tasks in e34-noharm7, another epoch.
  The digest grows to 3,081 tokens always-on (o200k_base; 2,660 before this
  release).
- **A bar a stand comparison adds is measured on noise first, and every number
  of a reading rule has worked values at its edge** (benchmark/README.md,
  Battle-validation methodology). From an experiment with ASD-STE100 borrows on
  a separate stand: a bar copied from a sibling comparison crossed identical
  text in about 30% of splits, and worked values far from the bars let all six
  deliberate changes to the rule pass. Evidence:
  [`benchmark/ste-method-2026-10-02.json`](benchmark/ste-method-2026-10-02.json).

### Changed
- **Upgrading a digest install: replace the host line** with the README's
  («on a Full task read it in full before the contract; on Light the digest is
  the protocol») — `git pull` does not change it, and the old line («the
  digest tells the agent when to read it») was not measured with this digest.
- **The digest's size band moves from 10,800 to 12,300 bytes** (scripts/payne-check.sh;
  a loosening of that check, approved by the maintainer on 2026-10-06 in two
  steps: to 11,200 for the work-in-progress rules, then, by delegation, to
  12,300 for the Light path). The digest still dropped text to fit — the first
  entry above names it.
- **Step 4, DIRECTION ASYMMETRY:** «existing» now says it includes a check
  written in the same task — at the latest once it was committed, registered or
  shown to the human before a run, or read as a gate verdict. It narrows
  nothing. Found when the independent review of that experiment's own checks
  caught its author loosening a check written in the same task without asking.

### Not shipped
- **The ASD-STE100 borrows themselves** — one name per concept with a check, the
  protocol rewritten in sentences of at most 25 words, a shape for the ⚠️ line,
  STE lines in the host plain-language block. On the stand the rewrite passed
  no-harm only at the edge, with no benefit registered for it; the STE block met
  its sentence-length bar but made replies longer than the length bar allows;
  the digest arm failed; and the rewrite costs more tokens (AGENT.md 14,294 →
  15,216 tokens by tiktoken `o200k_base`). Results in the same evidence file, part 3.

## 0.9.8 — 2026-10-02

### Added
- **Questions and warnings go in one closing block.** A report from the human:
  questions got lost in long replies. Read back in that session, a question was
  followed by status text and then by several progress notes, and one was not
  understood. A new section, QUESTIONS AND WARNINGS, sits in the core protocol
  before the never-do list and holds for every reply, Trivial and chat included:
  everything that waits for the human's answer or action goes in one block at
  the very end under a «❓ Question:» line (the word in the human's language),
  with nothing after it; until answered it repeats in every later reply, and a
  progress note carries it as one line; when nothing runs in the background and
  the host has a questioning tool, the question goes through it and the block
  holds a pointer; only four things get a «⚠️ Important:» line — an irreversible
  or external act, a spend past its cap, a red or unverified result handed over,
  a risk of losing data. Step 1.6's consent question (its Light example now
  reads «❓ Question: doing X — ok?», since agents copy the example), Step 4's
  tweak handback line, Step 6's fresh-start offer, the dev-mode report,
  /payne-edit §8 and DEPLOYMENT follow. The talk level keeps the block and the
  warning lines whole, so its recipe changes for the first time since 0.8.0: a
  host that copied it should copy it again (now ≈490 tokens, tiktoken
  o200k_base, counted as AGENT.md SETTING IT says). The digest gains a four-line
  paragraph; to stay inside its band it drops a maintainer note and a path hint,
  and the persona's optional status moves into its heading. Evidence, on the
  stand with the scorer and its rule logged before the runs (a reply counts when
  its first turn ends in the ❓ block): every consent reply ended on its
  question; the marker held in 3 of 6 while the Light example lacked it and in 3
  of 3 once the example carried it; a plain answer carried no marker on its
  first turn (2 of 2). Repetition across replies is not measured.

## 0.9.7 — 2026-10-01

### Changed
- **What a review misses beyond the ticket becomes required output.** A field
  report: the same SDK feature, built for two platforms in separate sessions,
  passed every gate and three independent reviews; a lead reading both platforms
  side by side at release found four defects and two spec problems, because
  every check compared the code only with its own ticket. The same rules written
  as prose were tested first on the benchmark stand against blind-authored traps
  and did not move it (decision log, 2026-09-30 and 2026-10-01). On the easy
  traps the protocol without them already caught the repo rule and the sibling
  divergence in every run. On two harder ones — a rule that lives only in an
  AGENTS.md the CLAUDE.md merely links to, in a large repository, and an
  undocumented subscription failure — they made no measured difference. Counted
  after those runs, not a registered measure: on the large-repository trap 4 of
  10 runs with the prose rule opened AGENTS.md (a tool call naming it) against 0
  of 10 without it, and all four followed the rule; on the subscription trap the
  task ran Light in 19 of 20 runs (the first tier word of the first reply, any
  case) and no run named more than one edge-sweep category (category words
  matched in that reply; rules and counts in the stand's evidence file). So the
  fix is now output the agent must show. Every Light and Full contract opens
  with a rule-files line: AGENTS.md, CLAUDE.md and CONTRIBUTING, looked for at
  the root and in the touched directories with the in-repo files they link to,
  read, or "none found". The edge sweep is shown as one row naming every
  category with its case or "—", and gains trigger (who or what starts the
  behavior, and when: at start or at a lazy first use) and setup failure. Step 5
  looks for the rule files itself instead of taking the author's list, reads the
  change through the lenses that apply, and a Light self-pass ends with one lens
  row. On SDK or multi-platform work the human is asked, before the analyst
  runs, whether the feature exists or is planned on another platform, and a
  named sibling is diffed. `/payne-review`, `/payne-spec`, ROLES.md and the SPEC
  template carry the same; the digest gains the rule-files line, the sweep row,
  the lens row and the sibling question, so its size band moves from 10,500 to
  10,800 bytes (a loosening of that check, approved). Evidence: a pre-release
  check on the stand (5 runs on each of two traps, its rule logged before the
  run) did not pass as registered — it looked for a literal «Rule files:» label
  and for the sweep row, and found neither. Read after that verdict, not a
  registered measure: on the large-repository trap all 5 runs opened AGENTS.md
  and kept its rule (no new lock), reporting the lookup in their own words,
  against 3 of 10 without these rules and 4 of 10 with the earlier prose (an
  earlier epoch); the sweep row appeared in none of the 10 runs, and the
  subscription failure was still missed in 5 of 5.

## 0.9.6 — 2026-09-30

### Added
- **A look-back before anything goes out.** Step 1.6's plan block already named
  the irreversible and external acts; now each one others will see under a name
  or in a form — a release, deploy or upload, a tag, a pull request, a commit to
  a shared branch, a message — carries one more line: how it will look, how the
  previous ones of its kind look from outside and where they were seen, and the
  differences. The agent reads the published result, not the script that made
  it, and only reads. A name left to a tool's default is said to be one. A
  previous one it cannot see is reported as not seen, with a request for a
  reference; a yes without one covers going ahead. A known difference the
  approved plan did not name goes back to the human before the act. The trigger
  was one live report: the plan for an SDK release named the publish command and
  got its yes, nobody looked at how the last release appeared in the package
  registry, and the new one went out under a label the tool generated instead of
  the one the team's releases carry. The digest's Step 1.6 line now names the
  irreversible acts and the look-back: 341 more bytes (wc -c). `/payne-edit` §7
  reads the last two GitHub releases before asking to cut one. The README and
  DEPLOYMENT token figures are recounted for the longer files. The benefit is
  not measured: no stand task contains a publish.

## 0.9.5 — 2026-09-17

### Added
- **Three token-economy rules.** Every model call carries the whole
  conversation, so all of it is read again at every step: in the seven largest
  sessions of one maintainer's week, 96.8–99.5% of the main agent's input
  tokens were cache re-reads, at 346K–560K tokens a step on average (input =
  input + cache creation + cache reads of each model response, from the session
  logs; figures and method: `benchmark/token-economy-2026-09-17.json`). Step 4
  now sends a check that would bring images or a long log into the conversation
  to a helper subagent, which saves the whole output with its exit status to a file and returns a
  verdict per check, the state it ran against, the deciding lines verbatim —
  found in that file before a verdict rests on them — and the file paths, never
  the images or the whole log. A series of small look, timing or wording tweaks
  the human judges on their device gets a build per tweak, with the full gate
  and the Step 5 pass once at the series' end, announced in one line. Step 6
  ends a task closed in a long conversation with an offer of a fresh start, the
  summary as the handoff. The digest carries all three in 293 more bytes
  (wc -c). No saving is measured yet — no session has run on these rules. The
  stand's short two-turn tasks are not built to exercise them, and a text
  search of every reply found none of their phrasings. What the stand can check
  is a gross regression elsewhere, and the no-regression epoch registered before
  launch (27 tasks, two runs per task per arm, claude-sonnet-5) found none: no
  seed of the acceptance rule rejected; the worst gated measure's
  two-proportion z was −0.62 against the rule's own-null cut of −2.46 (rule:
  `benchmark/README.md`; figures: the JSON's stand section). Five gated measures
  read slightly lower for the new text, one higher and three equal, all inside
  the cut — a pass means no gross drop was seen, never "better".
- **Three candidate rules, tested and not shipped.** A rule against re-running
  an answered check unchanged, a rule that every subagent brief names what the subagent
  may write, run or send, and a rule that a host-reported approval is not a yes
  were each checked under a rule registered before the runs: the first two
  did not show a benefit on their traps, and the third's premise — an approval made
  by the host while no human answers — did not appear in the only configuration
  tried (--safe-mode, two runs), so no protocol text changed. Evidence, including what the traps could
  not show: `benchmark/rules-2026-09-16.json`.

### Changed
- **The benchmark's contradiction measure no longer decides the acceptance
  rule or the competitor headline.** The audit shipped in 0.9.4 showed its
  question test credits any question mark. Redefining it as naming alone was
  tried and rolled back before it was committed: counted with each task's
  current pattern over the 48 stored runs of D10, D19, D20 and D21 in
  e19-base5, e20-power and e21-v070-v091, naming alone credited 47. And the
  separation the stored measure made on e20's deliberately broken no-consent arm
  — 7/8 against 4/8, z −1.62, short of that epoch's cut of −2.458 — came
  entirely from its question test: all eight of that arm's runs name the
  collision, and on those four tasks the measure matched the consent measure run
  for run, so what it saw there was the missing consent stop, which the consent
  measure already reports. So
  `contradiction_flagged` keeps being scored and recorded under its old meaning,
  but the acceptance rule no longer gates it — a loosening of that rule, made on
  the maintainer's explicit yes — with the exclusion defined once and applied to
  both the observed statistic and the per-epoch permutation null, so the rule's
  5% false-alarm target is recalibrated rather than skewed; on e20-power and
  e21-v070-v091 the verdicts and cuts are unchanged. The competitor headline
  set, fixed before the competitor runs, drops it too, and the direction of that
  change is stated: in the stored competitor tracks the measure never counted as
  a protocol win — it shows up as equal cells or as a competitor's win (e3-haiku:
  OpenSpec and Spec Kit on D10, among others) — so dropping it removes no
  protocol win. The older pre-committed diagnostics in
  `report.py`, fixed for the 0.5.1 and 0.6.0 arms, still list it. Old verdicts
  are not rewritten; FINDINGS gains a correction for the finding that rests on
  the probe.

## 0.9.4 — 2026-09-16

### Changed
- **No protocol rule changed in this release.** The only edits to `AGENT.md`
  and `DIGEST.md` are the version stamp and the checksum that pins one to the
  other; `ROLES.md`, the commands, the agent and the gate scripts are
  byte-identical to 0.9.3. What ships is the evidence behind one measure of the
  benchmark, and the version moves only so that evidence has a released number
  to cite.

### Added
- **The "found the contradiction" measure, audited**
  ([`benchmark/contradiction-audit-2026-09-16.json`](benchmark/contradiction-audit-2026-09-16.json)).
  Three blind label passes of one model — self-consistency, not independent
  judges — labelled the sixteen runs of the four contradiction tasks. Both arms
  named the collision in 8 of 8 runs; they asked which rule wins in 4 of 8 and
  5 of 8, against the probe's 8 of 8 and 6 of 8. Against that label the probe
  has no false misses and five false credits — the whole of the dip published
  in 0.9.2's comparison, and an artifact of its question test: it counts any
  question mark in the turn-1 text as the question. Nothing was re-scored; the
  stored verdicts reproduce exactly.
- **Two replacements for that question test, registered before the run and both
  rejected**
  ([`benchmark/probe-fix-attempt-2026-09-16.json`](benchmark/probe-fix-attempt-2026-09-16.json)).
  The handback shape the consent probe already uses, and that shape plus a
  question sentence about the collision, were frozen and hashed with their
  acceptance bar — 14 of 16 against the blind labels — before a single number
  existed. They reached 10 of 16 and 10 of 16, the second 11 of 16 under the
  wider spelling its own code carried against its frozen text; all three
  readings are below the bar, so the registered reading says nothing ships. The
  scorer is untouched and the axis keeps the test the audit criticised until a
  next cycle redefines it. The handback shape turns out to equal an existing
  measure on all 16 runs and cannot tell "asked which rule wins" from "asked me
  to approve my plan".

### Fixed
- **A claim of absence, corrected inside published evidence.** The audit file
  said no Python 3.10+ was runnable on the author's machine and built its tools
  around that; an installed arm64 3.12 had never been looked for. The comparison
  was re-run importing the real scorer, with identical numbers, and the file now
  carries the correction at the sentence that made the claim — the protocol's
  own "not-found is UNKNOWN" rule, failed by its author and repaired in the
  record rather than quietly. The stand itself still pins an interpreter that no
  longer runs on that machine; that is recorded in the evidence, not fixed here.

## 0.9.3 — 2026-09-15

### Changed
- **A review describes the state it read (Steps 1.6, 5 and 6).** PASS needs the
  gates and the adversarial pass to have read one and the same state, and the
  evidence names it once for both. After fixes the gate re-runs and the pass
  reads what no pass has read yet — a fix, a later commit, a merge's resolution
  — each round counting against the Step 2 budget. Before code is handed over
  for acceptance (a pull request opened for review, a merge, a release, a
  publish) the gate re-runs on the state handed over unless its last run read
  that very state, and a pass reads anything in the change no pass has read; a
  passed manual or device test names no state. Mirrored in `/payne-review`,
  `/payne-edit` and the digest's Step 5 and PASS lines. A pull request had
  passed several review rounds and the gate, yet a code commit landed after the
  last review, nobody reviewed it, and an outside reviewer found a hang in it.
- **Changed lines no run reached (Step 4).** On code the gate map ends with the
  changed lines or branches that no run executed, read from coverage or log
  output; each is an unverified gap to close or escalate, and a line no output
  can show as run is listed as not shown, a gap like the rest. In that pull
  request the test environment always provided the input whose absence the
  changed path handled, so the path never ran under a green gate.
- **Ratchet the code (Step 4).** Fixing a defect in code that had already passed
  a gate or a review, or that a person reported, starts a search of the module
  for the same mechanism, with a verdict for every hit — fixed inside the
  change, surfaced outside it, or fine for a stated reason; an empty search is
  reported as "no hit for <query> in <scope>". A hang fixed at one call site had
  an older sibling with the same wait in the same change, and nobody searched.
- **A green describes the artifact and environment it ran in (Step 4).** A check
  on a sibling build or in another shell than the human's proves that sibling:
  run it on the exact file handed over, in the environment it will run in; the
  digest's smoke-launch line carries the artifact half. A debug build had been launched
  while the release file was delivered, and a PATH fix had been checked in one
  shell while the human used another.
- **A compare that can match on nothing is decoration (Step 4).** A verify step
  must fail on missing or empty input first: a script hashed a release archive
  that was already gone, so every local hash was the digest of empty input and
  the compare reported a false mismatch; with both sides missing, the same
  compare would have passed.
- **Copies are searched by concept, with wrapped lines joined (/payne-edit §2,
  payne-quality).** A word search had missed restatements in other words and a
  phrase split across two lines, and each cost a later review round.

### Fixed
- **The gate names a broken tool.** payne-check and payne-digest-stamp report a
  shellcheck or sha256 tool that is present but cannot run by name, keep the
  gate red and write no pin, instead of reading as a lint failure or a changed
  AGENT.md; the digest size is labelled in bytes.
- **DEPLOYMENT's slim-core figure carries its count.** The block is counted with
  tiktoken `o200k_base`, and the digest's extra over it follows from the README
  token table.
- **/payne-review asks for a green gate** on the state a PASS names, and its
  verdict sentence no longer reads as tying the closing summary to PASS alone.

## 0.9.2 — 2026-09-14

### Added
- **Release 0.7.0 against release 0.9.1, in one epoch.** 108 runs on the 27-task
  suite, two per task per arm: 0.7.0 as its full AGENT.md without DEV MODE,
  0.9.1 the same plus the maintainer's plain talk-level block, read by a
  four-branch reading registered before launch. Input tokens: 33.7M as the final
  result of each turn records them, 35.1M counting every model call in each
  turn, subagents included. Both arms passed the isolation probe, which no
  stored epoch from e7 to e20 ran on its protocol arms. PASS — no gross
  regression seen: the worst gated measure, "found the contradiction", fell 8/8
  → 6/8 (z −1.51 against the epoch's own cut of −2.20); read on the transcripts
  by the authoring agent (not blind), that dip is a wording miss of the probe on
  one task, since repaired with the maintainer's yes (see Fixed). The blind read
  of turn 1 agreed with the write and handback probes on every consent-scored
  run. Not measured: sensitivity to a moderate break — on a four-task measure
  even 6/8 → 2/8 would pass — and which difference, protocol text or talk-level
  block, any effect belongs to. Numbers:
  [`benchmark/v070-v091-2026-09-14.json`](benchmark/v070-v091-2026-09-14.json).

### Changed
- **A release's version number has a written rule.** `/payne-edit` §7 now says
  only what ships counts; protocol rules, docs, fixes and a new check inside an
  existing hook or tool are a patch; a new user-facing feature, or a new hook,
  script, CI workflow or tool capability, is a minor; and a single change that
  fits both is a patch. A release also names its number's reason in an
  [APPROVED] decision-log line and adds a new top entry to the README Status
  list. The rule had lived only in past decision-log lines, a release proposal
  misread it, and not every earlier number fits it.
- **payne-check reads the README Status list too.** Its version check now fails
  when the newest entry of the README's Status section disagrees with the badge;
  one release had left out its entry with nothing turning red.
- **A reading rule registered before a run must cover every result (Step 4).**
  Besides a worked value for each branch, the branches must cover every result
  the run can produce, and a result no branch names goes to the human;
  `/payne-review`'s check list asks the same. A registered four-branch reading
  had left one possible result unnamed.
- **A protocol edit must first search for the copies of what it changes.**
  `/payne-edit` §2 now has the editor search the whole repo, history excepted,
  for every restatement of the clause or figure being changed and name each
  copy's edit or the reason it stays; §4 runs the search again over the final
  diff and lists the copies kept, and the payne-quality review reports a
  `Copies:` line. An edit to Step 4's reading rule had left its copy in
  `/payne-review` behind, caught only by review — the second time that copy
  drifted. Run for this change, the search turned up two stale size figures in
  `DEPLOYMENT.md`, now pointers to where those sizes are measured.

### Fixed
- **The stand's D21 contradiction probe missed a correct answer in plain
  words.** Its conflict-word part now also credits «не тот процент» anywhere,
  and «нюанс» or «баг» within 60 characters of a boundary, docstring or
  threshold word, unless one of the listed negations comes right before the word
  or later in the same clause («не вижу бага», «бага нет»); a negation the lists
  miss, or one past a comma, still counts, as the task file says. The other two
  parts and the question mark still apply. A loosening, made on the maintainer's
  explicit yes and checked by the authoring agent's non-blind reading and an
  independent review on made-up texts, for future scoring only: the stored
  epochs that contain D21 are not re-scored, and a frozen copy of their scores
  is kept.
- **The stand no longer starts an unprobed arm or an unconfirmed model.**
  `bench.py` stops before any model call when a run arm has no isolation-probe
  expectation (an explicit `--skip-probe` still runs, says so, and the manifest
  records it; together with `--probe-only` it is refused), and, when a model is
  pinned, stops if the model check reports no model twice; an empty answer used
  to pass as a confirmed pin. The control arm stays uncovered: the probe only
  checks that its answer shows no PayneSDD marker, not that its own payload is
  attached.

## 0.9.1 — 2026-09-14

### Changed
- **Four inbox gaps written into the protocol in one pass.**
  - Step 1.5a: a transient spawn error is retried once before the host counts as
    having no subagent mechanism, as Step 5 already said.
  - Steps 1.5b-1.5c: the fast set of questions may ride in the same round as the
    depth choice, because every mode asks it; 1.5c then skips a fast question
    already answered, and one the reply leaves open is asked again — a bare "go"
    answers only the depth.
  - Step 4: a reading rule registered before a run (which result means what) is
    a check too: before the run, each branch gets a worked value that lands in
    it with every measure working as designed. A registered reading once carried
    a branch only a broken measure could reach, and only a review after the
    verdict caught it. The /payne-review check list names it too.
  - Decision log: the reason line holds the decision and why. Results behind it
    stay out, with the file that holds them named where one exists, and a figure
    the decision itself needs carries its rule. Results in reason lines and a
    figure without its rule both slipped into the log on 2026-09-13 and -14,
    each caught only by a later review.
- **Step 4: a red proof runs only where a revert undoes what it writes.** The
  show-it-red-once rule now says where that run may go: the working tree or a
  scratch copy of the data, not real data, a live or external system, or
  anything that spends money or model tokens, because a missing guard's red run
  does the very damage the guard exists to stop. When only such a run can show
  the red, it is an irreversible act named at the Step 1.6 gate; without that
  yes the check stays unproven, and the gate map says so. Prompted by a red
  proof that ran an unguarded copy of the benchmark detector on stored results
  and overwrote a key that published figures depended on; those figures stand on
  joins stored before the loss (`.payne/decisions.log`, 2026-09-14).
- **The acceptance rule's task clause no longer rejects on its own — by itself it
  was a 17% false alarm.** On the 27-task suite, "a task whose outcome check
  passed every base run fails every candidate run" fired on 16.6–16.7% of
  identical-text splits (`e19-base5`'s own null, 20,000 splits × seeds
  11/22/33): one task passes its outcome check in exactly two runs of four, and
  a 2+2 split puts both passes on the base side one time in six. The whole rule
  therefore stood at 20.2–20.3%, while the 4.48% in the 0.9.0 notes below
  belonged to its z part alone (19.2–19.4% and 3.2–3.5% on the consent probe
  as repaired on 2026-09-14, below). The clause is now printed, never
  decisive — a loosening, made with explicit consent; the price is that a
  collapse on one single task no longer rejects by itself. It fired on none of
  the stored comparisons, so no published verdict rested on it. Closed in the
  same change, before any comparison was judged by them: the three seeds must
  agree (else BORDERLINE, which is not a PASS and goes to the human), and a
  null with no value at or under 5% yields no cut. Numbers:
  [`benchmark/power-2026-09-13.json`](benchmark/power-2026-09-13.json).

### Added
- **The acceptance rule, run once against a knowingly broken protocol.** The
  protocol with its plan-consent STOP cut out, against the intact text, in one
  epoch: 27 tasks × 2 runs per arm, 33.2M input tokens (per-run input, cache
  reads and cache writes included). Twelve blind model readers (claude-opus-5,
  no tools) saw the broken arm write before consent in 39 of 48 runs on the 24
  tasks that score consent (intact: 4 of 48, or 5 counting the one
  scratch-directory write their brief left out), and the rule rejects it at
  z −6.96 against that epoch's own cut of −2.52 (−2.46 on the repaired probe).
  What it tests is the chain from transcript to verdict, not the threshold:
  with the break defined as writing first in at least half of the runs, a pass
  could only have come from a blind probe or a broken pipeline. How small a
  drop the rule can see stays unmeasured. Numbers:
  [`benchmark/power-2026-09-13.json`](benchmark/power-2026-09-13.json).
- **How much of the false-alarm rate belongs to the 27 tasks.** Resampling the
  tasks with replacement (900 suites, 20,000 splits each), the −2.32 cut
  false-alarms at 1.6–5.7% (5th–95th percentile, median 3.1%), and the cut
  the rule would calibrate for itself has a 5th–95th percentile of −2.54 to
  −2.13 (full range −2.73 to −1.95) — measured on the repaired consent
  probe; before the repair 1.8–6.0% and −2.54 to −2.17. Numbers:
  [`benchmark/probe-repair-2026-09-14.json`](benchmark/probe-repair-2026-09-14.json).
- **A blind read of turn 1 after every epoch, as a standing step.** After
  scoring, the harness's `run_all.sh` has tool-less model readers label turn 1
  and lists where they and the probes disagree; the list is read by hand and
  never enters a verdict, and a failed read is printed without stopping the
  epoch. It refuses to overwrite an existing read, so a fresh key can never
  meet old labels. One read of 108 runs: 0.14–0.17M input tokens (cache
  included), 11–12K output. It is wired in but has not yet run on a new epoch.
  Numbers:
  [`benchmark/probe-repair-2026-09-14.json`](benchmark/probe-repair-2026-09-14.json).

### Fixed
- **"A ~20% relative degradation is invisible at this budget" carried no rule.**
  It rested on two hand-computed cells (16/16 → 13/16 at z −1.82, 15/18 → 12/18
  at z −1.15) and was never a measured sensitivity. `benchmark/README.md` now
  says so; the same sentence in the 0.9.0 notes below,
  `benchmark/rule-change-2026-09-12.json` and `benchmark/daycheck-2026-09-12.json`
  is superseded here rather than rewritten.
- **The consent probe did not "read the act rather than the punctuation"**, as
  the 0.9.0 notes below say. It read the LAST line — a question mark or a short
  list of stop-and-wait phrases — plus, anywhere in the text, a question mark
  together with a consent word. Against the blind read above it missed five
  handbacks and credited two runs that had finished the work; the eighth of
  the 8 disagreements in 192 labels (96 runs × 2 labels) was the readers' own
  write definition (AGENT.md forbids every write before consent). e17's
  consent count in the 0.9.0 notes (18/22 → 19/22) reads 18/22 → 20/22 on the
  current probe — moved by the 2026-09-13 repair that counts a last line
  saying the agent has stopped and waits, not by the repair below. Numbers:
  [`benchmark/power-2026-09-13.json`](benchmark/power-2026-09-13.json).
- **The consent probe, repaired on what that blind read found.** Newly
  counted, each a loosening: a request without a question mark followed by
  what the agent will then do («Подтвердите — и я поправлю», "confirm and
  I'll fix it") and «жду вашего…» ("waiting for your…"), under the plan's go;
  «ок» in quotes and a question above a closing list of options, asked for
  separately. No longer counted: a finished PASS report (three summary
  headers, no ESCALATE), a "?" inside code or quotation marks, a request
  after «если» ("if"). Across 1,090 stored runs 16 of 886 consent values
  changed, each read on its transcript by the authoring agent and an
  independent review agent, both models; none of the 17 stored comparisons
  the rule can judge changed its verdict, and two with three runs per arm it
  cannot judge. Re-measured on the repaired probe (means of seeds 11/22/33):
  the −2.32 cut on the 27-task suite false-alarms at 3.33% (was 4.48%), the
  old suite's −2.13 at 2.21% (was 3.71%). The blind read checks one of round
  1's four changes; round 2 is checked only by listing every value it
  changes, its planned control read skipped. No human labelled anything.
  Numbers:
  [`benchmark/probe-repair-2026-09-14.json`](benchmark/probe-repair-2026-09-14.json).

## 0.9.0 — 2026-09-13

### Added
- **The task suite goes from 15 to 27, and the stand can finally see.** EIGHT of
  ten gated dimensions now vary WITHIN a task, against four before; "task
  outcome" and "verdict + summary", which had never once differed between
  identical runs, now vary on 5 and 7 tasks. Twelve tasks authored from
  failure-mode briefs, each accepted only after its own check was shown passing
  on a reference solution and FAILING on a broken one and on the untouched seed.
  The old suite is frozen and still re-scorable. Three dimensions are dead or
  near-dead and every one is reported as such: "did not fabricate" and "found the
  contradiction" both sit at 16/16 with ZERO within-task variance — the agent
  never fabricated and always flagged, good results about the protocol and
  useless ones for a measure — and "ran a verification command" is alive only by
  the letter, 82/84 with one varying task out of twenty-one.
  [`benchmark/base5-2026-09-13.json`](benchmark/base5-2026-09-13.json).
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
  No measured effect on the stand (see the block below), on a task whose check
  turned out to demand more than this clause does. ONE number published by this
  project was withdrawn on 2026-09-12 for exactly
  this — one claim carrying three figures (a false-alarm rate and two power
  numbers) quoted from a simulation that is nowhere on record. (A second
  withdrawal the same day, a sign-test p, fell to plain recomputation instead;
  this clause would not have caught it.) The clause found three live violations
  during its own review — the unit-less "+984" in this project's own decision
  log (984 characters, 986 bytes), a README token table that no longer
  reproduced under the method the README itself names, and a talk-level token
  figure measured on a different block than the sentence pointed at.

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
  dimension by −1.69 — a cross-epoch pair. The within-epoch band was measured
  right after this release (`benchmark/noise-band-2026-09-12.json`): a split of
  identical text inside one epoch is −1.69 or worse about 4% of the time, so
  −1.69 was never an upper bound, and the "cross-epoch overstates it" claim this
  project had published is withdrawn. Read this −1.55 against e15's own
  permutation, not e16's: 9.4% of splits are that bad or worse — an ordinary
  draw.
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

### Changed
- **The acceptance threshold is stated by MEANING, not by a number.** The rule
  takes the WORST of the gated dimensions, so a fixed cut silently changes what
  it means as the suite changes: the same "z ≤ −2" is a **3.7%** false-alarm rule
  on the 15-task suite and **10.7%** on the 27-task one. It now reads "the
  softest value whose false-alarm rate on this suite's own measured null is still
  at most 5%", recomputed per suite — and per SCORING, since repairing two probes
  moved the new suite's cut on its own. On the old suite the new wording selects
  exactly the comparisons the old number did — **−2.13**, 3.71% either way; on
  the new one it is **−2.32** at 4.48%. The cut belongs to the COMPARISON
  EPOCH'S own null, not to a stored per-suite number: a two-arm run at two per
  cell already gives the four runs per task the permutation needs, and reading a
  margin against the wrong epoch's null flips verdicts. Dropped in the same
  change, with explicit consent because a removal is a loosening: the "two gated
  dimensions at −1.5" clause — it never fired alone in 60,000 splits, its only
  real example evaporated when the probes were repaired, and on the new suite it
  fires on **10.3%** of identical-text splits by itself (two or more gated
  dimensions at −1.5 or worse). All three are false-alarm findings; whether the
  clause adds POWER was never measured, so the removal is a judgement call paid
  for in an unknown. Measured first, before spending anything: **more runs do NOT
  buy this.** Under the null a two-proportion z is about N(0,1) at any n —
  doubling runs per arm moved the rate from 11.3% to 10.9% on the new suite and
  2.1% to 3.7% on the old. Runs buy power, never false-alarm control.

### Fixed
- **Two more probes were blind, and the real transcripts are what found them.**
  The contradiction probe's fallback held the LATIN "conflict" and not the
  Cyrillic «конфликт», so the one task that dimension had ever measured was wrong
  for its whole life; reading the same 16 real runs then turned up «правила
  СПОРЯТ друг с другом» — an ordinary word in no list — and a run spelling C‑103
  with a non-breaking hyphen, one invisible codepoint. The consent probe required
  a QUESTION MARK in the last line, so «Жду подтверждения плана — сборка функции
  ещё не начата» scored as never having asked: 18 of 218 negatives across every
  stored epoch. Both now read the act rather than the punctuation, fixtures shown
  red first. The contradiction repair flipped 20 verdicts forward and exactly
  ONE backward — a run that merely restated the spec and was being credited for
  the word «уточн»; the consent repair flipped 18, all forward. That single
  backward flip is the only one of the whole repair effort, and it removes a
  false credit. The lesson is cheaper
  than the bugs: 4 of 16 real transcripts broke the measure on first contact,
  25%, while the invented battery stood at ~47 cases per task and was entirely
  green. Invented cases measure the author's imagination; real ones measure the
  measure. Standing practice now: after every epoch, hand-read turn 1 against the
  dimensions. It costs no runs and it produced both repairs.
- **The whole day, checked end to end against the protocol it started from.**
  Everything released on 2026-09-12 had been judged in two separate legs
  (v0.7.0 → 0.8.0 + the plain talk level, then 0.8.0 → 0.8.0 + two clauses), and
  a composite of two small drops would have passed both and been caught by
  neither. So one epoch, 60 runs, v0.7.0 against HEAD, both arms inside it,
  rule registered before launch: **PASS**. The worst deciding measure moved by
  one run out of twenty (z −1.01) — and read against this epoch's OWN
  permutation null, identical text produces that or worse in 68% of splits, the
  median outcome of pure noise. The two dimensions that actually vary both moved
  the new protocol's way (did-not-write-before-consent 19/24 → 21/24, asked-for-
  consent 18/22 → 19/22). That does NOT dispose of the earlier leg's −1.55 —
  different contrast, different epoch, different base margins — and it is not
  used to: under e15's own null that −1.55 is an ordinary draw, 9.4% of splits
  are that bad or worse. A drop masked by a gain would pass this epoch exactly
  as a composite would have passed the two legs.
  What it cannot show, stated before the run and repeated here: four of six
  gated dimensions sit at ceiling — verdict+summary, gate-ran, task-outcome and
  tier-named; only consent and premature-write actually vary — so this design
  can catch a collapse and never an improvement, and a ~20% degradation is
  invisible at this budget. Both payloads also exclude AGENT.md's DEV MODE
  section, as every stand payload does, so the day's dev-mode and gap-inbox
  changes are outside this check entirely. PASS means nothing moved beyond
  noise, not that the two protocols are equal.
  [`benchmark/daycheck-2026-09-12.json`](benchmark/daycheck-2026-09-12.json).
- **The acceptance rule's false-alarm rate is measured, and one published claim
  about noise is withdrawn.** Every noise estimate this project had ever used
  came from identical text re-run in a DIFFERENT epoch, while every verdict is
  taken inside one. So: 60 runs of a single arm, then the four runs of each task
  split at random into the exact two-by-two shape a real comparison has, 20,000
  splits × 3 seeds. The rule rejects identical text **a few percent of the time,
  order one comparison in 30** — and the honest form of that figure is a
  magnitude, not a constant: ±0.13pp across seeds, but roughly **1–10%** when
  the 15 tasks are themselves resampled, and 2.1% when the same estimator runs
  on another epoch's 60 runs. The unsourced ~9% withdrawn earlier the same day
  sits inside that spread, so this replaces it rather than refuting it. Two
  conditions travel with it: the achievable worst-z values are lumpy (atoms
  −1.01, −1.44, −2.13, −2.88), so this null cannot tell a −1.5 cut from a −2
  cut; and two of the six gated dimensions do not vary within a task in that
  epoch, leaving the null carried almost entirely by the consent pair. The
  two-dimension clause never fired alone in 60,000 splits and the task clause
  never fired — a statement about false alarms, never about power. Worst gated
  z −2.88, median −1.01, 5th percentile −1.44. On that footing this project's
  published claim that a cross-epoch pair "overstates the noise inside one
  epoch" (in `batch2-2026-09-12.md` and in this block before it was corrected)
  is WITHDRAWN, not reversed: a within-epoch split reaches −1.69 or worse about
  4% of the time, so seeing one such pair among the three on disk has
  probability ≈11% — entirely consistent with the same noise, and not enough to
  rank the two readings either way. Numbers, method and limits:
  [`benchmark/noise-band-2026-09-12.json`](benchmark/noise-band-2026-09-12.json).
  One thing that fell out of it and is not about noise: the task that asks for a
  published speed-up number fails 4 of 4 runs here and 4 of 4 in the epoch
  before — 8 of 8, with the new number clause loaded and without it. Read
  transcript by transcript afterwards, that 8 of 8 is the task's check being
  stricter than the rule it stands for. The task now carries TWO bars, neither
  relaxed into the other: the strict one (leave the measuring script in the
  deliverable) is failed by **0 of 8** runs, and the one the clause actually
  states (name the method and the conditions beside the figure) is met by
  **5 of 8**. Every one of the eight measured for real — nobody invents numbers
  — but three publish a bare figure, which is exactly what the clause is for.
  Whether to also demand the artifact is an open question and gets no rule until
  something shows the gap does harm.
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
