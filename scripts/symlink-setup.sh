#!/usr/bin/env bash
# docsmith-universal — symlink setup
# Wires skills/docsmith/SKILL.md into whatever AI tool you use, so the agent
# discovers docsmith automatically. Run from your DOCS PROJECT root
# (the directory where you want to use docsmith), pointing at this repo.
#
# Usage:
#   ./scripts/symlink-setup.sh <path-to-docsmith-universal> [tool]
#
# Examples:
#   ./scripts/symlink-setup.sh ~/tools/docsmith-universal claude-code
#   ./scripts/symlink-setup.sh ~/tools/docsmith-universal cursor
#   ./scripts/symlink-setup.sh ~/tools/docsmith-universal all
#
# If [tool] is omitted, defaults to "all".

set -euo pipefail

REPO="${1:-}"
TOOL="${2:-all}"

if [[ -z "$REPO" ]]; then
  echo "Usage: $0 <path-to-docsmith-universal> [tool|all]"
  echo "Tools: claude-code cursor cline windsurf aider copilot all"
  exit 1
fi

REPO="$(cd "$REPO" && pwd)"           # absolute
CORE="$REPO/skills/docsmith"
AGENTS="$CORE/SKILL.md"

if [[ ! -f "$AGENTS" ]]; then
  echo "ERROR: $AGENTS not found. Is the repo path correct?"
  exit 1
fi

echo "docsmith-universal core: $CORE"
echo "Target project: $(pwd)"
echo "Tool: $TOOL"
echo ""

# Always put a top-level AGENTS.md symlink (the universal standard).
link_agents_md() {
  ln -sf "$AGENTS" "./AGENTS.md"
  echo "  ✓ AGENTS.md -> skills/docsmith/SKILL.md"
}

setup_claude_code() {
  link_agents_md
  ln -sf "$AGENTS" "./CLAUDE.md"
  echo "  ✓ CLAUDE.md -> skills/docsmith/SKILL.md (Claude Code)"
}

setup_cursor() {
  link_agents_md
  mkdir -p ".cursor/rules"
  ln -sf "$AGENTS" ".cursor/rules/docsmith.mdc"
  echo "  ✓ .cursor/rules/docsmith.mdc -> skills/docsmith/SKILL.md (Cursor)"
}

setup_cline() {
  link_agents_md
  mkdir -p ".clinerules"
  ln -sf "$AGENTS" ".clinerules/docsmith.md"
  echo "  ✓ .clinerules/docsmith.md -> skills/docsmith/SKILL.md (Cline / Roo)"
}

setup_windsurf() {
  link_agents_md
  mkdir -p ".windsurf/rules"
  ln -sf "$AGENTS" ".windsurf/rules/docsmith.md"
  echo "  ✓ .windsurf/rules/docsmith.md -> skills/docsmith/SKILL.md (Windsurf)"
}

setup_aider() {
  link_agents_md
  ln -sf "$AGENTS" "./CONVENTIONS.md"
  echo "  ✓ CONVENTIONS.md -> skills/docsmith/SKILL.md (Aider)"
  echo "    Note: run aider with --read CONVENTIONS.md (or add to .aider.conf.yml)"
}

setup_copilot() {
  link_agents_md
  mkdir -p ".github"
  ln -sf "$AGENTS" ".github/copilot-instructions.md"
  echo "  ✓ .github/copilot-instructions.md -> skills/docsmith/SKILL.md (GitHub Copilot)"
}

case "$TOOL" in
  claude-code) setup_claude_code ;;
  cursor)      setup_cursor ;;
  cline)       setup_cline ;;
  windsurf)    setup_windsurf ;;
  aider)       setup_aider ;;
  copilot)     setup_copilot ;;
  all)
    echo "Setting up ALL tools:"
    setup_claude_code
    setup_cursor
    setup_cline
    setup_windsurf
    setup_aider
    setup_copilot
    ;;
  *)
    echo "Unknown tool: $TOOL"
    echo "Tools: claude-code cursor cline windsurf aider copilot all"
    exit 1
    ;;
esac

echo ""
echo "Done. The agent will read skills/docsmith/SKILL.md (a thin index) and load"
echo "individual command files from core/commands/ only as needed."
echo ""
echo "Test it: open your tool in this directory and say:"
echo "  \"use docsmith to set up docs\"  (or)  \"docsmith init\""
