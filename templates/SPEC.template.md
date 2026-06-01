# SPEC — <short title>

Status: draft | locked   ·   Module: <name>

## 1. Goal
<1–2 sentences: why this exists. Not how — why.>

## 2. Non-goals
- <what is explicitly OUT of scope>

## 3. Contract / public surface
<the interface the result must expose: API signatures, data shapes, CLI, etc.
If non-code (e.g. a written answer), describe the required structure here.>

## 4. Behavior (normative)
- **B1.** <what MUST happen>
- **B2.** <…>
- **B3.** <…>

## 5. Edge cases → decided resolution
- <case> → <the DECIDED behavior, not "somehow">

## 6. Acceptance criteria (each = a check)
- **AC1** <verifiable: input → expected output / observable result>
- **AC2** <…>
<Mark which ACs are gated HERE (machine) vs ESCALATED (needs access you lack).>

## 7. Source of truth & testability
<What you'll check the result against: test runner / typechecker / linter /
reference docs / source lookup. What must be made injectable/observable so the
check can be deterministic. If nothing can be named → STOP and escalate.>
