# Aider adapter

```bash
/path/to/docsmith-universal/scripts/symlink-setup.sh /path/to/docsmith-universal aider
```

Creates `CONVENTIONS.md` (and top-level `AGENTS.md`) pointing at `core/AGENTS.md`.

Tell aider to read it:

```bash
aider --read CONVENTIONS.md
```

Or persist in `.aider.conf.yml`:

```yaml
read: [CONVENTIONS.md]
```

Then:

```
docsmith init
docsmith draft instances
```

Note: aider is git-native and file-focused. It's great for init/plan/voice/draft/edit/verify/score/deploy. It has no built-in browser, so walkthrough screenshot capture must be done with a separate browser tool (keep placeholders, capture manually, or run walkthrough in a browser-capable tool).
