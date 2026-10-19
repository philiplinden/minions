# Agent Directory

This reference is shared across all agents. Every agent knows the others, their responsibilities, and when to suggest them to the dispatcher.

---

## Agent Registry

For the definitive list of agents with capabilities, inputs, outputs, and status, see `.platform/references/agents-registry.md`. That file is the single source of truth — it supports both core and custom agents.

---

## Language Rule

Agents respond in the language the user writes in.
---

## User Profile

All agents read `Meta/user-profile.md` for personalization. This file is created during onboarding by the Architect and contains the user's name, tools, optional boundaries, how they dictate, and how they use Claude.

---

## The Seven Agents

1. **Architect** (`architect.md`) — holds the folder model, vault map and profile; gives new threads, commitments and people a home. Contact when structure or naming is in question.
2. **Scribe** (`scribe.md`) — turns dictation and pasted text into inbox captures without inventing content. Contact for any "save this".
3. **Sorter** (`sorter.md`) — files inbox captures into daily notes, threads, commitments and people; lists task candidates. Contact when the inbox has unsorted captures.
4. **Seeker** (`seeker.md`) — read-only search and answers from notes, with status age. Contact for any question about vault content.
5. **Connector** (`connector.md`) — adds missing links between threads, commitments, people and daily notes, and finds orphans. Contact after filing, or for "what's related to".
6. **Librarian** (`librarian.md`) — health checks: links, frontmatter, stale threads, overdue commitments, duplicates.
7. **Postman** (`postman.md`) — Gmail and Calendar through `gws`, read-mostly, confirmation for any write.

Skills: `/braindump`, `/onboarding`, `/inbox-triage`, `/vault-audit`, `/defrag`, `/deep-clean`, `/tag-garden`, `/create-agent`, `/manage-agent`.

---

<!-- MBIFC:CUSTOM_AGENTS_START -->
<!-- MBIFC:CUSTOM_AGENTS_END -->

### How Custom Agents Coordinate

Custom agents participate in the same orchestration protocol as core agents:
- They include `### Suggested next agent` sections when they detect work for other agents
- They include `### Suggested new agent` sections when they detect missing capabilities
- The dispatcher chains them like any other agent, subject to the same anti-recursion rules
- They count toward the max depth of 3 agents per user request

### Creating a Custom Agent

Say "create a new agent" or "I need a custom agent" to start the process. The `/create-agent` skill guides you through a 6-phase interview to define the agent's purpose, triggers, permissions, and coordination rules.

### Managing Custom Agents

Use the `/manage-agent` skill:
- "Edit my custom agent X" -> modifies it
- "Remove custom agent X" -> deactivates it (with user confirmation)
- "List all agents" -> shows the 7 core agents and any custom agents
