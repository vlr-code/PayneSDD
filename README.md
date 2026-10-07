<div align="center" markdown="1">

<img src="assets/hero.png" alt="PayneSDD" width="100%">

# PayneSDD

### — "Payne, I can't feel the spec-driven development!"<br>— "That's because you don't have any. Yet."

[![License: MIT](https://img.shields.io/badge/License-MIT-orange.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-actively%20used-brightgreen.svg)](#status)

[![⬇ Download latest release](https://img.shields.io/badge/⬇_Download-latest_release-2ea44f?style=for-the-badge)](https://github.com/vlr-code/PayneSDD/releases/latest)

*A short spec-driven protocol for agentic coding — the paperwork is the agent's problem, not yours.*

</div>

---

## The problem

You prompt → the agent codes → it says **"done"** → and now you either re-read
everything anyway, or play everyone's favorite game: ***Guess What Shipped!***
An agent's "done" means nothing on its own.

## What PayneSDD does about it

One short file of rules your agent follows. You keep writing requests in plain
words; the protocol does the formal part:

1. **It names the tricky spots and asks.** Before any plan the agent says what in
   your request contradicts itself, is missing or risky, asks the few questions
   that matter, and shows a plan for your "go". No code before it.
2. **"Done" is the machine's word.** Every task ends by running your real tests or
   build, with a map from each requirement to the check that proves it.
3. **The result gets attacked.** On risky work an independent reviewer subagent
   tries to break it; every finding needs a source or it is dropped.
4. **Long work stays cheap.** After the first build each change is checked by its
   own tests; the full check and the review run at check points, and nothing you
   asked for is dropped.

## Install

**Claude Code:** clone the repo to a permanent path and add one line to
`~/.claude/CLAUDE.md` (create the file if needed):

```
@/path/to/PayneSDD/DIGEST.md
```

That's it — every session follows the protocol; `git pull` updates it everywhere.
**Any other agent:** paste [`DIGEST.md`](DIGEST.md) into its system instructions.
**Upgrading from 1.x** (`git pull` does the protocol; these are yours):
- import `DIGEST.md` and delete any host line that points at `AGENT.md` (a config
  that imported or pasted `AGENT.md` whole must switch to `DIGEST.md`);
- remove a `payne-spec` command copy or link — the command is gone;
- a copied 1.x Stop-hook (`PAYNE_TEST_CMD`, `.payne-active`) is no longer
  maintained: delete it, or keep it at your own risk;
- a talk-level block in your config keeps working on its own; its pointer to
  «AGENT.md, TALK LEVEL» is stale;
- projects no longer keep `.payne/decisions.log`;
- dev mode in other projects needs `@/path/to/PayneSDD/MAINTAINING.md` in the host
  config next to the `DIGEST.md` line.

**Optional extras:** `/payne-review` (an independent break-it review on demand) —
copy or symlink `commands/payne-review.md` into `~/.claude/commands/`.
Maintainers: see [`MAINTAINING.md`](MAINTAINING.md).

## The cycle

| | |
|---|---|
| **Tier** | Trivial / Light / Full per task. Risky work — billing, auth, migrations, public output — is always Full. |
| **Contract** | Goal, what it must and must never do, decided edge cases, checkable criteria, what it is checked against — and the tricky spots, asked. |
| **Consent** | Light: one line "doing X — ok?". Full: one plan block with every irreversible act named. Nothing written before "yes". |
| **Machine check** | Tests / build / lint, each criterion mapped to its check. Never weakened to go green. |
| **Break it** | Light: the agent re-reads its own diff. Full: an independent reviewer. |
| **Verdict** | PASS / ITERATE / ESCALATE + Done / Remaining / Open questions. |

## Measured

On the local stand (claude-sonnet-5; 27 tasks, two runs per text, both texts in
one epoch; the acceptance rule and every definition in
[`benchmark/slim-2026-10-07.json`](benchmark/slim-2026-10-07.json), methodology in
[`benchmark/README.md`](benchmark/README.md)), 2.0.0's text against 1.0.1:

- **Quality:** passed the acceptance rule (worst measure: checks run, 38 of 42
  against 40, a gap random splits of that epoch reach in 88%); contradictions
  flagged in 8 of 8 against 8 of 8; nothing fabricated in 8 of 8 against 7.
- **Cost:** 0.56 of the input tokens (13.4M against 24.1M; uncached + cache
  writes + cache reads per model call, subagents included) in 0.63 of the mean
  wall time per run (100 s against 159 s).
- **Long work** (one 13-turn dialog, three runs each): nothing forgotten in any
  run; the manager held in 2 of 3 (one run ran 5 reviews where the bar is 4)
  against 3 of 3; about a quarter of the tokens and half the time.

What it does not show: one model only, two-turn tasks plus one dialog, the
noise of this comparison's token and time ratios not measured, and both texts
ran with the stand's host block (persona on, a plain-talk block), not the bare
install line.

## The personality is optional

`DIGEST.md` ends with Joe — a sardonic partner who pushes back on lazy specs.
Delete that section to drop him; the protocol works the same. The one rule baked
in: **attitude never replaces the work**.

## Maintaining

Changing the protocol itself: [`MAINTAINING.md`](MAINTAINING.md) — the decision
log, the independent review (`payne-quality`), measurement on the stand, release
rules, and the optional dev mode with `/payne-edit`.

## Status

**Actively used on real projects, and dogfooded.** Latest release: **v2.0.0**.

- **2.0.0** — one short protocol file: the whole protocol is `DIGEST.md` (~1.3k tokens) in place of a 3.1k-token digest plus a 16.7k-token full file (tiktoken o200k_base); on the stand, against 1.0.1 in one epoch of 27 tasks, it passed the acceptance rule, flagged contradictions as often (8 of 8 each), and used 0.56 of the input tokens in 0.63 of the mean time per run; in a 13-turn dialog it held the manager in 2 of 3 runs (1.0.1: 3 of 3) at about a quarter of the tokens and half the time (definitions in benchmark/slim-2026-10-07.json);
- **1.0.1** — a task closes with its verdict word again: 1.0.0's digest opened Step 6 with the Full manager sentence, and on the stand 1.0.0 closed with a verdict and summary in 21 of 44 runs against 0.9.8's 37 (as installed, 19bab52; REJECT by the acceptance rule); the fix brought it to 39 of 44 and passed against both; the same epoch did not show 1.0.0 cheaper or faster than 0.9.8 (1.34 of its input tokens, 1.13 of its mean wall time — inside the bar registered before the run, this comparison's own noise not measured; time noise not measured; definitions in benchmark/verdict-word-2026-10-06.json);
- **1.0.0** — a manager for work in progress, and Light on the digest: on Full, a later change comes back TESTS GREEN on its own tests, and the full check and the independent review run at check points and over everything unread when you say done; a change you dictate needs no «ok?»; a Light task runs on the digest and every Full task reads AGENT.md before its contract; on the stand its text before the last review fixes passed the acceptance rule against the installed protocol (19bab52) and used 0.78 of its input tokens in 0.80 of its mean wall time per run (the tokens inside the same-text noise measured after the run, the time's noise not measured; definitions in benchmark/check-manager-2026-10-06.json), the closing verdict came less often (29 of 44 runs against 36), most misses Light runs that wrote the summary headers without a verdict word, and in a 13-turn dialog the manager held in 3 of 3 runs;
- **0.9.8** — questions and warnings go in one closing block: everything waiting for the human ends the reply under a ❓ marker and repeats until answered, and only four kinds of warning get an ⚠️ line; on the stand every consent reply ended on its question, and the marker held in 3 of 3 once the Light example carried it;
- **0.9.7** — what a review misses beyond the ticket becomes required output: every contract opens with the repo's rule files read, the edge sweep is shown as a row with every category (who or what starts it, and setup failure, added), the review looks for the rule files itself and a Light self-pass ends with a lens row, and SDK work asks about a sibling platform first; the same rules as plain prose did not move the stand, on the stand the repo's rule was then kept in 5 of 5 runs of the large-repository trap (read after a check that did not pass as registered), while the sweep row did not appear and the subscription failure is still missed;
- **0.9.6** — a look-back before anything goes out: the plan names, for every act others will see — a release, deploy or upload, a tag, a pull request, a commit to a shared branch, a message — how the previous ones of its kind look from outside, where they were seen, and what differs; not measured on the stand;
- **0.9.5** — three token-economy rules, because every step re-reads the whole conversation: a check that would bring images or a long log goes to a helper subagent, a series of small look, timing or wording tweaks gets a build per tweak and the full gate and review once at its end, and a task closed in a long conversation ends with an offer of a fresh start; a no-regression stand epoch saw no gross drop and no saving is measured yet; three other candidate rules were tested and did not ship, and the contradiction measure no longer decides the stand's acceptance rule;
- **0.9.4** — no protocol rule changed: what shipped is the evidence behind one benchmark measure — the "found the contradiction" probe audited against blind labels, and two registered replacements for it rejected against a bar set before the run;
- **0.9.3** — a review describes the state it read, so a late commit gets read before PASS or a handover, changed lines no run reached, a module-wide search for a fixed defect's mechanism, a green bound to the exact artifact and environment it ran in, a gate that names a broken tool, and copies found by concept;
- **0.9.2** — a written rule for the release number, the README Status list checked by the gate, reading rules whose branches cover every result, protocol edits that must first search for the copies of what they change, 0.7.0 measured against 0.9.1 on the stand (no gross regression seen), and the stand's contradiction probe and start-up guards repaired;
- **0.9.1** — red proofs only where a revert undoes what they write, four inbox gaps closed (a transient spawn retry, fast questions with the depth choice, reading rules whose branches are shown reachable, the reason-line recipe), and the consent probe repaired against a blind read;
- **0.9.0** — widening a check named as a loosening, a published number carries its rule, the 27-task suite, and an acceptance threshold stated by its measured false-alarm rate;
- **0.8.0** — the talk level (`standard` / `plain`), the dev-mode gap inbox and its triage, ten protocol rules taken from real sessions, and a measured noise band that puts our own acceptance bar in question;
- **0.7.0** — loud disarm + behavior-tested Stop-hook (six red-proof mutants as a gate check), the no-subagent-host fallback (never PASS), digest-checking dev-mode review;
- **0.6.2** — check-edit consent asymmetry, red-proofed ratchets, both-direction drift, not-observed ≠ absent, named irreversible actions;
- **0.6.1** — the tautological-test audit, the read-your-decision-log rule, dependency-ordered questions;
- **0.6.0** — the tested always-on digest + measured token costs;
- **0.5.x** — the failure→contract ratchet, loop-safe enforced gate, CI on every push;
- **0.4.x** — testable `WHEN … SHALL` criteria, the criterion→check map, the simplicity rule.

Full history: [`CHANGELOG.md`](CHANGELOG.md).

## License

[MIT](LICENSE) © 2026 vlr-code
