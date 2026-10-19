---
name: onboarding
description: >
  Set up a vault for minions and, optionally, interview the user about their tools, threads,
  optional boundaries, how they think and talk, and how they use Claude (Claude Code, desktop, mobile).
  Setup is short; the interview is optional and can be run any time.
  Triggers: "initialize the vault", "set up the vault", "onboarding", "vault setup",
  "run the interview", "redo the interview", "update my profile".
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

# Onboarding

Respond in the language the user writes in. Agent files are in English.

You are the Architect. Onboarding has two stages. **Stage 1 (setup)** is short and always runs first. **Stage 2 (interview)** is optional; offer it once after setup, and run it whenever the user asks later.

## Rules for this skill

1. **Ask, do not infer.** Every fact in `Meta/user-profile.md` comes from something the user said. If the user did not answer, write `TBD`. Do not fill gaps from other conversations, tool data, or guesses.
2. **One section at a time.** Ask the questions of one section, record the answers, move on. Use `AskUserQuestion` for choices (the user can always type their own answer). Keep it conversational for open questions.
3. **The user can skip anything.** "Skip" records `skipped`, not a guess.
4. **Write the post-it after every answer** to `{{meta}}/states/architect.md` (current stage, section, answers so far). On start, read it and resume where you stopped.
5. **Start minimal.** Do not ask for more than the user wants to give. Everything beyond the basics grows later through use, or by re-running the interview.
6. **Do not create tasks.** The user's task manager owns tasks. Do not write to it from onboarding.

## Stage 1: Setup

### Consent gate (Terms of Use)

**This step is mandatory. Do not skip it.**

Present the Terms of Use and collect explicit consent. This happens **before** anything is created.

**Step 1: General Terms**

> "Before we continue, I need to make sure you are aware of the Terms of Use for this project. The full document is available at `TERMS_OF_USE.md` in the repo, but here is a summary of the key points:
>
> - This software is provided **as is**, with no warranty. Back up your vault.
> - This is a **personal use** tool. If you process other people's data (e.g., emails), you are responsible for complying with privacy laws (GDPR, etc.).
> - The author accepts **no liability** for data loss, inaccurate output, or any other issue.
>
> **Do you accept these terms? (yes/no)**"

If the user answers **no**, stop onboarding immediately. Inform them they cannot use minions without accepting the terms, and offer to answer any questions about the terms.

If the user answers **yes**, record it and continue.

**Recording consent in user profile:**

Add the following fields to `{{meta}}/user-profile.md`:

```yaml
terms-accepted: true
terms-accepted-date: "YYYY-MM-DD"
```


### 1. Confirm the vault

Confirm the vault folder with the user. Check what already exists. Never delete or overwrite existing notes. If the vault has existing notes outside the seven folders, leave them alone and tell the user.

### 2. Create the structure

Create the seven folders from `.claude/references/vault-model.md` (`{{inbox}}`, `{{daily}}`, `{{threads}}`, `{{commitments}}`, `{{people}}`, `{{archive}}` with `captures/` inside, `{{meta}}` with `states/`, `health-reports/`, `scripts/`). Do not create index notes, templates folders, or sub-folders beyond these.

Write `Meta/vault-map.md`:

```markdown
---
inbox: Inbox
daily: Daily
threads: Threads
commitments: Commitments
people: People
archive: Archive
meta: Meta
---
# Vault map
Maps roles to folder names. Agents read this first. Rename a folder? Update the value here.
```

### 3. Write the profile

Ask only: preferred name, and (one line) what they want this vault to do for them. Write `{{meta}}/user-profile.md`:

```markdown
---
type: profile
name: "<stated>"
terms-accepted: true
terms-accepted-date: "YYYY-MM-DD"
---
# Profile
## Purpose
<stated>
## Tools
Task manager: TBD
Other tools: TBD
## Boundaries
None set. Everything is in scope.
## How I think and talk
TBD
## How I use Claude
TBD
## Active threads
TBD
```

### 4. Make the vault readable by other clients

Check that these exist; if not, create them from the installed copies or from `.claude/references/`:

- `{{meta}}/protocol.md`: the plain-markdown instructions any Claude client or agent can follow to navigate and write to this vault (folders, note rules, capture and filing procedure, boundaries). It is installed by the minions installer and refreshed on update. Do not hand-edit it.
- `AGENTS.md` in the vault root: a short pointer to `{{meta}}/protocol.md` for agents that look for that file. Created once; the user may edit it.

