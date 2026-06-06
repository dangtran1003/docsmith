# Cline / Roo Code adapter

```bash
/path/to/docsmith-universal/scripts/symlink-setup.sh /path/to/docsmith-universal cline
```

Creates `.clinerules/docsmith.md` (and top-level `AGENTS.md`) pointing at `core/AGENTS.md`. Cline reads `.clinerules/` automatically.

Usage:

```
docsmith init
docsmith run instances
docsmith deploy --dry-run
```

Cline has full file + terminal + (optional) browser tools, so all commands work. For walkthrough, enable Cline's browser tool.
