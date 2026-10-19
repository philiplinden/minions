#!/usr/bin/env bash
# Consistency tests for the repo itself: what exists must match what the
# dispatcher, registry and docs say exists. Run through tests/run.sh.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

_agents() { for f in "$ROOT"/agents/*.md; do basename "$f" .md; done; }
_skills() { for d in "$ROOT"/skills/*/; do [[ -f "${d}SKILL.md" ]] && basename "$d"; done; }

test_registry_has_a_row_for_every_agent_and_nothing_else() {
  local reg="$ROOT/references/agents-registry.md" rc=0 a
  for a in $(_agents); do
    grep -q "^| $a |" "$reg" || { echo "registry missing agent: $a"; rc=1; }
  done
  # every row inside the core table (before the custom markers) must have a file
  local rows; rows="$(awk '/^\| [a-z-]+ \|/ && !/^\| Name/ {print $2}' "$reg")"
  for a in $rows; do
    [[ -f "$ROOT/agents/$a.md" ]] || { echo "registry lists agent with no file: $a"; rc=1; }
  done
  return $rc
}

test_dispatcher_mentions_every_skill_and_agent() {
  local d="$ROOT/DISPATCHER.md" rc=0 x
  for x in $(_skills); do grep -q "\`/$x\`" "$d" || { echo "dispatcher missing skill: /$x"; rc=1; }; done
  for x in $(_agents); do grep -qi "\*\*$x\*\*" "$d" || { echo "dispatcher missing agent: $x"; rc=1; }; done
  return $rc
}

test_every_skill_and_agent_has_name_matching_its_path() {
  local rc=0 x n
  for x in $(_agents); do n="$(awk '/^name:/{print $2; exit}' "$ROOT/agents/$x.md" | tr -d '\r')"; [[ "$n" == "$x" ]] || { echo "agent $x has name: $n"; rc=1; }; done
  for x in $(_skills); do n="$(awk '/^name:/{print $2; exit}' "$ROOT/skills/$x/SKILL.md" | tr -d '\r')"; [[ "$n" == "$x" ]] || { echo "skill $x has name: $n"; rc=1; }; done
  return $rc
}

test_no_references_to_removed_things_in_live_files() {
  local rc=0 hits
  hits="$(grep -rnEi '\btranscriber\b|\bhey (cli|\.com)\b|\{\{(areas|projects|resources|meetings|moc|templates)\}\}|\b0[0-7]-(Inbox|Projects|Areas|Resources|Archive|People|Meetings|Daily)\b|codex|gemini|opencode' \
    "$ROOT/agents" "$ROOT/skills" "$ROOT/references" "$ROOT/DISPATCHER.md" "$ROOT/hooks" "$ROOT/orchestra" "$ROOT/vault" 2>/dev/null || true)"
  [[ -z "$hits" ]] || { echo "stale references:"; echo "$hits" | head -20; rc=1; }
  return $rc
}

test_only_known_vault_tokens_are_used() {
  local ok="inbox daily threads commitments people archive meta" t rc=0
  for t in $(grep -rhoE '\{\{(inbox|daily|threads|commitments|people|archive|meta|[a-z]+)\}\}' "$ROOT/agents" "$ROOT/skills" "$ROOT/references" | sort -u | tr -d '{}'); do
    case " $ok date ISO " in *" $t "*) ;; *) echo "unknown lowercase token {{$t}}"; rc=1;; esac
  done
  return $rc
}

test_install_into_a_temp_vault_produces_expected_layout() {
  command -v jq >/dev/null || { echo "jq missing, skipping"; return 0; }
  local v; v="$(mktemp -d)"
  bash "$ROOT/scripts/launchme.sh" --target "$v" >/dev/null 2>&1 || { echo "launchme failed"; rm -rf "$v"; return 1; }
  local rc=0 x
  for x in $(_agents); do [[ -f "$v/.claude/agents/$x.md" ]] || { echo "missing agent $x"; rc=1; }; done
  for x in $(_skills); do [[ -f "$v/.claude/skills/$x/SKILL.md" ]] || { echo "missing skill $x"; rc=1; }; done
  for x in CLAUDE.md AGENTS.md Meta/protocol.md .claude/settings.json .claude/references/note-rules.md .claude/references/vault-model.md Meta/scripts/vault-stats; do
    [[ -e "$v/$x" ]] || { echo "missing $x"; rc=1; }
  done
  # second run (update) must not fail
  bash "$ROOT/scripts/updateme.sh" --target "$v" <<< "c" >/dev/null 2>&1 || { echo "updateme failed"; rc=1; }
  rm -rf "$v"
  return $rc
}

test_regression_snapshot_matches_build() {
  bash "$ROOT/tests/regression/run.sh" >/dev/null 2>&1 || { echo "snapshot differs; run tests/regression/take-snapshot.sh if intended"; return 1; }
}
