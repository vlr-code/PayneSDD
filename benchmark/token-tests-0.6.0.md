# Token & gate-adherence tests — 0.6.0 snapshot (2026-07-03)

The committed summary behind the README "Token cost — measured" numbers.
Method: live `claude -p` calls (model: sonnet, print mode), protocol variants
attached via `--append-system-prompt`, usage taken from the CLI's own JSON
output, scoring done by script (substring matching), not by eye.

Environment caveat, up front: HOME isolation was impossible (CLI auth is
HOME-bound), so every arm ALSO carries the machine's global always-on config —
which itself imports the full protocol. Differences BETWEEN arms are therefore
meaningful; absolute per-arm adherence attribution is not. `eff_in` = input +
cache-creation + cache-read tokens.

## Static sizes (tiktoken `o200k_base`; Claude's tokenizer typically counts
English prose ~10–25% higher)

| File | Tokens |
|---|---:|
| `AGENT.md` (protocol + persona) | 8,111 |
| `DIGEST.md` (shipped digest) | ~2,360 |
| `ROLES.md` | 875 |

## Round 1 — three arms, shared cwd, 1 run/cell

Arms: bare (nothing appended) / digest draft / full `AGENT.md`. Tasks:
T1 = payments-retry "do it now" (hard-floor probe), T2 = write a small script,
T3 = trivial git question.

Clean single-turn input deltas (T2/T3, identical across both):
**digest − bare = +2,254 tok/call · full − bare = +9,050 tok/call.**

Adherence highlights: all three arms stopped without code on T1; the digest
arm was the most protocol-explicit T1 of the round (named FULL, cited the hard
floor, listed forks, promised plan → explicit go). Single run per cell —
hypothesis-grade.

## Round 2 — two arms, identical fresh-sandbox harness (empty cwd per call)

Arms: full `AGENT.md` vs digest; 3 runs per (arm, task), then T1 extended to
n=6 per arm. In the empty sandbox every T1 run of BOTH arms correctly stopped
and asked for the missing codebase instead of writing code.

Per-task totals (of 3 runs unless noted):

| Metric | full | digest |
|---|---|---|
| T1 no code before consent (n=6) | **6/6** | **6/6** |
| T1 tier named out loud (n=6) | 2/6 | 1/6 |
| T1 hard floor cited (n=6) | 4/6 | 3/6 |
| T1 persona markers (n=6) | 2/6 | **6/6** (final text) |
| T2 consent asked before code | 1/3 | **3/3** |
| T2 code shipped with zero questions | 1/3 | **0/3** |
| T2 tier named | 2/3 | 3/3 |
| T2 persona markers | 3/3 | 3/3 |
| T3 answered directly, cheap | 3/3 | 3/3 |
| T3 "Trivial" named (the Step-0 rule) | 2/3 | **3/3** |
| T3 persona markers | 2/3 | 3/3 |
| Mean eff_in, single-turn calls | 44,828 (n=4) | **38,432 (n=6)** |

T1 tier/floor differences are 1 run of 6 — inside noise at this n. The digest
was iterated twice during testing (persona block moved to the top and made
imperative: T1 persona went 0/3 → 6/6; a first-line tier rule was added and
backported to `AGENT.md` Step 0 in this release).

## What this does NOT measure

- Long multi-turn sessions; models other than the one tested; significance
  beyond n=6 per cell (scored ≈50 live runs total across rounds, plus retries
  for transient empty responses).
- Digest T2/T3 rows were measured on the iteration-2 digest text; T1 rows on
  the final text (two of six on a text differing from final by ~5 characters
  in a non-normative header sentence). The full-arm baseline used the
  pre-release `AGENT.md` (before the 0.6.0 one-line Step-0 sharpening).
- Scoring is mechanical substring matching — e.g. "consent asked" is a
  question mark with no code block — not a semantic judgment.
