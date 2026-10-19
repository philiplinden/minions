# Orchestra

Named scripts that wrap common agent operations into single, permission-friendly commands.

Claude Code prompts for permission on every novel Bash command. A named script at a known path can be added to the allowlist once and then runs without a prompt.

## Installation

The installer copies these to `Meta/scripts/` in your vault. They find the vault from their own location and read folder names from `Meta/vault-map.md`, so no configuration is needed.

Add them to the permission allowlist (for example in `.claude/settings.local.json` or `~/.claude/settings.json`, merged into `permissions.allow`):

```json
{
  "permissions": {
    "allow": [
      "Bash(Meta/scripts/vault-stats:*)",
      "Bash(Meta/scripts/vault-inbox:*)"
    ]
  }
}
```

## Scripts

| Script | Usage | Description |
|--------|-------|-------------|
| `vault-inbox` | `vault-inbox [--count]` | List notes in the inbox, newest first, or just the count |
| `vault-stats` | `vault-stats` | Note counts per folder, last 24h of activity, total |

## Adding a script

Put an executable script here (no extension needed), have it find the vault with `VAULT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"`, and add an allowlist entry above. The installer copies everything in this folder except this README.
