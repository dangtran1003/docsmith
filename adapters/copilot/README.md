# GitHub Copilot adapter

```bash
/path/to/docsmith-universal/scripts/symlink-setup.sh /path/to/docsmith-universal copilot
```

Creates `.github/copilot-instructions.md` (and top-level `AGENTS.md`) pointing at `core/AGENTS.md`. Copilot reads repo custom instructions automatically in supported IDEs.

Usage in Copilot Chat (agent mode):

```
docsmith init
docsmith run
```

Note: Copilot's agent capabilities vary by IDE/version. File ops work in agent mode; browser walkthrough generally needs a separate tool. Best for the file-based stages (init through score).
