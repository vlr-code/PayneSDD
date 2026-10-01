# PayneSDD — Multi-Agent Roles (OPTIONAL overlay)

This file is an OPTIONAL add-on to `AGENT.md`. It does NOT replace the protocol
and does NOT add a second lifecycle. It maps named roles onto the SAME Steps 0–6.
Each role is one subagent with a defined INPUT artifact and OUTPUT artifact;
the artifact is the only thing handed to the next role.

## When to switch roles ON
Use roles ONLY when the task is large enough that a single agent loses the thread:
many files, multi-day work, or several humans + agents sharing it.
For a normal task (a function, a screen, a support reply) DO NOT use roles —
the plain single-agent protocol is faster and the adversarial subagent (Step 5)
already gives you independent review. Roles are a scale tool, not a default.

In tier terms (Step 0): roles are a FULL-tier tool for LARGE tasks — they never
apply to the Light or Trivial tiers.

The human decides ON/OFF — same spirit as the depth choice in Step 1.5b.
If unsure → roles OFF.

## The chain (each role = a subagent, each arrow = one artifact)

```
Product ─► Analyst ─► [human] ─► Product ─► Architect ─► Scrum Master ─► Developer ─► QA
 draft      forks     depth +     final      design        task list       code      verdict
 SPEC                 answers     SPEC
```

Product drafts the SPEC first, so the Analyst has a contract to interrogate
(AGENT.md 1.5a hunts contradictions in the DRAFTED contract); the human's
depth choice and answers (1.5b/1.5c) sit between them and the final SPEC — that
turn belongs to the main thread, not to a role.

Roles are not new ceremony bolted on top — they are WHO performs each existing
step. Mapping onto AGENT.md:

| Role | Owns which Step | INPUT | OUTPUT artifact |
|---|---|---|---|
| **Product** | Step 1 (contract: draft, then final) | raw request + the repo rule files; then forks + the human's answers | draft `SPEC.md`, then the final `SPEC.md` (filled from the template) |
| **Analyst** | Step 1.5a (prep) | raw request + the draft SPEC + the sibling the request, the draft SPEC or the human names | fork structure (the depth analysis) + contradictions found in the draft |
| **Architect** | Step 2 (plan) | SPEC.md | design + dependency-ordered approach |
| **Scrum Master** | Step 2 (decompose) | design | task list (each task ties to AC IDs) |
| **Developer** | Step 3 (execute) | one task | code for that task, referencing `// B*` |
| **QA** | Steps 4 + 5 | code + SPEC.md + the repo rule files (found by QA itself) and the sibling the SPEC names | gate result + adversarial findings (hypotheses) + recommended verdict (incl. the Step 6 Done / Remaining / Open-questions closing summary) |

## Hard rules so roles don't become the monster
- **The gates do not move.** Step 1.6 plan-approval STOP still happens (after
  Scrum Master, before Developer). Step 4 machine gate and Step 5 adversarial
  pass still run — they are simply QA's job now. No role may skip a gate.
- **Independence is the point.** QA is a DIFFERENT subagent than Developer —
  never let the author grade its own work. That independence is the whole reason
  to pay for roles.
- **"Verifier is not an oracle" still holds.** QA findings are hypotheses; the
  main thread that runs the chain — not QA itself — accepts only those tied to a
  source (Step 5) and issues the final Step 6 verdict. A role title does not
  make a claim true.
- **One artifact per handoff.** A role reads the previous artifact and the SPEC
  — plus the repo rule files for Product and QA, and the sibling for Analyst and
  QA (AGENT.md Steps 1, 1.5a, 5); the SPEC quotes each touched rule for the rest
  — nothing else. No role rewrites an upstream artifact silently — if Architect
  finds the SPEC wrong, it escalates back to Product (fix the contract first,
  Step 1), it does not patch around it.
- **Collapse freely.** At the smaller end of the large-task range you may merge
  roles (e.g. Architect + Scrum Master in one subagent). Roles are a lens, not
  mandatory headcount.
  If you ever have more role overhead than actual work — turn roles OFF.

## Personality note
If the optional persona from AGENT.md is on, ALL roles share the one voice — it's
the same character wearing different hats, not six different characters. Keep
the dosage rule: substance first, character a thin layer.
