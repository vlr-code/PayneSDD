# Measured findings — what the benchmark taught us (July 2026)

Plain-language summary of what we learned by running PayneSDD, older PayneSDD
versions, and competing spec-driven protocols (GitHub Spec Kit, OpenSpec, as
verbatim-prompt approximations) through one harness. Methodology and its
pre-committed anti-inflation rules: [README.md](README.md). Key numbers:
[findings-2026-07.json](findings-2026-07.json). Model epochs: one on
claude-sonnet-4-6, three on claude-haiku-4-5. Cells ran n=3–5 — read every
number as a direction, not a decimal.

## 1. The new version really is better — and now that's measured, not felt
v0.6.0 vs v0.5.1 on identical tasks: 7 dimensions improved, 0 regressed.
On the security task v0.6.0 held consent-before-code 3/3 where v0.5.1 went
0/3 — and v0.5.1 shipped one solution that crashed at runtime (its own gate
missed it). The digest also used less context on 7 of 8 tasks.

## 2. Competitors ship prescriptions, not behavior
Spec Kit's templates literally prescribe tests; measured verification stayed
at cheap-prompt level (6/12 runs vs our 11/12 on the sonnet epoch). Across
every protocol-neutral cell of that epoch, neither Spec Kit nor OpenSpec
beat the protocol once. On the blind suite Spec Kit also burned ~1.9× the
tokens of a naked agent; the PayneSDD digest ran ~1.2% over naked-agent cost.

## 3. The persona block is load-bearing
Removing "Joe" (≈240 always-on tokens) halved discipline (aggregate 56 → 28)
at identical task outcomes. The voice is not decoration: on a weak model, the
identity frame carries the rule-following.

## 4. On weak models, discipline is a zero-sum budget
Three experiments, one law. Fatten the digest by 8% — every discipline
metric drops. Cut it by 10% (the persona) — every discipline metric drops.
Sharpen ONE imperative — that gate improves (+8 runs) while its neighbors
sink (−8, −5). You cannot word discipline up on a haiku-class model; you can
only move it around. Scope clarifications are the one safe move: no drop
beyond noise, but tiny gains.

## 5. The real bottleneck is the act of asking (finding + inference)
Measured: a tier-boundary clarification nudged tier awareness up (36→38 of 50
runs named it) while the consent question barely moved (13→14 of 35). Our
inference from that gap: knowing a rule and executing it are different
failures, so on weak models reliable consent/gate enforcement is the
Stop-hook's job — not better prose. (See DEPLOYMENT.md: the digest floor is
validated on Sonnet-class models; below that, import the full AGENT.md or
arm the enforced Stop-hook.)

## 6. Nobody catches latent contradictions
A task whose seed data makes two stated rules collide (a 7-item order vs a
hard 5-per-sheet limit): 0 of 15 runs across five different arms noticed —
including ours, which called the task "trivial, no ambiguities". A blind
spot shared by every arm we tested — and it now has a measuring stick.

## Correction (2026-09-12)

Five of this page's instruments were later found faulty, and the numbers above
are left as they were measured rather than quietly restated. The full second
round is in [`probe-repair-2026-09-12.json`](probe-repair-2026-09-12.json):

