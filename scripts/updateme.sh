#!/usr/bin/env bash
# =============================================================================
# minions :: Updater
# =============================================================================
# After pulling new changes from the repo, run this to update the install:
#
#   cd /path/to/your-vault/minions
#   git pull
#   bash scripts/updateme.sh
#
# Options:
#   --target <path>      Override the vault destination path
# =============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib.sh
source "$SCRIPT_DIR/lib.sh"

resolve_paths "${BASH_SOURCE[0]}"

# ── Parse args ─────────────────────────────────────────────────────────────
PLATFORM="claude-code"
TARGET_OVERRIDE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)    TARGET_OVERRIDE="$2"; shift 2 ;;
    *) die "Unknown argument: $1" ;;
  esac
done
[[ -n "$TARGET_OVERRIDE" ]] && VAULT_DIR="$TARGET_OVERRIDE"

# ── Banner ────────────────────────────────────────────────────────────────────
print_banner "Update       "

# ── Check vault has been set up ───────────────────────────────────────────────
[[ -d "$VAULT_DIR/.claude/agents" ]] \
  || die "No .claude/agents found in $VAULT_DIR — run launchme.sh first"

# ── Confirm ───────────────────────────────────────────────────────────────────
_DISP_NAME="CLAUDE.md"; _FW_DIR_NAME="claude"
echo -e "${BOLD}This will update core agents, skills, references, hooks, and ${_DISP_NAME}.${NC}"
echo -e "   ${DIM}Custom agents in .${_FW_DIR_NAME}/agents/ are never overwritten or deleted.${NC}"
echo -e "   ${DIM}Custom content between MBIFC markers in references is preserved.${NC}"
echo -e "   ${DIM}Your vault notes are never touched.${NC}"
echo ""
echo -e "   ${BOLD}c)${NC} Continue"
echo -e "   ${BOLD}q)${NC} Quit"
if ! read -r -p "   > " ANSWER 2>/dev/null; then ANSWER=""; fi
if [[ ! "$ANSWER" =~ ^[Cc]$ ]]; then
  echo ""; info "Update cancelled."; echo ""; exit 0
fi
echo ""

# ── Build the platform dist ───────────────────────────────────────────────
info "Building $PLATFORM adapter..."
bash "$SCRIPT_DIR/build.sh" --platform "$PLATFORM"
DIST_DIR="$REPO_DIR/dist/$PLATFORM"
[[ -d "$DIST_DIR" ]] || die "Build did not produce $DIST_DIR"

# ── Install layout (Claude Code) ────────────────────────────────────────────
DIST_COMPONENTS_DIR="$DIST_DIR/.claude"
VAULT_COMPONENTS_DIR="$VAULT_DIR/.claude"
DISPATCHER_SRC="$DIST_DIR/CLAUDE.md"
DISPATCHER_DST="$VAULT_DIR/CLAUDE.md"
MCP_SRC="$DIST_DIR/.mcp.json"
MCP_DST="$VAULT_DIR/.mcp.json"
DIST_SKILLS_DIR="$DIST_COMPONENTS_DIR/skills"
VAULT_SKILLS_DIR="$VAULT_COMPONENTS_DIR/skills"

# ── Migrate legacy manifests (if any) ────────────────────────────────────────
manifest_migrate

# ── Deprecate agents/refs removed from repo ──────────────────────────────────
DEP_COUNT=$(deprecate_removed "agents"     "$DIST_COMPONENTS_DIR/agents"     "$VAULT_COMPONENTS_DIR/agents")
DEP_COUNT=$((DEP_COUNT + $(deprecate_removed "references" "$DIST_COMPONENTS_DIR/references" "$VAULT_COMPONENTS_DIR/references")))

# ── Ensure vault support dirs ─────────────────────────────────────────────────
mkdir -p "$VAULT_DIR/Meta/states"

# ── Update components (per-file logging enabled) ─────────────────────────────
VERBOSE_COPY=1

AGENT_COUNT=$(install_agents "$DIST_COMPONENTS_DIR/agents" "$VAULT_COMPONENTS_DIR/agents")
REF_COUNT=$(install_refs     "$DIST_COMPONENTS_DIR/references" "$VAULT_COMPONENTS_DIR/references")
SKILL_COUNT=$(install_skills "$DIST_SKILLS_DIR" "$VAULT_SKILLS_DIR")
HOOK_COUNT=$(install_hooks   "$DIST_COMPONENTS_DIR/hooks"  "$VAULT_COMPONENTS_DIR/hooks")

PLUGIN_COUNT=0

SETTINGS_CHANGED=0
if [[ -f "$DIST_COMPONENTS_DIR/settings.json" ]]; then
  install_settings "$DIST_COMPONENTS_DIR/settings.json" "$VAULT_COMPONENTS_DIR"
  SETTINGS_CHANGED=$_LAST_CHANGED
fi

install_dispatcher "$DISPATCHER_SRC" "$DISPATCHER_DST"
DISPATCHER_CHANGED=$_LAST_CHANGED

# ── Vault-level files for other clients ──────────────────────────────────────
if [[ -d "$REPO_DIR/vault" ]]; then
  mkdir -p "$VAULT_DIR/Meta"
  copy_if_changed "$REPO_DIR/vault/protocol.md" "$VAULT_DIR/Meta/protocol.md"
  # AGENTS.md is created once and then belongs to the user
  [[ -f "$VAULT_DIR/AGENTS.md" ]] || cp "$REPO_DIR/vault/AGENTS.md" "$VAULT_DIR/AGENTS.md"
fi

# ── MCP ───────────────────────────────────────────────────────────────────────
[[ -f "$MCP_SRC" ]] && copy_if_changed "$MCP_SRC" "$MCP_DST"

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
TOTAL=$((AGENT_COUNT + REF_COUNT + SKILL_COUNT + HOOK_COUNT + PLUGIN_COUNT + SETTINGS_CHANGED + DISPATCHER_CHANGED))
if [[ $TOTAL -eq 0 && $DEP_COUNT -eq 0 ]]; then
  success "Everything is already up to date!"
else
  success "Updated $AGENT_COUNT agent(s), $SKILL_COUNT skill(s), $REF_COUNT reference(s), $HOOK_COUNT hook(s)"
  [[ $SETTINGS_CHANGED -eq 1 ]] && info "settings.json updated (backup saved as settings.json.bak)"
  [[ $DISPATCHER_CHANGED -eq 1 ]] && info "Dispatcher file updated"
  [[ $DEP_COUNT -gt 0 ]] && warn "$DEP_COUNT file(s) deprecated (moved to deprecated/)"
fi
echo ""
echo -e "   ${DIM}Restart $PLATFORM to pick up the changes.${NC}"
echo ""
