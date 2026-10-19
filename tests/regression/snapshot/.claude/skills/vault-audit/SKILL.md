---
name: vault-audit
description: >
  Run the librarian's checks and walk the user through fixes.
  Triggers: "vault audit", "check the vault", "vault health", "full audit", "clean up the vault".
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

The vault model (what each folder is for) is in `.claude/references/vault-model.md`. The rules every note follows are in `.claude/references/note-rules.md`. Read both when you are unsure where something goes or how to write it.

---

# Vault Audit

Respond in the language the user writes in. Agent files are in English.

Run the full audit from `.claude/agents/librarian.md`:

1. Scan: inbox backlog, frontmatter, broken links and orphans, stale threads, overdue commitments, duplicates, rule violations.
2. Write the report to `{{meta}}/health-reports/YYYY-MM-DD.md`. Lead with the number of problems and the three that matter most.
3. Apply only the unambiguous, reversible fixes. For each other problem, ask the user what to do (`AskUserQuestion`), one problem at a time, most important first.
4. Never delete notes. Merge duplicates only on confirmation.
5. Log changes in `{{meta}}/agent-log.md`. Tell the user the report path and what is still open.

Follow `.claude/references/note-rules.md`.