- **The "ran a verification command" probe under-counted badly.** It looked for
  the task's own symbol inside the shell command, so a real `python3 -m unittest
  test_x.py` scored as "no gate". On the epochs still on disk, 14 of 16 such
  negatives in one epoch were false (15 of 16 flipped on re-scoring); it now
  sits at ceiling everywhere. The epochs still on disk (e5–e11) were re-scored;
  the July numbers on this page, including `findings-2026-07.json`, cannot be —
  their transcripts are gone. And the bias was arm-correlated, so on this page
  neither the digits nor the arm-to-arm direction of a gate number can be
  trusted: one 2026-09 epoch showed a 5-run gap between two arms that
  disappeared entirely on re-scoring.
- **The count-based acceptance rule fired on identical text.** Re-run against
  themselves, two of the three identical-text pairs on disk tripped the "no
  dimension may drop by 3 or more" bar; the two-proportion z test that replaced
  it on 2026-09-12 tripped on none (`rule-change-2026-09-12.json`,
  `benchmark/README.md`). The report's per-task flip counts are descriptive, not
  a verdict.
- **The "named the tier" probe missed half its own subject.** It was blind to
  `Light tier —`, `(Light)` and `Trivial → Light`, and it read only the agent's
  FIRST text block, so a one-line "let me look at the file" before the tier line
  scored as never naming the tier. Of 154 negatives on disk, 36 flip on the new
  shapes, 48 on the wider window, 1 on both, and 69 were genuinely never named:
  85 verdicts flipped on re-scoring. Neither the digits NOR the arm-to-arm
  direction of a tier number on this page can be trusted — the same standard the
  gate bullet above sets. The flips do not fall evenly: two arms gain none, and
  on `e9-top5` the tier row goes from candidate +2 to candidate −1, a reversal of
  sign. §5's tier figure here is from July, whose transcripts are gone, so no
  re-scoring evidence for it exists at all.
- **The "verdict + closing summary" probe read the last turn, not the run.** A
  run finished inside turn 1, whose turn 2 only says "already done", scored as
  having produced no summary. 50 of 91 negatives were of that kind, and none of
  those 50 wrote new CONTENT in turn 2 — five ran `rm` cleanups, which is exactly
  the distinction the repaired probe draws. A turn-1 summary now counts while
  turn 2 adds no new written work.
- **The "did not write before consent" probe could not tell a redirect from a
  comparison.** It read the `>` in `awk 'NR>1'`, in a `python3 -c "print(1>0)"`
  string and inside a heredoc body as a file write, and — once that was patched
  by demanding whitespace — it stopped seeing `echo hi>out.txt`. It now strips
  heredoc bodies and quoted spans before looking, and counts a file opened for
  writing by a script fed through a heredoc. Nine verdicts. The rest held: of
  179 negatives, 173 were genuine writes of the deliverable before consent.

All 144 flips run in ONE direction, false → true: these probes were blind, not
biased in their calls. One stored verdict changes as a result — the 2026-08
haiku rejection (`e5-cch-borrows`) no longer trips the two-dimension clause.
Every talk-level rejection stands, some with different digits.

## Correction (2026-09-16)

- **Finding 6 rests on the contradiction probe, and that probe no longer
  decides the acceptance rule or the competitor headline.** The "0 of 15" above
  was counted in July by a word-list probe later found blind to how agents
  actually name this collision: it missed all four real runs of this task
  checked in September — two wrote «конфликт», which it lacked (it held only the
  Latin "conflict"), and two «спорят», a word in no list — and repairing
  it on 2026-09-13 flipped 20 stored verdicts from false to true across the
  epochs still on disk. The July transcripts are gone, so the count cannot be
  re-read; it stays as measured, but a zero from a probe with documented misses
  is not evidence that nobody noticed. On a later suite, blind labels (three
  label passes of one model — self-consistency, not independent judges) found
  all sixteen labelled runs naming the collision
  ([`contradiction-audit-2026-09-16.json`](contradiction-audit-2026-09-16.json)).
  The probe is still scored and recorded.

## What this changes for PayneSDD
- Protocol wording changes ship only through the harness: pre-registered
  thresholds, every gated dimension watched. Three of our own candidate edits were
  rejected exactly this way — the harness does not care who wrote the patch.
- The harness itself (tasks, runner, scoring) lives git-ignored in
  `benchmark/local/`; runs are work, not history. This page cites only the
  committed snapshot beside it.

Honesty note: task suites are blind-generated only in PART — an author is briefed on a failure mode and never opens a protocol file, but this host imports DIGEST.md into every subagent's context, so the compressed protocol is loaded before its first command; the 12 tasks added on 2026-09-13 carry `blind_author: "partial"` for that reason, and real blindness needs a `claude -p` subprocess. The harness and probes are
ours; competitor arms are prompt-payload approximations, not native installs;
n is small. Each run report carries a mandatory "what this does NOT measure"
section — this page inherits all of those caveats.
