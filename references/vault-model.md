# Vault Model

The vault is flat on purpose. Seven folders, no more. Claude files everything; the user does not maintain structure by hand. Folder names are resolved through `Meta/vault-map.md`.

| Role | Default folder | What lives there |
|------|----------------|------------------|
| `{{inbox}}` | `Inbox/` | Raw captures (dictation, pasted text) waiting to be filed. One file per capture. |
| `{{daily}}` | `Daily/` | One note per day, `YYYY-MM-DD.md`. An append-only log of what happened and what was said that day. |
| `{{threads}}` | `Threads/` | One note per long-running matter (401k rollover, car and insurance, budget, home server). Holds current state plus a dated log. |
| `{{commitments}}` | `Commitments/` | Things the user owes someone else: a person, a thing, and a due date. One note each. |
| `{{people}}` | `People/` | One note per person, for relationship context. |
| `{{archive}}` | `Archive/` | Finished threads and commitments, and processed captures (`Archive/captures/`). Nothing is deleted. |
| `{{meta}}` | `Meta/` | `vault-map.md`, `user-profile.md`, `agent-log.md`, `states/` (agent post-its), `health-reports/`, `scripts/`. |

## Where does X go?

- "I talked to the insurance company today and they need the VIN" → today's daily entry, the `car-insurance` thread's log, and the `People/` note if the person matters.
- "I need to send Sam the budget draft by Friday" → `Commitments/send-sam-budget-draft.md` (links to Sam and the budget thread). The to-do itself is for Sunsama.
- "The 401k rollover is waiting on the old provider" → `Threads/401k-rollover.md`, update `status` and `Current state` (the user said it).
- Anything unclear stays in the inbox until the user confirms.

## Not in this vault

- **Tasks.** They live in Sunsama. Notes reference a task by name; they do not copy task lists.
- **Work-system content.** The user's work lives in separate work systems. What counts as work is recorded in the boundary section of `Meta/user-profile.md`.

## Changing the model

Only the architect changes this file, and only with the user's approval.
