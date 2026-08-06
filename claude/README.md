# Claude Code configuration

Run `./config.sh` to install.

## What is tracked

| File | Purpose |
|---|---|
| `settings.json` | Template for `~/.claude/settings.json`. Uses `$HOME`, expanded at install time. |
| `config.sh` | Installer — renders settings, symlinks hooks, runs the herdr integration. |

## What is deliberately not tracked

**Secrets and history.** `~/.claude` holds `.credentials.json`, `history.jsonl`,
`projects/` (full session transcripts), and `shell-snapshots/`. This repo is
public. Never copy `~/.claude` wholesale into it.

**The teleclaude hooks.** `pre_tool_use.sh`, `stop.sh`, `user_prompt_submit.sh`,
`session_start.sh`, and `session_end.sh` live in the
[teleclaude](https://github.com/AlbertPhan88/teleclaude) repo under `scripts/`.
`config.sh` symlinks them into `~/.claude/hooks/` instead of copying, so there is
one source of truth. Same convention as `~/tools/tcc`.

**`herdr-agent-state.sh`.** Written by `herdr integration install claude` and
overwritten on every herdr update. `config.sh` runs that command rather than
tracking the file. It also re-adds herdr's own `SessionStart` entry to
`settings.json`, which is why the template omits it.

**Plugin state.** `plugins/installed_plugins.json` and `known_marketplaces.json`
are machine-specific (absolute paths, timestamps, commit SHAs). `config.sh`
prints the two commands to restore them instead.

## Notes

`config.sh` overwrites `settings.json` rather than merging, backing the old one
up to `settings.json.bak` first. Any local settings not in the template are in
that backup — fold them into the template so they survive the next run.
