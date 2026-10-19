# Getting started

## Install

1. Clone this repo (or your fork) inside your Obsidian vault folder, or anywhere, and pass `--target`:

```bash
cd /path/to/your-vault
git clone https://github.com/philiplinden/minions.git
cd minions
bash scripts/launchme.sh            # or: bash scripts/launchme.sh --target /path/to/vault
```

Needs `bash` and `jq`. On Windows, run it from Git Bash or WSL.

2. Open Claude Code in the vault folder and say **"initialize the vault"**. Setup is short: terms, the seven folders, a vault map, a profile. It then offers an optional interview (your tools, optional boundaries, active threads, how you dictate, how you use Claude).

3. Try **`/braindump`** and talk.

## What gets installed

```
your-vault/
├── .claude/             agents, skills, hooks, references, settings.json
├── CLAUDE.md            the dispatcher (Claude Code reads this)
├── AGENTS.md            pointer for other agent tools (created once, yours to edit)
├── .mcp.json            Gmail and Google Calendar connectors
└── Meta/
    ├── protocol.md      rules any Claude client can follow (refreshed on update)
    ├── vault-map.md     role -> folder names
    ├── user-profile.md  you, in your words
    └── scripts/         vault-stats, vault-inbox
```

## Updating

```bash
git pull
bash scripts/updateme.sh
```

## Other Claude clients

Claude desktop chat, the mobile app and claude.ai do not read `.claude/` or `CLAUDE.md`. They can still use the vault through a vault tool (an Obsidian MCP or filesystem connector) if you point them at `Meta/protocol.md`. The onboarding interview writes `Meta/client-setup.md` with the instructions for the surfaces you use. For phone dictation into the full setup, see [mobile-access.md](mobile-access.md).

## Postman (optional)

Gmail and Calendar access: see [gws-setup-guide.md](gws-setup-guide.md).
