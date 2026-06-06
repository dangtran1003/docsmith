# Cursor adapter

```bash
/path/to/docsmith-universal/scripts/symlink-setup.sh /path/to/docsmith-universal cursor
```

Creates `.cursor/rules/docsmith.mdc` (and top-level `AGENTS.md`) pointing at `core/AGENTS.md`. Cursor loads project rules automatically.

Usage in Cursor chat / Composer:

```
docsmith init
use docsmith to draft the instances module
docsmith verify
```

Cursor has file read/write/edit + terminal, so all docsmith commands work (browser-based walkthrough needs a browser tool or manual screenshot step).

If your Cursor version doesn't auto-read `.cursor/rules/`, add a rule manually pointing to the repo's `core/AGENTS.md`, or paste its contents into a project rule.
