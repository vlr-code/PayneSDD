# Maintaining PayneSDD

Rules for changing the protocol itself. They are not part of the protocol an agent
runs on a user's project — that is `DIGEST.md` alone.

## The protocol stays one short file
- `DIGEST.md` is the whole protocol; `AGENT.md` is only a pointer to it.
- The gate keeps it between 3,000 and 7,000 bytes. A rule earns its place by a
  measurement, not by an argument: 2.0.0 replaced ~83 KB of rules with ~5 KB,
  passed the stand's acceptance rule against 1.0.1 at 0.56 of the input tokens
  and 0.63 of the time, and held the manager in 2 of 3 dialog runs against 3 of 3
  (`benchmark/slim-2026-10-07.json`).
- Prefer cutting to adding. A new rule names the failure it fixes and the run
  that showed it.

## Every change to the protocol
1. Full tier: contract, plan, the maintainer's explicit yes before any edit.
2. A decision log in this repo: append one line per decision to
   `.payne/decisions.log` — `<date> [APPROVED|REJECTED|DEVIATION] <task> — <reason>`;
   results stay out of the line, it names the file that holds them. Read it at
   contract time: a resembling [REJECTED] goes back to the maintainer as a question.
3. The gate: `bash scripts/payne-check.sh` green on the state you hand over.
4. An independent review by the `payne-quality` agent (up to three rounds); a
   finding counts only with a source.
5. A change that alters what an agent does is measured on the local stand
   against the current release before it ships — same epoch, a reading rule
   written before the run (`benchmark/README.md`). Wording-only fixes skip it.
6. Commit, push, tag and release only on the maintainer's explicit yes.

## Releases
Fix commits are `fix: …`, decision-only commits `log: …`, and a release is its
own `release: X.Y.Z` commit that bumps the README badge, the README «Latest
release» line, a new top entry of the README Status list, the CHANGELOG heading
and the `PayneSDD vX.Y.Z` stamp in `DIGEST.md`; then an annotated tag `vX.Y.Z` and
a GitHub release titled «PayneSDD X.Y.Z — <what changed>» with the CHANGELOG entry
as notes. Number: a fix to the rules or docs is a patch; a new capability is a
minor; a change that drops a capability users relied on is a major. The
maintainer picks the number.

## Dev mode (optional)
These rules reach other projects only if your host config imports this file
(`@/path/to/PayneSDD/MAINTAINING.md` next to the `DIGEST.md` line) and
`commands/payne-edit.md` and `agents/payne-quality.md` are copied or symlinked into
`~/.claude/commands/` and `~/.claude/agents/`. On when
`~/.claude/.payne-dev-mode` exists (first line: this repo's path). Then
every Light/Full task ends with a one-line-per-item protocol-gap report (default
«none», each item tied to a source, tagged 🔴/🟡/🟢), and each item is appended as
one line to `~/.payne/inbox.md` (outside every repo, never committed, no secrets
or project code): `<date> · <tag> · <project> · PayneSDD v<version> · <the rule> ·
<what happened> · fix: <proposal> · src: <session id>`. `/payne-edit inbox`
triages it; `/payne-edit` runs a protocol change through the steps above.
