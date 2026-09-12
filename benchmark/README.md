# PayneSDD benchmarks

**Measured findings (plain language): [FINDINGS.md](FINDINGS.md)** — what the
harness taught us about the protocol, its competitors, and its limits.

A fixed task you run through PayneSDD after any big change to the protocol, to
check the protocol still produces a good, verifiable result. Run it as a normal
request and compare the result against its checklist — by eye and by building it.

These are NOT automated unit tests of PayneSDD. They are a human-checkable
"does the protocol still cook" sanity run.

---

## Benchmark 1 — Image downloader (Swift / iOS)

### The task — give this to the agent verbatim

> I need a Swift project that can download images from a URL entered by the user
> and save them to the device, with the ability to view the saved images. It needs
> error handling and a simple but modern, high-quality UI.

### What "pass" looks like — check by building and by eye

- [ ] User can type or paste a URL and start a download.
- [ ] A valid image URL downloads and the image is saved on the device.
- [ ] Saved images can be viewed in the app (a list or grid, plus a full view).
- [ ] Errors are handled and shown clearly — bad URL, no network, the link isn't
      an image, save failed — and the app never crashes or freezes.
- [ ] The UI is clean and modern (not raw default controls): sensible layout, a
      loading indicator while downloading, and an empty state when nothing is saved.
- [ ] The agent actually ran the protocol on it: a contract first, a real gate
      (it builds / tests pass), and an honest verdict — not just "here's some code".

### How to run it

1. Start a fresh session with the new version of PayneSDD in place.
2. Paste the task above.
3. Watch that the protocol runs: a tier is picked, consent is asked before code,
   the gate runs, a verdict is given.
4. Build and run the result, then walk the checklist above. Anything unchecked is
   a regression to look at.

### Note on the machine gate

This task is an iOS app, so a real gate needs a Mac with **full Xcode** (not just
Command Line Tools) and an iOS simulator. Before declaring that gate unavailable,
the agent must check what's actually INSTALLED — not just the active/default
selection (Step 4). If the toolchain is genuinely heavy or absent, it must ASK
the human: run the FULL gate, or a LIGHTER one (built-in runner for the logic,
the rest soft/by-eye) — and record which ran. Only when neither is possible does
the protocol say escalate, not fake a pass.

---

## Battle-validation methodology (pre-committed; first runs done)

The first measured pass shipped with 0.6.0 — token cost + gate-adherence tests
(summary snapshot: [`token-tests-0.6.0.md`](token-tests-0.6.0.md), headline in
the README "Token cost — measured" section). The full QUALITY validation ran
in July 2026 — plain-language results in [FINDINGS.md](FINDINGS.md), numbers in
[`findings-2026-07.json`](findings-2026-07.json). The harness follows these
rules — fixed BEFORE any numbers existed, so there were no numbers to inflate:

- **Three arms, honest delta.** Compare (1) a naked agent, (2) a cheap control —
  one careful prompt: "plan first, verify your work, be honest about failures" —
  and (3) the full protocol. The headline number is protocol vs CHEAP CONTROL,
  never vs the naked agent: the naked-baseline delta conflates the protocol with
  the generic "be careful" effect. (Baseline-only deltas are how benchmark
  headlines get inflated — and how independent re-benchmarks erase them.)
- **Committed snapshot.** Raw results land in git; CI reads the snapshot and
  never re-runs — the CHECK is deterministic, and any change to the numbers is
  a reviewable diff. (Refined 2026-07: "raw" = scores, aggregates and metadata
  — e.g. `findings-2026-07.json`; full transcripts and generated test artifacts
  stay git-ignored in `benchmark/local/`, per the standing artifacts-never-in-
  history rule.)
