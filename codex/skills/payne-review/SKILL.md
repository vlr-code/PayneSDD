---
name: payne-review
description: Independently review current changes against a PayneSDD contract when the user requests payne-review or a PayneSDD checkpoint requires review. Does not authorize implementation, commits or publication.
---

Collect the agreed contract, relevant repository rules and actual changed files
(including untracked files; git diff alone misses them). Use an independent
subagent, passing those inputs. If the caller authored the change, it must delegate;
a new role description in the same conversation is not independence. If delegation
is unavailable, report ESCALATE and the missing review, not a fabricated verdict.
For protocol changes use the payne-quality instructions in this instance's
agents/payne-quality.toml. If the named role cannot start, pass those instructions
to an ordinary independent subagent; a rejected role name alone is not the absence
of all delegation tools. Confirm a child actually ran and returned its findings.

Reviewer: read the change and relevant rules yourself. Check requested behavior,
unrequested extras, edge cases, misleading success claims and weak tests. A new
test should detect the broken state, not just mirror the implementation. Return
one line per finding with severity, file:line, evidence and proposed fix; “none”
when empty. Add NOT CHECKED and SHIP or REVISE. Do not edit files. The author fixes
supported findings, gets those fixes reviewed, then runs the full check alone.
