#!/usr/bin/env bash
# docsmith session-start hook.
# Emits a short context nudge so the agent knows docsmith exists and how to load it
# WITHOUT pulling the whole skill into context (progressive disclosure).

set -euo pipefail

# Resolve plugin root across harnesses
ROOT="${CLAUDE_PLUGIN_ROOT:-${CURSOR_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}}"

NUDGE="docsmith is available. If the user wants to create/plan/review/score/publish product documentation, read ${ROOT}/skills/docsmith/SKILL.md (a small index) first, then load only the relevant command file from skills/docsmith/commands/. Do not load the whole skill at once."

# Cursor expects additional_context JSON when CURSOR_PLUGIN_ROOT is set
if [[ -n "${CURSOR_PLUGIN_ROOT:-}" ]]; then
  printf '{"additional_context": %s}\n' "$(printf '%s' "$NUDGE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' 2>/dev/null || printf '"%s"' "$NUDGE")"
else
  # Claude Code / others: plain text on stdout is injected as context
  printf '%s\n' "$NUDGE"
fi
