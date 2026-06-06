# Installing docsmith on OpenCode

OpenCode installs by fetching and following these instructions. Tell OpenCode:

```
Fetch and follow instructions from https://raw.githubusercontent.com/dangtran1003/docsmith-universal/main/.opencode/INSTALL.md
```

(Replace the URL with your actual repo path if different.)

## What to do (for the OpenCode agent reading this)

1. Clone or note the location of this repository (docsmith-universal).
2. Register the skill so it's discovered at session start. OpenCode reads `AGENTS.md`-style context files; ensure the agent reads `skills/docsmith/SKILL.md` when documentation work is requested.
3. The skill index is at `skills/docsmith/SKILL.md`. It's a small file (~1,200 tokens). It maps commands to files in `skills/docsmith/commands/`. Load only the command file needed per task; load `references/`, `templates/`, `fpt/` only when a command points to them.

## Manual setup (if fetch-and-follow isn't available)

From your docs project root, symlink the skill index into a context file OpenCode reads:

```bash
ln -sf /path/to/docsmith-universal/skills/docsmith/SKILL.md ./AGENTS.md
```

Then in OpenCode chat:

```
docsmith init
docsmith run
docsmith deploy
```

## Capabilities

docsmith needs file ops (always), plus optionally: browser automation (walkthrough/record), git (deploy/publish), web fetch (external sources). OpenCode provides file + shell; enable a browser tool for screenshot capture.

## Notes

- docsmith uses progressive disclosure — do not load the entire skill at once.
- Bootstrap content can be cached at module level for performance.
