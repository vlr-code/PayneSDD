---
description: Dev mode — improve PayneSDD itself from any project, gate it, quality-review it, then commit/push (and release if asked) with your approval.
disable-model-invocation: true
---

# /payne-edit — change the PayneSDD protocol (dev mode)

Arguments: `on` / `off` / `status` toggle dev mode (the marker
`~/.claude/.payne-dev-mode`, first line = the repo path); `inbox` triages the gap
notes in `~/.payne/inbox.md`; anything else is the change to make.

The repo path is the marker's first line. Never touch the project you are working
in — only the PayneSDD repo. Follow MAINTAINING.md in that repo:

1. Read MAINTAINING.md and the decision log; a resembling [REJECTED] → ask first.
2. Full tier: contract, plan, the maintainer's explicit yes before any edit.
3. Make the change; keep DIGEST.md short — cut before you add.
4. `bash scripts/payne-check.sh` green.
5. Independent review: the `payne-quality` agent, up to three rounds; fix only
   findings with a source.
6. A change to what an agent does: measure it on the stand before it ships.
7. Show `git diff`; commit and push only on one explicit yes; a release only if
   asked (MAINTAINING.md, Releases).

`inbox`: read `~/.payne/inbox.md`, group the notes, propose which to take, and run
each taken one through the steps above. Never rewrite the file — it is shared.
