# Measured findings — what the benchmark taught us (July 2026)

Plain-language summary of what we learned by running PayneSDD, older PayneSDD
versions, and competing spec-driven protocols (GitHub Spec Kit, OpenSpec, as
verbatim-prompt approximations) through one harness. Methodology and its
pre-committed anti-inflation rules: [README.md](README.md). Key numbers:
[findings-2026-07.json](findings-2026-07.json). Model epochs: one on
claude-sonnet-4-6, three on claude-haiku-4-5. Cells ran n=3–5 — read every
number as a direction, not a decimal.

## 1. The new version really is better — and now that's measured, not felt
v0.6.0 vs v0.5.1 on identical tasks: 7 dimensions improved, 0 regressed.
On the security task v0.6.0 held consent-before-code 3/3 where v0.5.1 went
0/3 — and v0.5.1 shipped one solution that crashed at runtime (its own gate
missed it). The digest also used less context on 7 of 8 tasks.

## 2. Competitors ship prescriptions, not behavior
Spec Kit's templates literally prescribe tests; measured verification stayed
at cheap-prompt level (6/12 runs vs our 11/12 on the sonnet epoch). Across
every protocol-neutral cell of that epoch, neither Spec Kit nor OpenSpec
beat the protocol once. On the blind suite Spec Kit also burned ~1.9× the
tokens of a naked agent; the PayneSDD digest ran ~1.2% over naked-agent cost.

## 3. The persona block is load-bearing
Removing "Joe" (≈240 always-on tokens) halved discipline (aggregate 56 → 28)
at identical task outcomes. The voice is not decoration: on a weak model, the
identity frame carries the rule-following.

## 4. On weak models, discipline is a zero-sum budget
Three experiments, one law. Fatten the digest by 8% — every discipline
metric drops. Cut it by 10% (the persona) — every discipline metric drops.
Sharpen ONE imperative — that gate improves (+8 runs) while its neighbors
sink (−8, −5). You cannot word discipline up on a haiku-class model; you can
only move it around. Scope clarifications are the one safe move: no drop
beyond noise, but tiny gains.

## 5. The real bottleneck is the act of asking (finding + inference)
Measured: a tier-boundary clarification nudged tier awareness up (36→38 of 50
runs named it) while the consent question barely moved (13→14 of 35). Our
inference from that gap: knowing a rule and executing it are different
failures, so on weak models reliable consent/gate enforcement is the
Stop-hook's job — not better prose. (See DEPLOYMENT.md: the digest floor is
validated on Sonnet-class models; below that, import the full AGENT.md or
arm the enforced Stop-hook.)

## 6. Nobody catches latent contradictions
A task whose seed data makes two stated rules collide (a 7-item order vs a
hard 5-per-sheet limit): 0 of 15 runs across five different arms noticed —
including ours, which called the task "trivial, no ambiguities". A blind
spot shared by every arm we tested — and it now has a measuring stick.

## What this changes for PayneSDD
- Protocol wording changes ship only through the harness: pre-registered
  thresholds, every dimension watched. Three of our own candidate edits were
  rejected exactly this way — the harness does not care who wrote the patch.
- The harness itself (tasks, runner, scoring) lives git-ignored in
  `benchmark/local/`; runs are work, not history. This page cites only the
  committed snapshot beside it.

Honesty note: task suites are blind-generated, but the harness and probes are
ours; competitor arms are prompt-payload approximations, not native installs;
n is small. Each run report carries a mandatory "what this does NOT measure"
section — this page inherits all of those caveats.
