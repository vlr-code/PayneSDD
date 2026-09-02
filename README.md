<div align="center" markdown="1">

<img src="assets/hero.png" alt="PayneSDD" width="100%">

# PayneSDD

### — "Payne, I can't feel the spec-driven development!"<br>— "That's because you don't have any. Yet."

[![License: MIT](https://img.shields.io/badge/License-MIT-orange.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.6.2-blue.svg)](CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-actively%20used-brightgreen.svg)](#status)

[![⬇ Download latest release](https://img.shields.io/badge/⬇_Download-latest_release-2ea44f?style=for-the-badge)](https://github.com/vlr-code/PayneSDD/releases/latest)

*An easy-going custom SDD protocol for agentic coding — the paperwork is the agent's problem, not yours.*

</div>

---

## The problem

You prompt → the agent codes → it says **"done"** → and now you either re-read
everything anyway, or play everyone's favorite game: ***Guess What Shipped!***
An agent's "done" means nothing on its own. That's the tax of vibe-coding:
speed up front, paid back as distrust.

## What PayneSDD does about it

One file of rules your agent actually follows. You keep writing requests the
way you always did — plain words, no specs, no plans. The protocol does the
formal part, and gives you three things a raw prompt doesn't:

1. **It asks you — not the other way around.** The agent maps the open
   decisions in your request, asks the few questions that actually matter,
   and shows one plan for your "go". A wrong assumption dies in a 30-second
   question — not in 200 lines you now have to unpick.
2. **"Done" is the machine's word, not the agent's.** Every task ends by
   running your real tests / build — and the optional Stop-hook makes a red
   check *physically* block "finished".
3. **An independent skeptic attacks every result.** A second agent with a
   "break it" brief — and every finding needs a source (a line, a test), or
   it's rejected.

The trade: about a minute of up-front agreement, in exchange for code you
don't re-read line by line — plus a committed one-line log of every decision.

## Install — one message, then it interviews you

**Paste this into Claude Code:**

> Install PayneSDD from https://github.com/vlr-code/PayneSDD. First ask me
> where to keep the clone (a permanent path — your config will point at it),
> clone there, read its AGENT.md and README — then run the installation itself
> as your first task under that protocol: ask me the remaining setup questions
> (which projects — all or specific ones; the ≈2.4k-token digest or the full
> file always-on; persona on or off; enforced Stop-hook or honor-system gate;
> dev mode — only if I maintain a PayneSDD clone, default off),
> show one plan, and touch only my config after my explicit "go" — apply my
> choices there, never by editing the cloned files, and remove nothing that's
> already in my config.

The protocol interviews you, you say "go", it installs itself. That's the
whole product in one demo: **the first task PayneSDD runs on is PayneSDD.**
Prefer your own hands? The manual version:

```bash
git clone https://github.com/vlr-code/PayneSDD.git
```

**Claude Code — recommended** (≈2.4k tokens always-on): paste these two lines
into `~/.claude/CLAUDE.md` — create the file if it doesn't exist, replace
`/path/to` with your absolute clone path, both lines go in literally:

```
@/path/to/PayneSDD/DIGEST.md
Full protocol: /path/to/PayneSDD/AGENT.md — the digest tells the agent when to read it.
```

[`DIGEST.md`](DIGEST.md) is the compressed floor of the protocol — on any real
task the agent reads the full file before writing the contract. `git pull` =
protocol updated everywhere.

**Any other agent** — paste [`AGENT.md`](AGENT.md) whole into the system
instructions (8.1k tokens always-on; the way to go for web chats and agents
without file access).

That's it. The agent follows the cycle automatically.

## The cycle

<div align="center" markdown="1">
<img src="assets/cycle.png" alt="PayneSDD — the cycle, Steps 0–6" width="100%">
</div>

| Step | What it enforces (full rules: [`AGENT.md`](AGENT.md)) |
|---|---|
| **0 — Classify** | **Trivial / Light / Full** per task. Risky work — auth, billing, migrations, public output — is *forced* to Full. A typo never pays full ceremony. |
| **1 — Contract** | Goal, non-goals, decided edge cases, testable criteria (`WHEN … the system SHALL …`) tied to a named source of truth. "Works correctly" is banned. |
| **1.5 — Interrogate** | An analyst maps the real decision forks; **you** pick how much to be asked. Costly-to-reverse choices are never guessed silently. |
| **1.6 — Approve** | A hard **STOP**. One plan block, an explicit "go" — before that, zero code. |
| **2 — Plan** | Sub-tasks, an iteration budget, escalation rules. Stuck ≠ loop forever. |
| **3 — Execute** | Exactly the contract — no gold-plating, no silent refactors, no second copy of anything. |
| **4 — Machine gate** | Every criterion mapped to the check that proves it. Red blocks "done". The check is never weakened to go green. |
| **5 — Adversarial** | A *different* agent tries to break the result. Findings without a source die. |
| **6 — Verdict** | **PASS / ITERATE / ESCALATE** + a Done / Remaining / Open-questions checklist. |

Across the whole cycle: the machine gate runs on Light **and** Full, and the
agent keeps a one-line decision log (`.payne/decisions.log`) — an audit trail
you don't have to re-read the chat for.

## Example: "add password reset to the login flow"

<div align="center" markdown="1">
<img src="assets/example.png" alt="Same task, two outcomes — without vs with PayneSDD" width="100%">
</div>

1. Auth → hard floor → **Full** tier, out loud.
2. Contract with testable criteria: *WHEN the reset link is older than 1 hour
   the system SHALL reject it*; *IF the email is unknown THEN respond
   identically — no account-enumeration leak*.
3. The analyst surfaces the real questions (token TTL? rate limit?); you
   answer as many as you choose.
4. One plan block → **"build it or revise?"** → you say go. Only now: code.
5. It builds the *minimum that meets the contract* — no speculative plugins
   you didn't ask for.
6. Two tests go red → it fixes the **cause**; the machine gate blocks "done"
   until green.
7. The skeptic finds an enumeration leak, tied to a line → fixed. A vague
   "feels insecure" with no source → rejected.
8. **PASS**, with the test log and a Done / Remaining / Open-questions
   checklist.

*Light tier — same gates, a fraction of the ceremony: open decisions listed
inline, a one-line "doing X — ok?", the same machine gate, a short self-review.*

## Token cost — measured

Numbers, not vibes (static: tiktoken `o200k_base`; live: real `claude -p`
calls, usage from the API's own JSON):

| Install | Always-on load | Measured Δ input per call |
|---|---:|---:|
| **Recommended:** [`DIGEST.md`](DIGEST.md) always-on, full protocol read per task | ≈2,360 tok | ≈ +2,254 tok |
| Classic: paste full [`AGENT.md`](AGENT.md) (protocol + persona) | 8,111 tok | ≈ +9,050 tok |
| [`ROLES.md`](ROLES.md) multi-agent overlay | read on demand | — |

The digest was live-tested against the full file (≈50 scored runs, scripted
scoring): it held **every safeguard** — never wrote code before consent on a
risky payments probe, asked before coding, answered trivial questions cheaply,
kept the persona. Run summary + caveats:
[`benchmark/token-tests-0.6.0.md`](benchmark/token-tests-0.6.0.md) ·
methodology: [`benchmark/README.md`](benchmark/README.md).

## Optional add-ons

The protocol in `AGENT.md` is self-contained. Everything else is opt-in:

| File | What it adds |
|---|---|
| [`DIGEST.md`](DIGEST.md) | The ≈2.4k-token always-on digest — can't silently drift from `AGENT.md` (checksum-checked) |
| [`hooks/payne-gate.sh`](hooks/payne-gate.sh) + [`hooks/payne-gate-core.sh`](hooks/payne-gate-core.sh) | The **enforced** gate: a Stop-hook that blocks "done" on red tests |
| [`templates/SPEC.template.md`](templates/SPEC.template.md) | A fixed contract skeleton for Step 1 |
| [`commands/payne-spec.md`](commands/payne-spec.md) · [`commands/payne-review.md`](commands/payne-review.md) | Slash commands: start a contract / run the adversarial review |
| [`commands/payne-edit.md`](commands/payne-edit.md) · [`agents/payne-quality.md`](agents/payne-quality.md) | Dev mode for maintainers (default OFF) + its independent reviewer |
| [`ROLES.md`](ROLES.md) | Multi-agent role overlay for LARGE tasks only |
| [`DEPLOYMENT.md`](DEPLOYMENT.md) | Variant installs: digest / minimal slim-core / zero-footprint — plus the full hook setup and where each add-on installs |

## The enforced gate, in one paragraph

Copy the two hook files, wire `PAYNE_TEST_CMD` to your real test command, and
`touch .payne-active` when you start a gated task — from then on a red test suite
**physically blocks** the agent from saying "finished" (up to 3 blocks, then
it releases with an explicit UNVERIFIED warning — the call goes back to you;
disarming the marker while red is allowed but announced to you as UNVERIFIED —
a tripwire, not a lock).
Full setup, honest caveats, and a zero-install `/goal` variant:
[`DEPLOYMENT.md`](DEPLOYMENT.md#enforced-stop-hook-setup-claude-code).

## The personality is optional

`AGENT.md` ships with Joe — a sardonic, uncensored partner who pushes back on
lazy specs. Flavor, not substance: strip it or swap it, the protocol works
identically. The one rule baked in: **attitude never replaces the work**.

> *Yes, "Payne" is a pun. But this is the opposite of fix-it-when-it-hurts:
> the whole point is to feel the pain at spec time, not in production.*

## Status

**Actively used on real projects, and dogfooded** — PayneSDD develops itself
under its own protocol: every change runs the full cycle and an independent
review before it ships. Latest release: **v0.6.2**.

- **0.6.2** — check-edit consent asymmetry, red-proofed ratchets, both-direction drift, not-observed ≠ absent, named irreversible actions;
- **0.6.1** — the tautological-test audit, the read-your-decision-log rule, dependency-ordered questions;
- **0.6.0** — the tested always-on digest + measured token costs (this README's table);
- **0.5.x** — the failure→contract ratchet, loop-safe enforced gate, CI on every push;
- **0.4.x** — testable `WHEN … SHALL` criteria, the criterion→check map, the simplicity rule.

Full history: [`CHANGELOG.md`](CHANGELOG.md). After an install or a big
protocol change, run the fixed sanity task in
[`benchmark/README.md`](benchmark/README.md). Use it, break it, file what
doesn't hold.

## License

[MIT](LICENSE) © 2026 vlr-code
