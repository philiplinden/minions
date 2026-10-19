# minions

A small Claude Code setup for an Obsidian vault. You dictate or type; Claude files it into long-running threads, commitments and people, and keeps a dated log. Tasks stay in Sunsama.

It is a personal fork of [gnekt/My-Brain-Is-Full-Crew](https://github.com/gnekt/My-Brain-Is-Full-Crew), pruned down and reshaped for one person's workflow. The agent/skill/dispatcher machinery and the installer come from upstream (MIT, see `LICENSE`). The note rules are adapted from [eugeniughelbur/obsidian-second-brain](https://github.com/eugeniughelbur/obsidian-second-brain/blob/main/AI-FIRST.md).

Status: first pass. The structure is in place; the pieces have not had long use.

## The idea

Keeping a note system tidy takes time that busy weeks don't have, and the system then falls apart. Here the user only talks. Claude does the filing, and keeps enough history that a later session can follow the thinking without being re-told.

Three things to know:

- **Flat vault.** Seven folders: `Inbox`, `Daily`, `Threads`, `Commitments`, `People`, `Archive`, `Meta`. No PARA tree, no maps of content, no template folder.
- **Rules for notes.** What the user said is marked as stated and Claude's reading as inferred. Unknowns are `TBD`. Logs are append-only. Each thread has a "current state" with an as-of date. See [`references/note-rules.md`](references/note-rules.md).
- **Tasks live in Sunsama.** Notes reference them. Claude lists task candidates and creates them only after confirmation. Work lives in other systems and is kept out.

## Use

| Say | What happens |
|-----|--------------|
| `/braindump` | Dictate. Claude captures, files notes automatically, lists task candidates, asks before sending anything to Sunsama. |
| "save this" | The scribe writes a capture to `Inbox/`. |
| "sort the inbox" / `/inbox-triage` | Files captures into daily notes, threads, commitments, people. |
| "what's the status of the 401k rollover?" | The seeker answers from the thread note and says how old the status is. |
| "check the vault" / `/vault-audit` | Broken links, stale threads, overdue commitments, duplicates. |
| "initialize the vault" | Short setup, then an optional interview. |
| "create a new agent" | Adds a custom agent. |

Agents: architect, scribe, sorter, seeker, librarian, postman (a thin Gmail/Calendar layer over `gws`). Skills: braindump, onboarding, inbox-triage, vault-audit, create-agent, manage-agent. The dispatcher is [`DISPATCHER.md`](DISPATCHER.md) (installed as `CLAUDE.md`).

## Install

```bash
cd /path/to/your-vault
git clone https://github.com/philiplinden/minions.git
cd minions
bash scripts/launchme.sh
```

Needs `bash` and `jq` (on Windows, Git Bash or WSL). Then open Claude Code in the vault folder and say "initialize the vault". Update later with `git pull && bash scripts/updateme.sh`. Details in [`docs/getting-started.md`](docs/getting-started.md).

## Other Claude clients

Agents, skills, hooks and `CLAUDE.md` work in Claude Code only. Other clients (desktop chat, mobile app, claude.ai, other agent tools) can still read and add to the vault through a vault tool such as an Obsidian MCP server or a filesystem connector. The installer puts a plain-markdown `Meta/protocol.md` and a vault-root `AGENTS.md` in the vault for them; the onboarding interview asks how you use Claude and writes `Meta/client-setup.md` for your setup. Phone dictation into the full setup can go through Claude Code Remote Control ([`docs/mobile-access.md`](docs/mobile-access.md)), which relies on upstream's documentation and has not been tested here.

## Growing it

See [`docs/growing.md`](docs/growing.md): how to add skills and agents, and a table of what was removed from upstream with the command to restore each (`git checkout pre-prune -- <path>`).

## Layout

```
agents/       six agents
skills/       six skills
references/   vault-model, note-rules, registry, orchestration, agent template
vault/        files copied into the vault (protocol.md, AGENTS.md)
hooks/        protect system files, validate frontmatter
orchestra/    vault-stats, vault-inbox
adapters/     builds the Claude Code output
scripts/      launchme.sh, updateme.sh, build.sh
mcp/          Gmail and Google Calendar connector definitions
tests/        bash tests and a build snapshot
```

## License and terms

MIT, copyright upstream author (see `LICENSE`). `TERMS_OF_USE.md` and `docs/DISCLAIMERS.md` are inherited from upstream and have not been revised for this fork. The onboarding still presents the terms summary.
