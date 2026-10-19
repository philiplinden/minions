---
name: defrag
description: >
  Weekly tidy: keep threads short enough to scan, archive what is done, merge duplicates, flag stale status.
  Triggers: "defrag", "tidy the vault", "weekly tidy", "clean up the threads", "reduce the noise".
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

# Defrag

Respond in the language the user writes in. Agent files are in English.

The goal is signal over noise: when the user (or Claude) looks something up, the first thing found should be the current, correct thing. Work in these phases. Ask before anything that merges, moves or condenses; apply the obvious and reversible ones.

1. **Inbox hygiene.** List unsorted captures. Offer to run `/inbox-triage` if there are any older than 3 days.
2. **Done work out of the way.** Threads with `status: done` and commitments with `status: done` or `dropped` move to `{{archive}}/` (keep the note as is, update links).
3. **Long logs.** For any thread whose `## Log` has grown past about 40 entries, move entries older than 90 days to `{{archive}}/threads/<slug>-log-<year>.md` unchanged, and leave in the thread a one-line `Older log: [[...]]` pointer and a short `## History summary` written from those entries and labeled `inferred` unless the user confirms it. This keeps logs append-only (nothing is rewritten, only relocated).
4. **Stale status.** List active threads whose `status-as-of` is older than 30 days. Ask the user about each one in turn (still true / changed / done) and update `Current state` and the date from their answer only.
5. **Duplicates.** Threads, people or commitments that look like the same thing. Show the pair and ask before merging; a merge keeps both logs in date order and leaves a redirect line in the old note.
6. **Naming and shape.** Fix file names and frontmatter that break the naming rules or note shapes in note-rules when the fix is unambiguous.
7. **Links.** Suggest the connector if you saw many orphans or missing links.
8. **Report.** What moved, what merged, what is waiting for the user's answer. Lead with the three changes that most improve findability.

Follow `.platform/references/note-rules.md`. Never delete notes. Log what changed in `{{meta}}/agent-log.md`.
