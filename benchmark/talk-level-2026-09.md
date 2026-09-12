# Talk level — the run that shipped it (2026-09-12)

A committed snapshot of the numbers behind the talk-level setting, so the claim
in the README has something to point at. The machine-readable aggregate sits beside it
(`talk-level-2026-09.json`); raw transcripts stay out of the repo
(`benchmark/README.md` — "raw" = scores and aggregates in git, runs outside it).

## What was measured

Twelve blind tasks (the `tasks4` suite), two runs each, one Sonnet-class model
snapshot, three arms attached as system-prompt payloads:

| arm | payload |
|---|---|
| base | the shipped protocol, unchanged |
| plain | the same protocol + the PLAIN block in the always-loaded config |
| terse | the same protocol + the TERSE block in the always-loaded config — **measured, then dropped before release** (see below) |

Every table below therefore describes three arms while the protocol ships two.
The dev-mode section was stripped from every payload so run agents could not
reach the real gap inbox. Acceptance was pre-registered in the decision log
BEFORE each launch: **no dimension may drop by 3 or more against base, and task
outcomes may not fall below base.**

## Confirmation epoch — 72 runs, 0 indeterminate

| dimension | base | plain | terse |
|---|---|---|---|
| asked for consent | 14/18 | 14/18 | 16/18 |
| wrote nothing before consent | 16/18 | 17/18 | 17/18 |
| named the tier | 18/24 | 20/24 | 18/24 |
| closing summary in shape | 15/16 | 16/16 | 15/16 |
| flagged the planted contradiction | 0/2 | 2/2 | 1/2 |
| refused to fabricate | 1/2 | 2/2 | 2/2 |
| ran a verification command | 16/16 | 16/16 | 15/16 |
| task outcome | 21/22 | 22/22 | 22/22 |

Worst drop for either level: −1 (verification). Both levels PASS.

*The verification row is re-scored: the original run reported 11/16, 10/16 and
10/16 from a probe later found broken (see the correction below).*

## Three cuts failed first — that is the point

The wording did NOT hold on the first try, and the stand is why it shipped at all:

1. **First cut** — the always-loaded block carried the brevity recipe WITHOUT its
   guardrails. Consent-asking fell 15/18 → 6/18 (plain) and 7/18 (terse);
   writing-before-consent fell 16/18 → 9/18 and 6/18. Transcripts showed agents
   skipping the consent STOP and coding straight away. Rejected.
2. **Second cut** — guardrails added to the copied block. Much better (consent
   −4 / −1) but still over the line; the terse level still wrote files early.
   Rejected.
   **Superseded 2026-09-12:** under the rule that replaced the count threshold
   this cut PASSES (worst z −1.45; −1.26 was this page's original figure, from
   a scoring pass superseded twice since) — its rejection was a false alarm.
3. **Third cut** — the tier word pinned to English, the consent question pinned
   to an actual question, and "a level buys no shortcut" spelled out. Terse
   passed. Plain failed on one dimension: it stopped naming the tier (12/24),
   because the recipe said "answer first" while the protocol says "tier line
   first" — two firsts in one text.
4. **Fourth cut** — the recipe pins the tier line first, the answer under it.
   Plain passed (tier 23/24 against base 19/24 in that check), and the
   confirmation epoch above re-ran all three arms from scratch.

