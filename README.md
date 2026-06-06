# docsmith-universal

Documentation-automation skill that runs in **any** AI coding tool or agent — Claude Code, Cursor, Cline, Windsurf, Aider, GitHub Copilot, or a custom agent built on any model (Qwen, GPT, MiniMax, DeepSeek, Llama…).

It's the portable form of [docsmith](https://github.com/dangtran1003/docsmith-v2), restructured for **progressive disclosure** so it fits in small context windows.

## The problem this solves

The original docsmith is a ~48,000-token specification. Loading it all at once:
- blows past smaller models' context windows, and
- degrades quality even on large-context models ("context rot" — too much irrelevant text dilutes attention).

## The fix: progressive disclosure

docsmith-universal splits the skill into tiers that load on demand:

| Tier | What | Size | When loaded |
|---|---|---|---|
| 1 | `core/AGENTS.md` — thin index | ~1,200 tokens | Always (agent startup) |
| 2 | `core/commands/<cmd>.md` — one per command | ~500 tokens each | When that command runs |
| 3 | `core/references/`, `core/templates/`, `core/fpt/` | large | Only when a command points to them |

**A typical task loads ~2,000 tokens instead of ~48,000 — a 96% reduction.** The agent holds the index plus the single command it's running, and pulls one reference only if that command needs it.

This is the same pattern Claude Skills and Microsoft's agent-skills use, and it's why docsmith now runs even on limited-context model CLIs.

## What docsmith does

A staged documentation pipeline: analyze audience → plan sitemap → set voice → draft → self-review → capture screenshots from the live product → record videos → translate → verify → score → deploy to a docs repo (Docusaurus or other). Optional FPT Cloud compliance mode enforces structure, voice, anti-AI-tells, and a 20-point quality scorecard.

## Repo layout

```
docsmith-universal/
├── README.md                  ← you are here
├── INSTALL.md                 ← per-tool install (native plugin commands)
├── AGENTS.md / CLAUDE.md / GEMINI.md   ← top-level bootstraps (point to the skill)
├── skills/docsmith/           ← the skill (native-discovery home)
│   ├── SKILL.md               ← Tier 1 index (start here)
│   ├── commands/              ← Tier 2 (one file per command)
│   ├── references/            ← Tier 3 (deep detail)
│   ├── templates/             ← Tier 3 (output templates)
│   ├── fpt/                   ← Tier 3 (FPT Cloud standards)
│   └── presets/               ← deploy presets
├── .claude-plugin/            ← Claude Code manifest + marketplace
├── .codex-plugin/             ← Codex manifest
├── .cursor-plugin/            ← Cursor manifest
├── .opencode/INSTALL.md       ← OpenCode install
├── gemini-extension.json      ← Gemini CLI extension
├── hooks/                     ← session-start hooks (Claude Code + Cursor)
├── adapters/                  ← fallback setup notes per tool (+ generic-agent)
├── scripts/
│   ├── symlink-setup.sh       ← fallback: wire SKILL.md into any tool
│   └── bump-version.sh        ← keep all manifest versions in sync
└── package.json

```

## Quick start

Install for your tool (each harness has its own command — see [INSTALL.md](INSTALL.md)):

```
# Claude Code
/plugin marketplace add dangtran1003/docsmith-universal
/plugin install docsmith@dangtran1003-docsmith-universal

# Cursor
/add-plugin docsmith

# Gemini CLI
gemini extensions install https://github.com/dangtran1003/docsmith-universal

# Codex: /plugins -> search docsmith -> install
# Copilot CLI: copilot plugin marketplace add ... ; copilot plugin install ...
# OpenCode: tell it to fetch .opencode/INSTALL.md
# Any other tool: scripts/symlink-setup.sh
```

Then in your tool's chat:

```
docsmith init          # scaffold workspace
docsmith run           # generate docs (pauses for review)
docsmith deploy        # sync to your docs repo
```

## How invocation works across tools

docsmith was born as `/docsmith init` slash commands in Claude Code. Other tools have no slash commands, so the index treats all of these as equivalent:

- `/docsmith init` (Claude Code)
- `docsmith init` / `run docsmith init` (natural language)
- `use docsmith to set up docs` (intent)

The agent maps your phrasing to a command, reads that command file, and follows it.

## What your environment must provide

docsmith is pure instructions. Capabilities come from your tool:

- **File ops** (always required) — every tool above has this
- **Browser automation** — only for `walkthrough` (screenshots) and `record` (videos)
- **Git** — only for `deploy`/`publish`
- **Web/API fetch** — only when pulling external sources (Notion/GitHub/GDrive/URL)

With file ops alone you can run init, module, plan, voice, draft, edit, verify, score. The browser/git/fetch commands light up when your tool provides those tools.

## FPT Cloud compliance

Set `compliance: fpt-user-guide` in `documentation/intake/project.md` to enforce FPT Cloud standards: Sitemap Pattern D, FPT voice chart, 22 verify checks (including anti-AI-tells), required 20-point scorecard (≥14 to deploy), and a deploy gate. Details live in `core/fpt/` and load only when those commands run.

## Relationship to docsmith-v2

`docsmith-v2` is the original Claude Code plugin (slash commands, single SKILL.md). `docsmith-universal` is the same skill, restructured for portability + progressive disclosure. They stay behaviorally equivalent; this repo is the one to use when you need other tools or hit context limits.

## License

See repo.
