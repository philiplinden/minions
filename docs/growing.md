# Growing minions

minions starts small on purpose. This file is how it grows.

## Adding something new

- Say **"create a new agent"** (the `/create-agent` skill interviews you and writes the agent, registry row and log entry).
- For a skill (a conversational flow like `/braindump`), copy `skills/braindump/SKILL.md` as a starting point, add a row to the skill table in `DISPATCHER.md`, rebuild with `bash scripts/updateme.sh`. Keep descriptions short and in English.
- New note types: add the shape to `references/note-rules.md`.
- Run `bash tests/run.sh` before committing. It checks that the dispatcher and registry match what exists.

## Things that were removed and can come back

Everything below exists in the git history at the `pre-prune` tag. Restore a path with:

```bash
git checkout pre-prune -- <path>
```

then fix its vault paths (it assumes the old PARA folders) and add it to `DISPATCHER.md` and `references/agents-registry.md`.

| Capability | Paths | Notes |
|------------|-------|-------|
| Link analysis agent (connector) | `agents/connector.md`, `docs/agents/connector.md` | Wikilink and graph health. Needs MOC/area wording rewritten. |
| Audio and transcript processing | `agents/transcriber.md`, `skills/transcribe` | Meeting and lecture transcripts. |
| Email triage to notes | `skills/email-triage` | Needs postman changes too. Hey-specific parts removed. |
| Meeting prep, weekly agenda, deadline radar | `skills/meeting-prep`, `skills/weekly-agenda`, `skills/deadline-radar` | Built on postman. Sunsama may fit weekly planning better. |
| Contact sync | `skills/contact-sync` | Needs an `apple-contacts` MCP. |
| Deep structural cleanup | `skills/defrag`, `skills/deep-clean`, `skills/tag-garden` | Overlapped `/vault-audit`. Written for the PARA layout. |
| Hey mail support | `orchestra/hey-*`, `orchestra/tracker-*`, Hey sections of the old postman | Dropped. |
| Other platforms | `adapters/codex-cli`, `adapters/gemini-cli`, `adapters/opencode` | Dropped. Claude Code only. |
| Desktop notification hook | `hooks/notify.*` | Dropped. |
| Original postman (nine modes, Hey) | `agents/postman.md` at `pre-prune` | Replaced with a thin gws-only agent. |

## Ideas not built yet

Specialists per tool (Sunsama, Linear), each with its own scope of priorities, were discussed as the direction for custom agents. They are not built. Start with `/create-agent` once you know what each should own.
