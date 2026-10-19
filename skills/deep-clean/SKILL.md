---
name: deep-clean
description: >
  Thorough cleanup: a full vault audit plus stale and redundant content, naming, tags, duplicates, link repair.
  Use when the vault feels noisy. Triggers: "deep clean", "thorough cleanup", "the vault is a mess", "clean everything up".
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

# Deep Clean

Respond in the language the user writes in. Agent files are in English.

Run this when the vault has drifted. It is the heaviest pass; tell the user roughly how long it will take and that you will ask before anything irreversible.

1. **Baseline.** Run the `/vault-audit` checks first and keep the report path.
2. **Stale content.** Threads, commitments and people with no change in 6 months and `status` still active or open. Ask: archive, update, or keep.
3. **Redundant content.** Captures already filed but still in the inbox, empty or near-empty notes, notes that restate another note. Propose; do not delete. Move candidates to `{{archive}}/` after confirmation.
4. **Naming.** Files that break the naming rules. Rename and update every link to them in one step.
5. **Frontmatter.** Missing or invalid fields per note shape; unknown `type` or `status` values.
6. **Tags and aliases.** Run the `/tag-garden` checks and apply what the user confirms.
7. **Links.** Repair broken links when exactly one match exists. List the rest. Suggest the connector for orphans.
8. **Report** to `{{meta}}/health-reports/deep-clean-YYYY-MM-DD.md`: what changed, what is pending the user's decision, and the size of the vault before and after.

Follow `.platform/references/note-rules.md`. Never delete notes. Log what changed in `{{meta}}/agent-log.md`.
