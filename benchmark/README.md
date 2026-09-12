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
  [`rule-change-2026-09-12.json`](rule-change-2026-09-12.json)). A candidate is
  REJECTED when ANY of these holds: a gated dimension shows a two-proportion z
  of −2 or worse against the base; two or more gated dimensions sit at −1.5 or
  worse; the task named in the pre-registration as that candidate's trap goes
  from passing in every base run to failing in every candidate run; or any task
  that PASSED EVERY base run FAILS EVERY candidate run. A
  dimension is **gated** only when at least four tasks score it — the others are
  printed, never decisive. Task outcome is gated by the same z as anything else:
  the "outcome may not fall" clause it replaces was a zero-tolerance count on a
  dimension whose own flip rate is about 5%, and on 2026-09-12 it rejected an
  end-to-end run where every discipline dimension had improved, over one flip of
  a task that fails 23% of the time in every arm.
  What the change is worth, measured on the three identical-text pairs on disk:
  the old count rule ("no dimension may drop by 3 or more") fired on **two of
  three**, the z rule on **none**. Still none after the 2026-09-12 probe
  repair, where the worst that identical text does to itself is z = −1.69.
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
  motivating example no longer holds, and no example on disk now requires it.
  The clause STAYS — a check is not loosened because its first case evaporated,
  and the rejection it belongs to was in any case overturned on sonnet and
  shipped — but it is now carried on argument, not on evidence, and that is an
  open question for the next round, not a settled one.
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
  runs a dimension has two cells: one flip is 50 points. Three of this suite's
  nine dimensions are in that position.
- **Saturation is a limit too.** After the 2026-09-12 probe fix, "ran a
  verification command" sits at ceiling on the base arm: the suite can still
  catch a collapse there, but it can never show that a change IMPROVED gate
  adherence. Say which of the two a run could have shown.
- **Two vocabularies, two purposes.** "Three arms" above describes competitor
  comparisons; protocol-wording epochs run one base arm and one candidate arm,
  and the rules in this section are about those.
- **A "what this does NOT measure" section is mandatory** — fidelity limits,
  single-run noise, model/version scope. An honest caveat beats a big number.
