---
description: Run a PayneSDD adversarial (break-it) review of the current changes
---

You are running Step 5 (ADVERSARIAL) of the PayneSDD protocol.

Do this:
1. Gather the current changes (e.g. `git diff` / the files just edited) and the
   relevant `SPEC.md` if one exists — from a FIXED point (a commit or a stash),
   so the review and the gate describe the same tree — plus the plan and, when
   one is named, where the sibling lives (the same feature on another
   platform, service or repo).
2. Launch a SEPARATE subagent — not yourself — with a "break it, don't praise it"
   brief (on Full, a host with no subagent mechanism at all runs a DISCLOSED
   self-pass instead, and the verdict is then never PASS — ESCALATE, the human
   reviews): hunt for contract↔result drift, uncovered behavior, weak checks —
   AUDIT THE TESTS THEMSELVES and how green was reached: deleted/empty
   assertions, skipped tests, loosened matchers/thresholds, mocks that fake the
   unit under test, tautological assertions (an expected value recomputed the way
   the code computes it is green by construction — expecteds come from an
   independent source), checks that never FIRED (an env/config exemption, an
   early abort, or a CI ignore kept the check from ever running — confirm it
   executed and can still fail; the gate map itself must name the run signal and
   the value that would redden each check), checks the author wrote for this
   task and never showed red, checks born from an earlier finding that were
   never seen red, a reading rule registered before a run with a branch only a
   broken measure can reach or a run result no branch names, and bugfix claims
   with no red reproduction on record — boundary defects, and gaps in the
   contract itself. Drift runs in BOTH directions: hunt undeclared extras in the
   diff AND contracted/planned items the diff never touched — silently dropped
   work is a finding (cite the plan/contract line it dropped), never something
   left to the author's own Remaining list. Beyond the contract: look for the
   repo's rule files yourself — AGENTS.md, CLAUDE.md and CONTRIBUTING at the
   root and in each directory the change touches, and the in-repo files they
   link to, never only the ones the author named — and read the change through each lens that applies: the repo
   rules on any code change; the sibling when there is one; the trigger (who
   or what starts the behavior, and when: at start or at a lazy first use) when
   it starts on a signal or a clock; setup failure when the change adds a
   setup, attach or subscribe step. Every finding MUST cite a source
   (file:line, a doc quote, a concrete test). Findings with no source tie are
   marked "unconfirmed", not asserted as bugs. The report comes back COMPACT:
   one line per finding — source tie + claim + proposed fix; an explicit "none"
   when clean, and a required NOT CHECKED line naming what the pass could not
   cover, each lens above that applies but could not be covered included, with
   why — silence about an uncovered area reads as coverage.
3. Adjudicate the findings yourself (the verifier is not an oracle): accept and
   fix only source-tied findings; reject the rest and say why. When an accepted
   finding exposes a hole in the contract itself, ratchet: the clause plus the
   named check that proves it land first, then the fix (Step 4). A finding in
   code also starts the mechanism search (Step 4, RATCHET THE CODE).
4. After any fix, re-run the machine gate (Step 4) and run this review again on
   anything no review has read yet — the fix, a later commit, a merge's
   resolution; each round (AGENT.md Step 5: a pass, its fixes and the gate on
   them) counts against the Step 2 budget. Then give the Step 6
   verdict: PASS only on one state the gate ran green on and the reviews have
   read in full, confirmed at the verdict not to have moved since (Step 4), and
   the evidence names it — on Full work with later changes, also which changes
   that review read; ITERATE; or ESCALATE naming what no review has read —
   and, on Light/Full, the compact Done / Remaining / Open questions closing
   summary.

Do not fix findings the reviewer could not prove.
