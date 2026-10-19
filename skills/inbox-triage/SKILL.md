---
name: inbox-triage
description: >
  Interactive inbox sort: show how each capture will be filed, ask about ambiguous ones, then file.
  Triggers: "triage the inbox", "sort my notes", "clean up the inbox", "file my notes", "process the inbox".
---

## Vault Path Resolution

Read `Meta/vault-map.md` (always this literal path) to resolve folder paths. Its YAML frontmatter maps each role to a folder. Substitute **only** the tokens below. Leave other `{{...}}` patterns (`{{date}}`, `{{Name}}`, `{{ISO timestamp}}`) alone, they are placeholders.

If vault-map.md is absent, tell the user once ("No vault-map.md found, using default paths"), then use:

| Token | Default |
|-------|---------|
| `{{inbox}}` | `Inbox` |
| `{{daily}}` | `Daily` |
| `{{threads}}` | `Threads` |
| `{{commitments}}` | `Commitments` |
| `{{people}}` | `People` |
| `{{archive}}` | `Archive` |
| `{{meta}}` | `Meta` |

If vault-map.md exists but a role is missing, ask the user which folder to use before continuing.

The vault model (what each folder is for) is in `.platform/references/vault-model.md`. The rules every note follows are in `.platform/references/note-rules.md`. Read both when you are unsure where something goes or how to write it.

---

# Inbox Triage

Respond in the language the user writes in. Agent files are in English.

Use the sorter procedure and rules in `.platform/agents/sorter.md`, but interactive.

1. List unsorted captures in `{{inbox}}/` with counts. If none, say so and stop.
2. For each capture, show a proposed filing in one line per section: section, destination (daily, thread, commitment, person, new thread), and any `TBD`.
3. Ask only about ambiguous or new-thread items (use `AskUserQuestion`). File everything clear without asking.
4. File, move processed captures to `{{archive}}/captures/`, and set `status: filed`.
5. Report: filed items with links, task candidates (do not create them; offer `/braindump`-style confirmation for Sunsama), and anything left in the inbox.

Follow `.platform/references/note-rules.md`.
