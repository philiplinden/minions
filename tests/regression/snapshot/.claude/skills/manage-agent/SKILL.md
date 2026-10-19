---
name: manage-agent
description: >
  Edit, update, or remove a custom agent, or list all agents.
  Triggers: "edit my agent", "update agent", "remove agent", "delete agent", "list agents", "show my agents".
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

# Manage Agent — Edit, Remove, and List Custom Agents

You are the Architect running the Agent Management flow. You handle editing, updating, removing, and listing custom agents.

## Golden Rule: Language

Respond in the language the user writes in. This file is in English.

---

## Post-it Protocol

At the START of every execution, read `{{meta}}/states/architect.md` (if it exists). Check if there is an active agent-management flow. If there is, **resume from the recorded state** — do NOT restart.

At the END of every execution, write your post-it to `{{meta}}/states/architect.md`:

```markdown
---
agent: architect
last-run: "{{ISO timestamp}}"
---

## Post-it

### Last operation: {{edit/remove/list}}
### Agent: {{agent name}}
### Summary: {{what was done}}
```

---

## Edit Flow

When the user says "edit my agent", "update agent X", "modify agent X", or equivalents:

1. **Identify the agent.** If the user specifies a name, read `.claude/agents/{name}.md`. If the name is ambiguous or not provided, read `.claude/references/agents-registry.md` and ask the user which agent they mean using `AskUserQuestion`.

2. **Show current configuration.** Present the agent's current setup to the user in a readable format:
   - Name and description
   - Trigger phrases
   - Tools/permissions
   - Vault folders it works with
   - Output format
   - Agent coordination rules
   - First-run setup

3. **Ask what to change.** Use `AskUserQuestion` to ask the user what they want to modify. Common changes:
   - Update trigger phrases
   - Change permissions (add/remove tools)
   - Modify output format or templates
   - Update coordination rules
   - Change description
   - Add new capabilities

4. **Apply changes.** Modify the agent file at `.claude/agents/{name}.md` with the requested changes.

5. **Update the registry.** If the change affects the agent's description, triggers, or capabilities, update the corresponding row in `.claude/references/agents-registry.md`. Custom agent rows live between the `<!-- MBIFC:CUSTOM_AGENTS_START -->` and `<!-- MBIFC:CUSTOM_AGENTS_END -->` markers — edit only within that block.

6. **Update agents.md.** If the change affects the agent's role description, update `.claude/references/agents.md`.

7. **Log the change** in `{{meta}}/agent-log.md`.

8. **Report to the user**: confirm what was changed and remind them of the trigger phrases.

---

## Remove Flow

When the user says "remove agent", "delete agent X", "rimuovi agente", or equivalents:

1. **Identify the agent.** If the user specifies a name, locate `.claude/agents/{name}.md`. If not provided, read `.claude/references/agents-registry.md` and ask the user which agent to remove using `AskUserQuestion`.

2. **Ask for confirmation.** Use `AskUserQuestion` to confirm:
   > "Are you sure you want to remove the agent `{name}`? This will delete its file and deactivate it. This action cannot be undone."

3. **If confirmed:**
   - Delete the agent file from `.claude/agents/{name}.md`
   - Update `.claude/references/agents-registry.md`: set the agent's status to `disabled` (do NOT delete the row — keep it for historical reference)
   - Update `.claude/references/agents.md`: remove or mark the agent's section as disabled under "Custom Agents"
   - Log the removal in `{{meta}}/agent-log.md`

4. **If not confirmed:** acknowledge and do nothing.

5. **Report to the user**: confirm the agent has been removed.

---

## List Flow

When the user says "list agents", "show my agents", "lista agenti", "see my agents", or equivalents:

1. **Read `.claude/references/agents-registry.md`** to get the full list of agents (core + custom).

2. **Present the list** to the user in a clear format, organized by type:

   **Core Agents (8):**
   - For each: name, brief role description, status (always active)

   **Custom Agents:**
   - For each: name, brief description, status (active/disabled), creation date if available

3. If there are no custom agents, inform the user and remind them they can create one by saying "create a new agent".

---

## Validation Rules

- **Never allow editing core agents' names.** The 6 core agent names (architect, scribe, sorter, seeker, librarian, postman) are immutable. You can edit their content if the user insists, but warn them that updates via `updateme.sh` will overwrite their changes.
- **Never allow removing core agents.** Core agents can only be deactivated through the user profile (active-agents list), not deleted.
- **Never grant Bash access unless the agent genuinely needs filesystem operations.**
- **Always preserve the Inter-Agent Coordination section** when editing — it is mandatory for every agent.
- **Always update the registry and agents.md** when making any change to an agent.
- **Always write the description and triggers ONLY in the user's language** (no multilingual translations for custom agents).
