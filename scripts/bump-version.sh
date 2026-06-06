#!/usr/bin/env bash
# Bump version across all platform manifests so they stay in sync.
# Usage: ./scripts/bump-version.sh 1.1.0

set -euo pipefail

NEW="${1:-}"
if [[ -z "$NEW" ]]; then
  echo "Usage: $0 <new-version>  (e.g. 1.1.0)"
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Bumping to $NEW across all manifests..."

# JSON manifests
for f in package.json .claude-plugin/plugin.json .claude-plugin/marketplace.json \
         .codex-plugin/plugin.json .cursor-plugin/plugin.json gemini-extension.json; do
  if [[ -f "$f" ]]; then
    python3 - "$f" "$NEW" << 'PY'
import json, sys
path, new = sys.argv[1], sys.argv[2]
data = json.load(open(path))
def bump(d):
    if isinstance(d, dict):
        if "version" in d and isinstance(d["version"], str):
            d["version"] = new
        for v in d.values():
            bump(v)
    elif isinstance(d, list):
        for v in d:
            bump(v)
bump(data)
json.dump(data, open(path,"w"), indent=2)
open(path,"a").write("\n")
PY
    echo "  ✓ $f"
  fi
done

# SKILL.md frontmatter
SKILL="skills/docsmith/SKILL.md"
if [[ -f "$SKILL" ]]; then
  sed -i.bak "s/^version: .*/version: $NEW/" "$SKILL" && rm -f "$SKILL.bak"
  echo "  ✓ $SKILL"
fi

echo "Done. Review changes, then commit + tag v$NEW."
