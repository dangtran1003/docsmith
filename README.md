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
| 1 | `skills/docsmith/SKILL.md` — thin index | ~1,200 tokens | Always (agent startup) |
| 2 | `skills/docsmith/commands/<cmd>.md` — one per command | ~500 tokens each | When that command runs |
| 3 | `skills/docsmith/{references,templates,fpt}/` | large | Only when a command points to them |

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

## Install

How you install depends on what your tool supports. Find your tool below; full step-by-step (verify steps, OS caveats, official-marketplace publishing) lives in **[INSTALL.md](INSTALL.md)**.

> Examples use `dangtran1003/docsmith-universal`. Replace it with your own repo path if you forked it. The repo must be **public** so tools can fetch it.

### 1. Native install — one command pulls from the repo

These harnesses have a real plugin/extension system:

| Tool | Install |
|---|---|
| **Claude Code** | `/plugin marketplace add dangtran1003/docsmith-universal`<br>`/plugin install docsmith@dangtran1003-docsmith-universal` |
| **Gemini CLI** | `gemini extensions install https://github.com/dangtran1003/docsmith-universal`<br>update later: `gemini extensions update docsmith` |
| **OpenCode** | Tell it: *“Fetch and follow `https://raw.githubusercontent.com/dangtran1003/docsmith-universal/main/.opencode/INSTALL.md`”* |

### 2. Symlink install — clone once, link into the tool's rules folder

**Cursor · Cline / Roo · Windsurf · Aider · GitHub Copilot.** Their marketplaces require submission, so the reliable from-repo path is a symlink. Clone once, then run the helper from your **docs project root**:

```bash
git clone https://github.com/dangtran1003/docsmith-universal.git ~/tools/docsmith-universal
~/tools/docsmith-universal/scripts/symlink-setup.sh ~/tools/docsmith-universal <tool>
```

`<tool>` = `cursor` · `cline` · `windsurf` · `aider` · `copilot` · `claude-code` · `all`. The script links docsmith into each tool's rules file (`.cursor/rules/`, `.clinerules/`, `.windsurf/rules/`, `CONVENTIONS.md`, `.github/copilot-instructions.md`) plus a top-level `AGENTS.md`. Per-tool notes — and the Windows fallback (copy `skills/docsmith/SKILL.md` if symlinks fail) — are in [INSTALL.md](INSTALL.md).

> Aider has no browser, so `walkthrough`/`record` need a separate capture tool; everything else works.

### 3. Custom agent — any model, no plugin system

**Qwen · GPT · MiniMax · DeepSeek · Llama · …** Point your agent's system prompt at the skill index and give it file read/write tools:

```
You have access to docsmith, a documentation skill stored as files.
Index: <PATH>/skills/docsmith/SKILL.md — read it FIRST for any doc task.
It maps commands to files in skills/docsmith/commands/. Read ONLY the command
file for the task, then follow it. Load references/templates/fpt only when a
command says to. Never load the whole skill at once.
```

Full example loop + tool definitions: [adapters/generic-agent/README.md](adapters/generic-agent/README.md).

> **Codex** ships a `.codex-plugin/` manifest — see [INSTALL.md](INSTALL.md) for its current status.

**Verify any install:** in the tool's chat, type `docsmith help` — the agent should list docsmith's commands.

## First run

In a directory where you want docs generated:

```
docsmith init          # scaffold workspace + intake form
docsmith module <name> # add a feature area (e.g. instances)
docsmith run           # full pipeline; pauses after draft for review
docsmith continue      # resume after your review
docsmith deploy        # sync to your docs repo
```

Most people only need `init`, `module`, `run`, `deploy` — the rest are individual pipeline stages.

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

Set `compliance: fpt-user-guide` in `documentation/intake/project.md` to enforce FPT Cloud standards: Sitemap Pattern D, FPT voice chart, 22 verify checks (including anti-AI-tells), required 20-point scorecard (≥14 to deploy), and a deploy gate. Details live in `skills/docsmith/fpt/` and load only when those commands run.

## Relationship to docsmith-v2

`docsmith-v2` is the original Claude Code plugin (slash commands, single SKILL.md). `docsmith-universal` is the same skill, restructured for portability + progressive disclosure. They stay behaviorally equivalent; this repo is the one to use when you need other tools or hit context limits.

## License

See repo.