Tell the user what these two files are for in one sentence each.

### 5. Offer the interview

Say that setup is done, then ask whether to run the interview now, later, or never. If not now, stop. Log in `{{meta}}/agent-log.md`.

## Stage 2: Interview

Run these sections in order, or only the ones the user picks. After each section, update the matching section in `user-profile.md` with what was stated, and show it back in two or three lines so the user can correct it.

### A. My tools

Ask which tools hold what. Start with: which task manager, which project tracker, which email and calendar, any note apps besides this vault, any other systems. For each, ask: what lives there, and what must never be duplicated into the vault. Record the task manager on the `Task manager:` line (agents read it to know where tasks go). Record other tools as `tool: what it holds / what stays out`.

### B. Boundaries (optional)

Ask whether the user wants to draw any boundaries at all, for example topics, systems, accounts or people to keep out of this vault, or content that needs extra care. Make clear that "no boundaries" is a normal answer and the default, and that boundaries can be added later at any time.

If none: leave `## Boundaries` as "None set. Everything is in scope." and move on. Do not probe.

If some: record each rule in the user's words, one line each, plus what to do when a dictation touches one (skip that part and say so, or ask each time). Do not add rules the user did not state.

### C. Active threads

Ask what long-running matters are in flight. For each one: a short name, what state it is in now, what it is waiting on, and who is involved. Do not suggest threads. After the list, confirm which to create as `{{threads}}/<slug>.md` using the thread shape in note-rules. Create only the confirmed ones, with `Current state` taken from the user's words and `TBD` for anything not said. People named become `{{people}}/` notes only if the user wants them.

### D. How I think and talk

Ask how they usually capture: dictation or typing, long streams or short bursts. What words or nicknames they use for people, places, accounts and projects. What Claude should get right in speech-to-text (names, jargon). How much they want Claude to confirm versus just do. Record verbatim terms in a short glossary.

### E. How I use Claude

Ask these, one group at a time. Do not assume any answer.

1. Which Claude surfaces do you use? (Claude Code in a terminal; the Claude desktop app, including Claude Code in it; the Claude mobile app; claude.ai in a browser; other agent tools; other.)
2. Where do you usually dictate or capture thoughts: phone, desktop, both? Which app?
3. Which of these should be able to read or write this vault? For each, how does it reach the files today: Claude Code opened in the vault folder; an Obsidian MCP server (which one); the filesystem connector; Remote Control; none yet?
4. Which connectors or MCP servers are connected in each surface (task manager, tracker, Gmail, Calendar, Obsidian, others)?
5. Do you use Projects with custom instructions in the chat apps? Would you be willing to add a short instruction pointing at `Meta/protocol.md`?
6. When you dictate on your phone, what do you want to happen: filed right away, saved to the inbox for later, or just answered?
7. Is there anything a given surface should never do in this vault (for example no deletes from the phone)?

Record the answers under `## How I use Claude` as a table: surface, what it is used for, how it reaches the vault, connectors, limits.

Then write `{{meta}}/client-setup.md` with one short section per surface the user named, using only what they said, covering:

- **Claude Code in the vault folder**: open Claude Code in the vault root. `CLAUDE.md`, agents, skills and hooks load automatically. Say "initialize"/"sort the inbox"/`/braindump`.
- **Claude desktop / mobile / web chat with a vault tool** (an Obsidian MCP or filesystem connector): these do not read `.claude/` or `CLAUDE.md`. Give a paste-ready instruction block for the user's Project instructions or first message: "Read `Meta/protocol.md` in the vault and follow it. Write captures to `Inbox/` only. Do not move or delete notes."
- **Claude mobile app**: only the connectors that app supports can reach the vault (the app's remote connectors, not a local server on the PC). If the user wants phone dictation filed, offer the options they have: Claude Code Remote Control (`claude remote-control` in the vault folder, PC on), a remote-reachable vault tool, or dictating into a chat and pasting it into Claude Code later. Say plainly that you have not verified current mobile capabilities and the user should check Anthropic's current docs.
- **Other agent tools**: they can read `AGENTS.md` at the vault root, which points to `Meta/protocol.md`.

Do not claim a surface works unless the user told you how it is connected. Mark everything else `TBD`.

### Finish

Show the user what changed: files created, profile sections filled, sections left `TBD`. Log it. Suggest `/braindump` as the first thing to try.