A measurement trap worth recording: the adherence probes are regex heuristics
written around the protocol's English vocabulary. Under the shorter levels the
agent wrote "беру уровень Лёгкий (Light)" and "Жду подтверждения, прежде чем
писать код" — correct behavior the probes could not see. The fix went into the
RULE (anchors stay in the protocol's own words), never into the probe after
seeing results.

## How much shorter, and at what cost to quality

Measured on the SAME 72 runs, not on a side experiment. Median words per run,
code blocks excluded:

| | base | plain | terse |
|---|---|---|---|
| turn 1 — the plan and the questions | 146 | 85 (−42%) | 86 (−41%) |
| turn 2 — the work and the closing summary | 122 | 87 (−29%) | 80 (−35%) |
| whole task | 305 | 186 (−39%) | 185 (−39%) |
| mean, whole task | 271 | 177 | 164 |

The pre-registered target was ≤60% of base: 61% on the median for both levels,
65% (plain) and 61% (terse) on the mean — **missed, narrowly**.

**Quality, blind and swapped** — the judge compares the two arms' solution files
against the task spec, positions swapped, disagreement counted as a tie, over
all 12 tasks:

| pair | base better | level better | tie |
|---|---|---|---|
| base vs plain | 2 | 2 | 8 |
| base vs terse | 1 | 2 | 9 |

No quality drift either way. Task outcomes: 22/22 on both levels, 21/22 on base.

A smaller synthetic set (18 runs, three hand-written scenarios) gave a weaker
cut — plain at 72% of base — and is kept only as a second opinion; the jargon
share in its closing-summary scenario fell from 0.45 to 0.06.

Against the change: the persona marker 🚬 appears in 3 of 24 plain runs against
7 of 24 on base. Small numbers on deliberately dry tasks, but it is a possible
dip in voice and it is not dismissed here.

## The third level was measured and dropped

`terse` bought too little. Against `plain` it saved nothing on the median (185
vs 186 words overall, 86 vs 85 on the plan-and-questions turn) and about 7% on
the mean (164 vs 177); its Latin-token share was nearly double — 0.062 against
0.034 on the median (definition and per-arm figures: the JSON beside this file)
— so it read harder, not easier; on the synthetic set it came out longer (213 vs
205). Its one real edge was the second turn, 80 words against 87. That does not
buy a third level in a public protocol, a second recipe block in every user's
always-on config and a third arm in every future run. The numbers are kept here
as the reason it is gone.

The `plain` numbers survive the removal: the plain recipe — the level's bullet
and the AT-EVERY-LEVEL paragraph, the two pieces a host config is told to copy —
is untouched in that change (visible in the `AGENT.md` diff); what went was the
third level's own lines and its name in the list of switch phrases.

## Corrected 2026-09-12 — the gate probe was broken

The "ran a verification command" row above was measured by a probe that looked
for the task's own symbol inside the shell command; real runner invocations
scored as "no gate". Re-scored from the stored transcripts with a fact-based
probe, that dimension sits at ceiling in this epoch, and none of the verdicts
on this page change. The row is shown corrected, with the original numbers
named beside it.

## Read these numbers with the noise band

Measured after this page was written: the same payload re-run against itself
moves `consent_asked` by 3 and `no_premature_write` by 5 at two runs per cell
(`batch2-2026-09-12.md`). So the rejections recorded above at −9 and −10 stand
well outside drift, while the second cut's −4 / −3 verdict (−3 / −3 re-scored) is inside it — that
cut may have been rejected for noise. The shipped level's numbers (worst −1)
say "nothing large broke", not "nothing moved".

## What this does not measure

Two runs per cell: direction only, no confidence intervals. One model snapshot.
The arms carried a condensed Russian rendering of the level block (what this
maintainer's own config holds), not the verbatim English text the protocol
prescribes — content-equivalent, form different, so this run is not proof of the
English wording.
The scenarios are synthetic single-turn prompts, not real sessions. "Clearer to
read" was not measured at all — only length, jargon share and marker survival.


## Correction — second probe repair (2026-09-12, same day)

Three more instruments on this page were found broken after it was written, and
the numbers above are left as they were measured rather than quietly restated
(method and full tables: [`probe-repair-2026-09-12.json`](probe-repair-2026-09-12.json)):

- **"Named the tier"** was blind to `Light tier —`, `(Light)` and
  `Trivial → Light`, and it read only the agent's first text block — so a
  one-line "let me look at the file" before the tier line scored as never naming
  the tier. The tier row moves on every arm but one (e7's fourth plain cut):
  base 19/24 → 22/24, the third cut
  12/24 → 16/24, the shipped plain level 20/24 → 23/24 in the final round.
- **"Verdict + closing summary"** read the last turn instead of the run, so a
  run finished inside turn 1 scored as having produced none. Five arms here move
  to 16/16.
- **"Did not write before consent"** could not tell a redirect from a comparison
  inside quotes or a heredoc, and once patched by demanding whitespace it stopped
  seeing `echo hi>out.txt`. It now strips shell literals first. Six arms move:
  base 16/18 → 17/18, the third plain cut 16/18 → 17/18, the fourth 15/18 →
  17/18, the first terse cut 6/18 → 7/18, the second 13/18 → 14/18, the third
  16/18 → 17/18.
  So the first cut's numbers in the list above read 17/18 → 9/18 (plain) and
  7/18 (terse) after re-scoring.

**No verdict on this page changes.** The three rejected cuts stay rejected — the
first on consent at z −3.54, the second at z −2.92 (published −3.20), the third
at z −2.13 (published −2.11) — and both shipped levels still PASS. What the
repair does change is the honest reading of the tier numbers above: they were
low for every arm, base included, so the gaps between arms survive but the
digits do not.
