# Maintaining the Codex instance

Scope: this `codex/` directory. The parent Claude instance is a separate product;
do not change its files, release numbers, commands, benchmarks or configuration
as a side effect. This instance starts from PayneSDD v2.0.2. Its adaptation number
is not a new upstream release. Read the parent's decision log when considering
an old rule change; a resembling rejected proposal must be raised with the user.
The known DIGEST §2/§7 tension is retained, not silently “fixed”.

1. Full contract and the maintainer's explicit consent before edits. Existing
   consent covers implementation and repairs within that agreed scope.
2. Append decisions to `codex/.payne/decisions.log`, one line:
   `<date> [APPROVED|REJECTED|DEVIATION] <task> — <reason>; evidence: <file>`.
3. Keep DIGEST.md between 3,000 and 7,000 bytes. Preserve the original nine steps.
   Cut before adding; justify a behavioral change with an observed failure.
4. Independent `payne-quality` review, at most three rounds per checkpoint;
   fixes get focused checks, then review of the fixes. Findings require a source.
   After a round without required fixes, run `bash codex/scripts/check.sh` alone
   from the repository root. No available independent reviewer → ESCALATE.
5. Before activation of changed behavior, compare original and adapted text on
   the same GPT runtime, with the reading rule fixed before runs. Record exact
   inputs, model, outcomes and limitations. A small smoke test is not statistical
   proof of quality or cost. Never relabel Claude's measurements as GPT results.
6. Installing or changing global Codex settings must be in the approved plan.
   Preserve unrelated settings and make a backup before replacement. Commits,
   push, tags and releases each require explicit authorization; no attribution
   trailers. Do not create a git worktree.

## Dev mode

The marker is `${CODEX_HOME:-~/.codex}/.payne-dev-mode`; its first line is the
absolute path to this `codex/` instance, not the parent Claude directory. The
installer enables it on first installation; repeat installation preserves on/off.
An explicit user instruction overrides marker state for the current session.
`$payne-edit` handles on/off/status/inbox. Toggle on/off only when requested.

When enabled, every Light/Full close includes one line per protocol gap (default
“none”), tagged 🔴/🟡/🟢 and tied to a source. Append each finding, without a separate
consent question, to `~/.payne/inbox.md` outside all repositories:
`<date> · <tag> · <project> · PayneSDD Codex adaptation 1 · <rule> · <observed gap> · fix: <proposal> · src: <CODEX_THREAD_ID>`.
Use the actual CODEX_THREAD_ID; if unavailable, write “unknown”. No credentials,
private project code, or invented session IDs. Respect filesystem approvals;
if writing is blocked, report the pending entry instead of claiming it was saved.
Inbox is shared and append-only. Editing the protocol still needs consent.
