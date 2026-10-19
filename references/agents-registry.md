# Agent Registry

This file is the **single source of truth** for all active agents. The dispatcher (`DISPATCHER.md`) and all agents reference this file for routing decisions and inter-agent coordination.

The registry is designed to grow: custom agents are added as new rows following the same schema.

---

## Registry

| Name | Role | Capabilities | Input | Output | Status |
|------|------|-------------|-------|--------|--------|
| architect | Vault Structure & Rules | Hold the folder model and vault map, give new things a home, keep the profile current. Full Bash access. | Structure questions, naming, vault map, profile updates | Notes created, vault map and profile updated | active |
| scribe | Capture | Turn dictation or pasted text into inbox captures without inventing content. | Raw text, dictation, "save this" | Capture notes in `{{inbox}}/` | active |
| sorter | Inbox Filing | File captures into daily notes, threads, commitments and people; report task candidates. | Unsorted captures in the inbox | Notes filed, captures archived, task candidates listed | active |
| seeker | Search & Answer | Search and answer from notes. Read-only. | "find", "status of", "what do I know about" | Cited answers, timelines, stale lists | active |
| librarian | Vault Health | Check links, frontmatter, stale threads, overdue commitments, duplicates. | "check the vault", "vault health" | Health reports, safe fixes | active |
| postman | Gmail & Calendar (thin) | Read and search Gmail and Calendar via `gws` (MCP read-only fallback). Capture, draft or create only on request and with confirmation. | Email or calendar questions | Search results, inbox captures on request | active |
<!-- MBIFC:CUSTOM_AGENTS_START -->
<!-- MBIFC:CUSTOM_AGENTS_END -->

---

## Status Values

- **active**: Agent is operational and available for dispatch
- **disabled**: Agent is temporarily disabled — the dispatcher will skip it

---

## How This File Is Used

1. **Dispatcher** reads the `Input` column to match user messages to agents
2. **Dispatcher** reads `Output` + `Capabilities` of other agents to decide if chaining is needed after an agent returns
3. **Agents** reference this file when suggesting next agents in their output
4. **Custom agents** are added as new rows by the Architect during the custom agent creation flow

---

## Custom Agents

Custom agents are created by the Architect through a conversational flow with the user. They follow the exact same schema as core agents and are added as new rows in the Registry table above.

### How Custom Agents Are Added

1. The user asks the Architect to create a new agent (or an existing agent suggests one via `### Suggested new agent`)
2. The Architect conducts a detailed conversation to understand requirements
3. The Architect generates the agent file in `.platform/agents/`, adds a row to the Registry table above, and updates `agents.md`
4. The platform auto-discovers the new agent from its frontmatter

### Naming Rules

- Custom agent names must be lowercase, hyphens only (e.g., `habit-tracker`, `recipe-manager`)
- Names must NOT conflict with core agent names: architect, scribe, sorter, seeker, librarian, postman
- Names should be descriptive and concise (1-2 words)

### Priority

Custom agents always have lower routing priority than the 8 core agents. The dispatcher checks custom agents only when no core agent matches the user's message. Among custom agents, the dispatcher uses the Input column to find the best match

---

## Skills Registry

Skills handle complex, multi-step workflows extracted from agents. They are checked **before** agents by the dispatcher (higher priority). Skills run in the main conversation context via the Skill tool, preserving multi-turn state.

| Skill | Source Agent | Triggers | Purpose | Status |
|-------|-------------|----------|---------|--------|
| `/braindump` | scribe + sorter | "braindump", "brain dump", "let me dump", "get this out of my head" | Capture a dump, file notes, offer task candidates for Sunsama | active |
| `/onboarding` | architect | "initialize the vault", "set up the vault", "run the interview", "update my profile" | Short setup plus optional interview | active |
| `/inbox-triage` | sorter | "triage the inbox", "sort my notes", "file my notes", "process the inbox" | Interactive inbox filing | active |
| `/vault-audit` | librarian | "vault audit", "check the vault", "vault health", "clean up the vault" | Full audit with guided fixes | active |
| `/create-agent` | architect | "create a new agent", "I need a new agent" | Custom agent creation (6-phase interview) | active |
| `/manage-agent` | architect | "edit my agent", "remove agent", "list agents" | Edit, remove, list agents | active |

### How Skills Are Routed

1. The dispatcher checks the **skill routing table** (in `DISPATCHER.md`) before the agent routing table
2. If a trigger matches, the skill is invoked via the **Skill tool** — not the Agent tool
3. If no skill matches, the dispatcher falls through to agent routing
4. Skills can produce `### Suggested next agent` output, which the dispatcher handles using the same chaining rules as agents
