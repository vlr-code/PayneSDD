---
description: Dev mode — improve PayneSDD itself from any project: edit the canonical repo live, gate it, quality-review, then commit/push (and optionally release) with your approval.
disable-model-invocation: true
---

# /payne-edit — PayneSDD self-improvement (dev mode)

You are about to modify the **canonical PayneSDD repository itself**, possibly from
inside a *different* project. This is the dev-mode execution engine. Be disciplined:
it edits a public product and writes to a real repo.

## 0. Precondition — dev mode must be ON
Dev mode is ON iff the marker file `~/.claude/.payne-dev-mode` exists.
- Subcommands, handle first and STOP: `on` → create the marker; `off` → remove it;
  `status` → report ON/OFF + the resolved repo path.
- If a change is requested while dev mode is OFF → say so, mention `/payne-edit on`,
  and STOP. Edit nothing.

## 1. Resolve the target repo (NEVER the current project)
The repo path is configured, not assumed. Resolve in order:
1. the first line of `~/.claude/.payne-dev-mode`, else
2. the `PAYNE_REPO` env var, else
3. nothing resolved → STOP and ask the user for the repo path. Never guess it.

Use `git -C "<repo>" …` for every git op and absolute paths for every edit.
**Never modify the current project's files** — only the PayneSDD repo.

## 2. Understand the change first (consent before code)
The request can arrive as an explicit `/payne-edit <ask>`, a free-text trigger
("…надо тут доработать PayneSDD"), or a self-noticed protocol gap. In all cases:
- Pin the MOTIVATING CONTEXT — which concrete moment/gap prompted this, tied to a
  source (a transcript moment, a `file:line`, a real friction). No invented gaps.
- FAIL CLOSED: if the gap can't be tied to a concrete source, do NOT guess — STOP
  and ask the human to point at it.
- Restate in one short block: "the gap is X; I'll change Y in <files>."
- Ask "fix it this way?" and STOP. Do not edit until an explicit yes.

## 3. Run the PayneSDD protocol on the change (Step 0–3)
Editing the protocol is editing a public product → Step 0 tier is FULL — the hard
floor (public-facing / SDK) applies however small the edit looks, typos included
(a typo just has 0 forks, so Step 1.5 collapses; the gate and review still run).
Run the cycle: contract → real forks / depth → execute against the contract.

**Match the form to the failure when wording a clause.** Name the failure it
targets, then fit the form — the wrong one backfires: discipline slip → a
prohibition + a rationalization line; wrong-shaped output → a positive recipe
(what the output IS, its parts in order); omission → a required slot in the
template; context-dependent → a conditional keyed to an observable predicate.
Bare prohibitions backfire on shaping problems, and a "…unless it matters" rider
on a working recipe reopens the negotiation.

## 4. Machine gate (Step 4)
- `bash "<repo>/scripts/payne-check.sh"` is the gate for any SHELL edits — it lints
  `hooks/*.sh` only. For a doc-only change it can't go red, so green there proves
  nothing by itself; don't present it as if it did.
- So for doc edits YOU run the deterministic source-of-truth check by hand: version
  numbers consistent, step numbers intact, README cycle table / CHANGELOG / links
  resolve. That manual check — not the script — is the real gate for protocol prose.

## 5. Quality review (Step 5) — the SEPARATE quality agent
Spawn the **payne-quality** agent (independent, not yourself) on the diff. It guards
coherence, anti-bloat, fidelity to principles, and cross-reference integrity.
- FALLBACK: file-based agents load only at session start, so in the same session you
  first install dev mode `payne-quality` won't be a known agent type yet. If it isn't
  available, run the SAME reviewer brief via a general subagent — never skip the
  review. It loads normally next session (dev mode is usually invoked from another
  project = a fresh session, so this only bites the install session).
Adjudicate by the tie-to-source rule: fix only source-tied findings, reject the rest
with a reason, then re-run the gate.

## 6. Decision log
Dev-mode edits are Full-tier, so the normal decision-log rule applies: append
`[APPROVED]` / `[DEVIATION]` one-liners to `<repo>/.payne/decisions.log`.

## 7. Commit / push (one approval) — release only if asked
- Show `git -C "<repo>" diff`. On ONE explicit "yes": commit (end the message with
  the `Co-Authored-By` trailer) and push to `main`.
- NEVER commit or push without that explicit yes.
- **Release** only if the user asks: bump the version badge + Status + the
  `AGENT.md` header stamp, promote the CHANGELOG `## Unreleased` entry to the
  version, tag `vX.Y.Z`, `gh release create` — each with approval.

## 8. Close with the Step 6 summary
End with the verdict word + the **Done / Remaining / Open questions** checklist.

## Hard rules
- Dev mode OFF → refuse and stop.
- Touch ONLY the PayneSDD repo, never the host project.
- Never commit / push / release without explicit approval.
- Tie every gap/finding to a source — no invented problems.
- No standing watcher: the quality agent is invoked on demand, not always-on.
