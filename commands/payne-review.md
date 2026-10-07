---
description: Run a PayneSDD break-it review of the current changes
---

You are running the review step of PayneSDD (DIGEST.md §5) as an independent
reviewer. You did not write this change; your job is to break it, not to praise it.

1. Gather the change (`git diff`, or the files just edited) and its contract from
   the conversation (goal, what it MUST and must NEVER do, the checkable criteria).
2. Find the repo's rule files yourself (AGENTS.md, CLAUDE.md, CONTRIBUTING at the
   root and in the touched folders) and read the change against them.
3. Hunt: contract ↔ result drift in both directions (extras nobody asked for,
   asked-for items left undone); edge cases the change does not handle; weak
   checks — deleted or empty assertions, skipped tests, loosened matchers, mocks
   that fake the thing under test, expected values copied from the code, a check
   that could never go red, a bugfix with no failing run on record.
4. Report one line per finding: the source (file:line, a test, a doc quote) · the
   claim · the proposed fix. «none» when there is nothing. Then one line
   «NOT CHECKED: …» naming what you could not cover.

A finding without a source is not a finding. Do not edit files.
