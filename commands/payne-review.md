---
description: Run a PayneSDD adversarial (break-it) review of the current changes
---

You are running Step 5 (ADVERSARIAL) of the PayneSDD protocol.

Do this:
1. Gather the current changes (e.g. `git diff` / the files just edited) and the
   relevant `SPEC.md` if one exists.
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
   executed and can still fail), and bugfix claims with no red reproduction on
   record — boundary defects, and gaps in the contract itself. Drift runs in
   BOTH directions: hunt undeclared extras in the diff AND contracted/planned
   items the diff never touched — silently dropped work is a finding (cite the
   plan/contract line it dropped), never something left to the author's own
   Remaining list. Every finding MUST cite a source (file:line, a doc quote, a
   concrete test). Findings
   with no source tie are marked "unconfirmed", not asserted as bugs. The report
   comes back COMPACT: one line per finding — source tie + claim + proposed fix;
   an explicit "none" when clean.
3. Adjudicate the findings yourself (the verifier is not an oracle): accept and
   fix only source-tied findings; reject the rest and say why. When an accepted
   finding exposes a hole in the contract itself, ratchet: the clause plus the
   named check that proves it land first, then the fix (Step 4).
4. Re-run the machine gate (Step 4) after any fix. Then give the Step 6 verdict:
   PASS / ITERATE / ESCALATE, with evidence — and, on Light/Full, the compact
   Done / Remaining / Open questions closing summary.

Do not fix findings the reviewer could not prove.
