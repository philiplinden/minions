---
name: tag-garden
description: >
  Tend the vault's vocabulary: tags, `type` and `status` values, and aliases, so search finds things under the words the user actually uses.
  Triggers: "tag garden", "clean up tags", "tag audit", "fix the vocabulary", "aliases".
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

# Tag Garden

Respond in the language the user writes in. Agent files are in English.

Tags stay minimal in this vault; frontmatter `type` and `status` do most of the sorting. This pass keeps the vocabulary small and consistent, and makes sure things are findable by the user's own words.

1. **Inventory.** Collect all tags, `type` values, `status` values and `aliases` across the vault with counts.
2. **Problems.** Near-duplicates (`budget`/`budgets`, `todo`/`to-do`), one-off tags used once, tags that duplicate a folder or a `type`, unknown `type`/`status` values (valid ones are in note-rules), and inconsistent case.
3. **Aliases.** Read the glossary in `{{meta}}/user-profile.md` (the user's nicknames and terms). For each term, check that the matching thread, person or commitment has it in `aliases`. Propose additions so search finds the note under the way the user says it. Add only terms the user stated.
4. **Proposals.** Show merges and removals as a short table (from, to, notes affected). Ask once for the whole set, or item by item if the user prefers.
5. **Apply** the confirmed changes. Do not add new tags the user did not ask for.
6. **Report** the before and after counts.

Follow `.claude/references/note-rules.md`. Never delete notes. Log what changed in `{{meta}}/agent-log.md`.
