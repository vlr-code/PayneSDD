<div align="center" markdown="1">

<img src="assets/hero.png" alt="PayneSDD" width="100%">

# PayneSDD

### — "Payne, I can't feel the spec-driven development!"<br>— "Good. That means it's working."

[![License: MIT](https://img.shields.io/badge/License-MIT-orange.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-early%20%C2%B7%20not%20battle--tested-yellow.svg)](#status)

[![⬇ Download latest release](https://img.shields.io/badge/⬇_Download-latest_release-2ea44f?style=for-the-badge)](https://github.com/vlr-code/PayneSDD/releases/latest)

*A drop-in operating protocol that turns an AI coding agent from*
*"describe → it does it → you eyeball it → ship"* *into a verifiable cycle.*

</div>

---

## What it is

PayneSDD is a single operating protocol you paste into your agent's system
instructions. It takes plain Spec-Driven Development and adds the parts SDD
leaves out: a **consent gate** before any code, an **enforced machine gate** on
"done", and an **independent break-it review** — plus an optional drill-sergeant
persona that refuses to accept a lazy spec.

```
contract → interrogate & pick depth → plan-approval STOP → machine gate → adversarial check → verdict
```

The core idea: **"the agent said so" is not proof** — neither when it generates
nor when it critiques. The arbiters are an objective machine gate and a
tie-to-source rule for every LLM finding. PayneSDD just makes those two arbiters
mandatory steps.

## The cycle

| Step | What it enforces |
|---|---|
| **0** | Decide if the task even needs the full cycle (trivial → just do it). |
| **1** | Write the **contract** (behavior + verifiable acceptance criteria) before code. |
| **1.5** | **Interrogate**: an analyst subagent maps the real forks; *you* pick depth (fast / normal / thorough); ask exactly that many questions. |
| **1.6** | **Plan-approval STOP**: answers ≠ approval. Show the assembled plan, wait for an explicit "go". |
| **2** | Plan, budget, escalation rules. |
| **3** | Execute strictly per the contract. |
| **4** | **Machine gate**: "done" is confirmed by tests / typecheck / lint — or a deterministic source-of-truth check — not by eyeballing. |
| **5** | **Adversarial**: an independent "break it" pass; every finding must be tied to a source or it's rejected. |
| **6** | **Verdict**: PASS / ITERATE / ESCALATE, with evidence. |

## Install

Paste [`AGENT.md`](AGENT.md) into your agent's system instructions:

- **Claude Code** → `CLAUDE.md` at the repo root.
- **Other agents** (Cursor, Cline, custom) → "custom instructions" / system prompt.

That's it — the agent then follows the protocol automatically.

## Optional add-ons

The protocol in `AGENT.md` is self-contained. These are opt-in:

| File | What it adds | When |
|---|---|---|
| [`templates/SPEC.template.md`](templates/SPEC.template.md) | A fixed contract skeleton for Step 1 | Always handy |
| [`commands/payne-spec.md`](commands/payne-spec.md) | Slash command: start a contract from the template | Claude Code |
| [`commands/payne-review.md`](commands/payne-review.md) | Slash command: run the adversarial review | Claude Code |
| [`hooks/payne-gate-core.sh`](hooks/payne-gate-core.sh) | Portable gate engine — runs your test command, red = exit 1 | Any agent |
| [`hooks/payne-gate.sh`](hooks/payne-gate.sh) | Claude Code Stop-hook; blocks "done" on red tests when a spec is active | Claude Code |
| [`ROLES.md`](ROLES.md) | Multi-agent overlay (Analyst→Product→Architect→Scrum Master→Developer→QA) on Steps 0–6 | LARGE tasks only |

### Enable the enforced gate (Claude Code)

```bash
chmod +x hooks/payne-gate.sh hooks/payne-gate-core.sh
```

```jsonc
// .claude/settings.json
{
  "env": { "PAYNE_TEST_CMD": "npm test" },
  "hooks": {
    "Stop": [
      { "hooks": [ { "type": "command",
                     "command": "$CLAUDE_PROJECT_DIR/hooks/payne-gate.sh" } ] }
    ]
  }
}
```

Per task: `touch .payne-active` when a spec is in play, `rm .payne-active` when
done. With the marker present, a red `PAYNE_TEST_CMD` blocks the agent from
finishing; with no marker the gate stays silent (trivial tasks aren't punished).

**Portability, honestly:** the *enforcement* (auto-block on stop) is Claude-Code
only. On other agents run `hooks/payne-gate-core.sh` directly — same red/green
logic, but on-request, not blocking. The lock is loosened, not removed.

## A 60-second walk-through

1. You: *"add a retry helper with backoff"*
2. Agent classifies it (Step 0: important), then `/payne-spec retry` drafts a
   `SPEC.md` with verifiable acceptance criteria.
3. **Step 1.5** — an analyst subagent lists the real forks; you pick depth; the
   agent asks exactly that many questions.
4. **Step 1.6** — the agent shows ONE plan block and asks *"build it or revise?"*
   — then stops. Your answers were raw material, not approval.
5. You say "go". Agent writes code, `touch .payne-active`, runs the gate.
6. Tests red → the Stop-hook **blocks finishing**; the agent fixes the cause.
7. `/payne-review` runs an independent break-it subagent; only source-tied
   findings get fixed.
8. Gate green + findings adjudicated → **PASS**, with evidence.

## The personality is optional

`AGENT.md` ships with an optional drill-instructor persona — a harsh, sardonic
mentor that pushes back on lazy specs. It's flavor, not substance: strip it, swap
your own, or keep it; the protocol works identically. The rule baked into the
persona: **attitude never replaces the work** — the gate still runs, facts are
never invented, escalation stays honest.

> *Yes, "Payne" is a pun. But this is the opposite of fix-it-when-it-hurts:
> the whole point is to feel the pain at spec time, not in production.*

## Status

**v0.1.0 — first public release.** Honest status: this is a strong, opinionated
protocol, **not yet a battle-tested product** — no production mileage behind it.
Use it, break it, file what doesn't hold. See [`CHANGELOG.md`](CHANGELOG.md).

## License

[MIT](LICENSE) © 2026 vlr-code
