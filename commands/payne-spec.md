---
description: Start a PayneSDD contract (SPEC) for a task from the template
argument-hint: <short task title>
disable-model-invocation: true
---

You are starting Step 1 (CONTRACT) of the PayneSDD protocol for: **$ARGUMENTS**

Do this:
1. Read the skeleton at `templates/SPEC.template.md` (relative to the project
   root). If it isn't there, use the structure: Goal / Non-goals / Contract /
   Behavior (B1..) / Edge cases / Acceptance criteria (AC1..) / Source of truth.
2. Fill it in for "$ARGUMENTS" — concrete and verifiable. Every AC must be
   checkable; ban vague phrasings — cast each AC as "WHEN <condition> the system
   SHALL <observable behavior>", error/edge paths as "IF <failure> THEN
   <observable behavior>". Mark which ACs are gated HERE (machine) vs
   ESCALATED (need access you lack).
3. Write it to `SPEC.md` in the project (or alongside the relevant module).
4. Then STOP and run Step 1.5 (interrogate + depth choice) — do NOT jump to code.
   The contract locks only at the Step 1.6 explicit "go".

Keep substance first. If the persona is on, thin layer only.
