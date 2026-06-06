# Deploying PayneSDD on a token-metered / always-on agent

`AGENT.md` is written to be pasted whole into a per-task tool (Claude Code, an IDE
assistant) where the cost of carrying the full protocol is paid once per task and
nobody cares. On an **always-on, token-metered agent** — a chat bot, a Telegram
assistant, anything billed per message — that math flips: the whole of `AGENT.md`
(~4.8k words ≈ 7–8k tokens — plus the persona and `ROLES.md` if you pasted them)
rides in **every** message, including the 90% that are plain chat (Trivial), where
no protocol runs at all. You pay for discipline you aren't using.

This guide is the pattern that fixes it without losing any capability:
**slim-core always loaded, full protocol on demand.** It is optional — if your
agent isn't token-metered, ignore this and paste `AGENT.md` whole.

## The idea: tier-aware LOADING, not just tier-aware behavior

Step 0 already classifies every task Trivial / Light / Full. Extend that split to
what you load:

- **Trivial (most chat)** → carry only a tiny *slim core*. Pay ~0 protocol tokens.
- **Light / Full (a real task)** → the agent pulls the full protocol on demand
  and runs it.

Most messages never touch the heavy machinery, so the idle context stays small;
the full discipline is one file-read away the moment a real task appears.

## What goes where

| Piece | Where it lives | Loaded |
|---|---|---|
| **Persona** (optional) | your host's persona file(s) | always (it's cheap, and it's the voice) |
| **Slim core** — Step 0 tiers + the two persona-honesty safeguards + a pointer | the host's always-loaded instructions | always (~0.4k tokens) |
| **Full protocol** — Steps 1–6, the decision log | a separate file (e.g. `payne-protocol.md`) | on demand — read only when Step 0 says Light/Full |
| **Dev mode** | omit | only if this agent maintains PayneSDD itself |

### The slim core (always loaded)

Keep it to the classifier, the floor, and the hand-off. Something like:

```
Classify the task (Step 0), then run that tier:
- TRIVIAL — chat / a question / no real code or external claim → just answer.
- LIGHT / FULL — a real change, or anything on the hard floor (billing, retries,
  concurrency, migrations, security/auth, public output, an SDK/library, infra,
  data-loss, work shared across agents/humans — non-exhaustive; full list in
  payne-protocol.md). When unsure, bump up.
If LIGHT or FULL → READ `payne-protocol.md` and follow it (contract → consent
before code → machine gate → break-it check → verdict). Don't run it on Trivial.
Holds in EVERY tier: a complete honest answer stands on its own; never invent a
fact — tie it to a source or say "I don't know".
```

Those last two lines are the **persona-honesty safeguards** — a complete honest
answer, and never invent a fact (`AGENT.md` RULES). They don't relax with the
tier, and they keep a "load it later" agent honest even on Trivial chat. The
protocol's *other* guarantees — the machine gate runs on every Light/Full, consent
before code is never skipped — aren't in the slim core; they ride in via the
hand-off to `payne-protocol.md`.

### The on-demand file (`payne-protocol.md`)

This is `AGENT.md` with the persona block and the dev-mode section stripped out —
just Steps 0–6, the decision log, and "what you never do". The slim core's only
job is to make the agent actually read it at the right moment.

## Caveats — where this bites if you're sloppy

- **The hand-off must fire.** If the slim core doesn't tell the agent to read the
  full file on Light/Full, you get tier classification with no protocol behind it.
  Test it: give the agent a real change and confirm it produces a contract and
  *stops for consent before writing code*.
- **Map the machine gate to the host's real check.** "Run tests / lint / build"
  means the host's actual build (e.g. `xcodebuild` for an iOS project, the
  project's runner for web). A green build is necessary, not sufficient — a
  smoke-launch still counts (Step 4).
- **No enforced Stop-hook off Claude Code?** Then the gate is honor-system — the
  agent must actually run it every time, not just claim it. State this in the
  on-demand file so it's not forgotten.
- **Persona dose still scales with the tier** (`AGENT.md` RULES): full voice on
  Trivial chat, a thin layer on real work. Loading less protocol doesn't change
  that — it's the same rule.

## Does it actually stay lean?

Yes — that's the whole point. The full protocol contributes **zero** tokens to a
Trivial turn because it isn't in context until the agent reads it. Measure your
host's per-message input before and after on a *fresh* session (history inflates
live numbers); the slim core should add only a few hundred tokens to the idle
baseline while keeping the entire protocol one read away.
