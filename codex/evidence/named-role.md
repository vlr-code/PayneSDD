# Named reviewer registration — 2026-10-17

This corrects the installation gap documented in activation.json; that historical
evidence is retained unchanged. The first release successfully tested fallback
review, but did not finish native named-role registration.

## Diagnosis (exploratory, not a preregistered benchmark)

- Installed CLI: 0.163.0-alpha.10.2; ~/.codex/agents/payne-quality.toml resolves
  to codex/agents/payne-quality.toml; no agents table existed in config.toml.
- A direct named spawn in the desktop chat returned
  `agent type is currently not available` even though the role was listed.
- Fresh CLI with the existing user configuration, no --ignore-user-config,
  read-only sandbox, no fallback: same named-role failure.
- Same CLI/prompt with temporary overrides for agents.payne-quality.description
  and agents.payne-quality.config_file: the named child started and returned the
  exact reviewer duties, finding format, Copies / NOT CHECKED and SHIP / REVISE.
  The child was asked not to read files or use tools, and the parent did not pass
  the role instructions in its task. Thus this checks role instruction loading,
  not merely the child's ability to read the TOML file itself.
- The successful override probe was followed by the failing control probe.
  Both CLI processes exited 0: success of a CLI process alone does not prove
  success of its child. The result must include a completed named child.

This establishes that explicit registration fixes the tested CLI path. It does
not establish the internal cause of the discrepancy between catalog and launcher.
The supported registration is documented in the official
[configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference).

## Fix and acceptance criteria (before permanent installation)

- Register agents.payne-quality.config_file; preserve existing matching roles and
  unrelated settings, reject collisions and invalid TOML before modifying files.
- Back up config.toml and AGENTS.md; test rollback if the later write fails,
  idempotence and file mode preservation. Use a real TOML parser.
- Skills request the named role first; fallback remains available for other hosts.
- After installation require a fresh CLI named spawn without temporary overrides,
  fallback or copied reviewer instructions. Also try the desktop tool directly;
  a cached pre-install desktop session is reported separately, not called success.
- Independent review, then the native combined gate, on the final source state.

## Permanent-installation results

- Installer ran twice: first added the role; second made no further changes.
  config.toml retained all preceding bytes and mode 0600. Parsed config with just
  the added role removed equals the previous config. Backup:
  `~/.codex/payne-backups/c28af6660140c85b47d877a59769d009e5a536af51d329d82faaf3db63b0a8a3.config.toml`.
- Fresh CLI without any config overrides and without --ignore-user-config:
  named child `/root/named_persistent_probe` started, answered with the role's
  exact instructions and completed; no fallback or manual instruction copying.
  Record: [named-role-activation.json](named-role-activation.json).
- Repeated persistent confirmation saved raw JSONL plus parent/child session traces.
  Parent trace records spawn_agent with agent_type=payne-quality and a successful
  child receipt. Child session metadata records agent_role=payne-quality and
  agent_path=/root/named_saved_probe; the child made zero tool calls. The evidence
  includes paths and selected records; encrypted task payload is deliberately omitted.
- Existing desktop chat: direct named spawn still returned unavailable after
  writing config. A new ordinary child of this same desktop chat also could not
  spawn the named role. These contexts must not be called verified successes.
- Fresh desktop after application restart: NOT VERIFIED in this turn. The CLI
  result establishes the persisted configuration, not a reload of a live desktop
  process. The application was not restarted, to avoid interrupting other work.
- Installer tests: nine passed. All four new tests failed on their relevant
  temporary mutations: [named-role-red-proof.txt](named-role-red-proof.txt).
  Both skills passed the bundled skill validator.
- Independent source review before installation: SHIP. Final review and combined
  gate results are reported in the handover, after the source is frozen.

## Desktop after restart — confirmed

The user confirmed restarting the application on 2026-10-17. A direct
collaboration.spawn_agent call with agent_type=payne-quality and fork_turns=none
returned /root/named_role_after_restart. The named child completed and reported
the exact role duties, finding format, Copies / NOT CHECKED and SHIP / REVISE.
It did not read files or call tools; the parent did not copy role instructions
into the task and no fallback was used. This supersedes the pre-restart
NOT VERIFIED limitation above. See desktop_after_restart in
[named-role-activation.json](named-role-activation.json).
