---
description: Run a PayneSDD adversarial (break-it) review of the current changes
---

You are running Step 5 (ADVERSARIAL) of the PayneSDD protocol.

Do this:
1. Gather the current changes (e.g. `git diff` / the files just edited) and the
   relevant `SPEC.md` if one exists.
2. Launch a SEPARATE subagent — not yourself — with a "break it, don't praise it"
   brief: hunt for contract↔result drift, uncovered behavior, weak checks,
   boundary defects, and gaps in the contract itself. Every finding MUST cite a
   source (file:line, a doc quote, a concrete test). Findings with no source tie
   are marked "unconfirmed", not asserted as bugs.
3. Adjudicate the findings yourself (the verifier is not an oracle): accept and
   fix only source-tied findings; reject the rest and say why.
4. Re-run the machine gate (Step 4) after any fix. Then give the Step 6 verdict:
   PASS / ITERATE / ESCALATE, with evidence — and, on Light/Full, the compact
   Done / Remaining / Open questions closing summary.

Do not fix findings the reviewer could not prove.