- **The acceptance rule is a test, not a count** (changed 2026-09-12 after the
  old rule was measured against identical text; numbers and method:
  [`rule-change-2026-09-12.json`](rule-change-2026-09-12.json)), **and its
  threshold is stated by MEANING, not by a number** (changed 2026-09-13). A
  candidate is REJECTED when EITHER holds: the WORST gated two-proportion z
  against the base falls at or below **the softest value whose false-alarm rate
  on this suite's own measured null is still at most 5%**; or any task that
  PASSED EVERY base run FAILS EVERY candidate run (the trap named in a
  pre-registration is one instance of that). A dimension is **gated** only when
  at least four tasks score it — the others are printed, never decisive.

  Why meaning and not a number: the rule takes the WORST of the gated
  dimensions, so adding dimensions that genuinely vary pushes that minimum
  deeper and a fixed cut silently changes what it means. Measured: the same
  "z ≤ −2" is a **3.7%** false-alarm rule on the 15-task suite and **10.7%** on
  the 27-task suite. Stated by meaning instead, the threshold is **−2.13** on the
  old suite — where it selects exactly the same comparisons the fixed −2 did,
  3.71% either way — and **−2.32** on the new one, at 4.48%.

  WHICH NULL. The cut is calibrated on the COMPARISON EPOCH'S OWN null, not on a
  stored per-suite number: a two-arm run at two per cell already gives four runs
  per task, which is exactly what the permutation needs. The per-suite figures
  above are a reference for planning, never the gate — read against the wrong
  epoch's null they flip verdicts, which is how a −1.55 was once called a 2%
  event when its own epoch says 9.4%. Recompute whenever the suite OR THE
  SCORING changes: repairing two probes on 2026-09-13 moved the new suite's cut
  on its own, so a stored threshold is valid only for the `scores.json` it was
  measured on.

  THE RECIPE, in full, because a number ships with the rule that produced it:
  the statistic is the MINIMUM over gated dimensions of the two-proportion z;
  the null is built by splitting each task's four runs at random into two
  pseudo-arms of two, 20,000 times; the cut is found by walking from the deepest
  achievable value upward and keeping the last one whose share of draws at or
  below it is still ≤ 5% — **the comparison must INCLUDE the value itself**, and
  getting that wrong by one atom published a 5.67% cut under a 5% rule before
  this sentence existed. Tool: `benchmark/local/harness/calibrate_rule.py
  <single-arm-epoch>` (it lives in the git-ignored harness, so the recipe above
  is the shippable form). Two cautions travel with the recipe: on a discrete null
  you may NOT take the 5%-index as the cut — the atoms are lumpy, the index
  lands inside one, and rejecting at "≤ that atom" takes the whole atom, which
  measured on the old suite turns a 3.7% rule into a 13.4% one; and the achieved
  rate lands under the target rather than on it for the same reason.

  **Dropped in the same change: the "two or more gated dimensions at −1.5"
  clause.** Three independent findings against it and none for it. It never
  fired ALONE in 60,000 splits of the old null. Its only supporting real example,
  the 2026-08 haiku rejection, evaporated when the probes were repaired. And on
  the new suite it fires on **10.3%** of identical-text splits by itself (defined
  as: two or more gated dimensions at −1.5 or worse), which no calibration of the
  primary cut can offset. All three are statements about FALSE ALARMS. None of
  them says anything about POWER — whether the clause catches a real
  multi-dimension drop that the single worst-z misses has never been measured, so
  this is a judgement call paid for in an unknown, not a measurement. Removing a
  clause is a loosening and was done with explicit consent, not on my own
  judgement.

  Task outcome is gated by the same z as anything else:
  the "outcome may not fall" clause it replaces was a zero-tolerance count on a
  dimension whose own flip rate is about 5%, and on 2026-09-12 it rejected an
  end-to-end run where every discipline dimension had improved, over one flip of
  a task that fails 23% of the time in every arm.
  What the change is worth, measured on the three identical-text pairs on disk:
  the old count rule ("no dimension may drop by 3 or more") fired on **two of
  three**, the z rule on **none**. Still none after the 2026-09-12 probe
  repair. And the rule's false-alarm rate is now MEASURED rather than guessed —
  as a magnitude, not a constant: 60 runs of one identical arm, split at random
  into the exact shape a real comparison has, are rejected **a few percent of
  the time, order one comparison in 30**
  ([`noise-band-2026-09-12.json`](noise-band-2026-09-12.json)). Three
  uncertainties sit under that, smallest first: 3.59 / 3.71 / 3.84 across seeds
  at 20,000 splits each; **roughly 1–10%** when the 15 tasks themselves are
  resampled; and 2.1% when the same estimator runs on a different epoch's 60
  runs. The withdrawn "~9%" this project used to print sits inside that spread,
  so the measurement replaces an unsourced figure — it does not refute it.
  Two conditions travel with the number. The achievable worst-z values are
  LUMPY: the atoms below −1 are −1.01, −1.44, −2.13 and −2.88, so on this null a
  −1.5 cut and a −2 cut reject exactly the same splits — the threshold is not
  resolved by this measurement, only the rule as a whole. And two of the six
  gated dimensions (task outcome, verdict + summary) do not vary within a single
  task in that epoch at all, so the null is carried almost entirely by the
  consent pair. Under it the worst gated z reaches −2.88, median −1.01, 5th
  percentile −1.44; the two-dimension clause never fired alone in 60,000 splits
  and the task clause never fired — which is a statement about false alarms
  only, never about power (see the open question below).
  What it is NOT worth: sensitivity. A ~20%
  relative degradation is invisible to both rules at this budget — z buys
  false-alarm control and invariance to n (a count threshold against an
  aggregate that grows with n gets looser the more runs you pay for), not power.
  Honest exception on record, and its retraction: the 2026-08 haiku rejection
  (`e5-cch-borrows`) was recorded here as four dimensions down at once, worst
  z −1.94, passing the max-z clause but caught by the two-dimension clause —
  the example that motivated that clause. Two of those four dimensions were
  measured by probes repaired on 2026-09-12
  ([`probe-repair-2026-09-12.json`](probe-repair-2026-09-12.json)); re-scored,
  that comparison PASSES the whole rule, worst z −1.51. So the clause's
  motivating example no longer held, and no example on disk required it. It was
  KEPT on 2026-09-12 on the ground that a check is not loosened because its first
  case evaporated — and REMOVED on 2026-09-13 with explicit consent, once the
  27-task suite showed it firing on 10.3% of identical-text splits by itself.
  This paragraph is history; the rule in force is the one at the top of the file.
