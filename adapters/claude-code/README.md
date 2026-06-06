# Claude Code adapter

Two ways to use docsmith in Claude Code.

## Option A: AGENTS.md symlink (recommended, progressive disclosure)

From your docs project root:

```bash
/path/to/docsmith-universal/scripts/symlink-setup.sh /path/to/docsmith-universal claude-code
```

This creates `AGENTS.md` and `CLAUDE.md` symlinks pointing at `core/AGENTS.md`. Claude Code reads `CLAUDE.md` automatically, sees the thin index, and loads command files on demand. Then just talk:

```
docsmith init
docsmith run
docsmith deploy
```

## Option B: Original plugin (slash commands)

If you want the classic `/docsmith ...` slash commands, use the original plugin repo (dangtran1003/docsmith-v2) instead. That packages docsmith as a Claude Code plugin with the `.claude-plugin/` marketplace format.

```
/plugin marketplace add dangtran1003/docsmith-v2
/plugin install docsmith@dangtran1003-docsmith-v2
```

Note: the original plugin loads the full SKILL.md. If you hit context limits on large runs, prefer Option A (progressive disclosure) here in docsmith-universal.

## Which to choose

- Hitting token/context limits → Option A (this repo)
- Want slash-command ergonomics, no context worries → Option B (plugin)
- Want the same skill across Claude Code + other tools → Option A
