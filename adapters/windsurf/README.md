# Windsurf adapter

```bash
/path/to/docsmith-universal/scripts/symlink-setup.sh /path/to/docsmith-universal windsurf
```

Creates `.windsurf/rules/docsmith.md` (and top-level `AGENTS.md`) pointing at `core/AGENTS.md`. Windsurf (Cascade) reads workspace rules automatically.

Usage in Cascade:

```
docsmith init
docsmith run
docsmith score
```