- **A release checked end to end, not only leg by leg.**
  [`daycheck-2026-09-12.json`](daycheck-2026-09-12.json) (60 runs) compares the
  protocol as it stood at the start of 2026-09-12 against where it ended, in one
  epoch. Two legs had each passed on their own; a composite of two small drops
  would have slipped between them. It PASSES, with the worst deciding measure at
  the median of its own epoch's noise.
- **The rule has rejected this project's own work — worked example.**
  [`item5-2026-09-12.json`](item5-2026-09-12.json) (60 runs, 2026-09-12) is the
  snapshot with no companion page: three protocol clauses went in, the
  no-regression half passed, the benefit half came back empty on both traps, and
  one clause was dropped on that null rather than shipped with an excuse.
- **Base and candidate run inside the SAME epoch.** Across the three
  identical-text pairs the later epoch scored worse on 24 of 35 moved
  (task, dimension) cells against 11 better — a two-sided sign test gives
  p = 0.04 (first published as 31 against 16; the cells were re-counted after
  the 2026-09-12 probe repair, and the pre-repair scores give 29 against 15,
  p = 0.049 — neither recomputation reproduces the original counts exactly).
  Those cells are correlated and span only two epoch transitions,
  so read it as "a downward drift exists between epochs", not as a calibrated
  number. Either way a cross-epoch comparison cannot judge a candidate; it can
  only estimate a band.
- **Single-task dimensions are reported, never gated.** With one task and two
  runs a dimension has two cells: one flip is 50 points. On the 15-task suite
  four of the ten dimensions were in that position; the 27-task suite gives each
  of them four tasks, so on it all ten are gated. The rule stands for whatever
  suite comes next.
- **Saturation is a limit too.** After the 2026-09-12 probe fix, "ran a
  verification command" sits at ceiling on the base arm: the suite can still
  catch a collapse there, but it can never show that a change IMPROVED gate
  adherence. Say which of the two a run could have shown.
- **Two vocabularies, two purposes.** "Three arms" above describes competitor
  comparisons; protocol-wording epochs run one base arm and one candidate arm,
  and the rules in this section are about those.
- **A "what this does NOT measure" section is mandatory** — fidelity limits,
  single-run noise, model/version scope. An honest caveat beats a big number.
