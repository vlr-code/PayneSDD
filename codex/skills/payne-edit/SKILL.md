---
name: payne-edit
description: Change or inspect the user's PayneSDD Codex protocol, toggle its dev mode, or triage its inbox. Use for an explicit PayneSDD change request or payne-edit command, not ordinary project edits.
---

Resolve this skill's real path (follow symlinks); the instance is two directories
above this SKILL.md's containing directory. Read that instance's MAINTAINING.md,
DIGEST.md and .payne/decisions.log. Never select the parent's Claude instance.

For on/off/status, use `python3 <instance>/scripts/dev_mode.py <on|off|status>`.
On/off require the user's request; status is read-only. Respect CODEX_HOME.
For inbox, read ~/.payne/inbox.md, group findings and propose changes; do not
rewrite or clear the inbox. Changing a rule follows the consent gate.

For a change: show the Full contract and plan, wait for explicit consent, then
edit only the approved scope. Invoke an independent subagent with the instructions
in <instance>/agents/payne-quality.toml (or the registered payne-quality role).
If the named role is rejected as unavailable, spawn an ordinary independent
subagent and pass that file's developer_instructions as its review assignment.
Only absence/failure of independent delegation itself blocks the review.
Never claim that reading that file is a review. Follow MAINTAINING's review,
measurement and final machine-check order. Show the actual diff and evidence.
Do not commit, push or release without explicit authorization for those acts.
