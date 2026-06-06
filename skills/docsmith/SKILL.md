---
name: docsmith
description: "Build product documentation through a staged pipeline (audience, plan, voice, draft, self-review, screenshot capture, translate, verify, score, deploy). Follows PRC-010; can enforce FPT Cloud content standards. Use when asked to create, draft, plan, review, or publish documentation for a product. Commands: init, module, fetch, run, continue, audience, plan, voice, draft, edit, walkthrough, record, translate, verify, score, update, categorize, deploy, publish."
version: 1.0.0
license: see repo
---

# docsmith — Documentation automation

docsmith builds product documentation through a staged pipeline: analyze audience → plan sitemap → set voice → draft → self-review → capture screenshots → translate → verify → score → deploy. It follows the PRC-010 process and can enforce FPT Cloud content standards.

**You are an AI agent reading this index.** This file is intentionally small. Do NOT try to load the whole skill at once — that wastes context and degrades quality. Instead, load only the one command file you need for the current task, then load references it points to **only if** that command tells you to.

## How to use this skill (progressive disclosure)

1. The user names a command (or describes a task that maps to one).
2. Read the matching file in `commands/` — that's your full instruction set for the task.
3. That command file will tell you which `references/`, `templates/`, or `fpt/` files to load **if** the task needs them. Load those on demand, not upfront.
4. Never pre-load `references/`, `templates/`, or `fpt/` "just in case." They are large and only relevant to specific steps.

This keeps each task within a small context budget so docsmith runs even on models with limited context windows.

## Commands → file to read

| User says | Read this file | Owner |
|---|---|---|
| `init` / "set up docs" | `commands/init.md` | AI |
| `module` / "add a module" | `commands/module.md` | AI |
| `fetch` / "pull sources" | `commands/fetch.md` | AI |
| `run` / "generate the docs" | `commands/run.md` | AI |
| `continue` / "resume" | `commands/run.md` (§ continue) | AI |
| `audience` | `commands/pipeline-stages.md` (§ audience) | AI |
| `plan` | `commands/pipeline-stages.md` (§ plan) | AI |
| `voice` | `commands/pipeline-stages.md` (§ voice) | AI |
| `draft` | `commands/pipeline-stages.md` (§ draft) | AI |
| `edit` | `commands/pipeline-stages.md` (§ edit) | AI |
| `walkthrough` / `wt` / "capture screenshots" | `commands/walkthrough.md` | AI |
| `record` / "make video" | `commands/record.md` | AI |
| `translate` | `commands/translate.md` | AI |
| `verify` / "check docs" | `commands/verify.md` | AI |
| `score` / "score docs" | `commands/score.md` | AI |
| `update` / "sources changed" | `commands/update.md` | AI |
| `categorize` | `commands/deploy.md` (§ categorize) | AI |
| `deploy` / "publish to repo" | `commands/deploy.md` | AI |
| `publish` | `commands/deploy.md` (§ publish) | Human |
| `intake-help` | `references/intake-reference.md` | — |
| `help` | this file | — |

Aliases: `i`=init, `m`=module, `f`=fetch, `r`=run, `c`=continue, `dr`=draft, `ed`=edit, `wt`=walkthrough, `rec`=record, `tr`=translate, `vf`=verify, `up`=update, `cat`=categorize, `dep`=deploy, `pub`=publish.

## Invocation syntax — adapt to your environment

docsmith was first built as slash commands (`/docsmith init`). In other tools there are no slash commands. Treat **any** of these as the same request:

- `/docsmith init` (Claude Code)
- "docsmith init" / "run docsmith init" (natural language)
- "use docsmith to set up docs" (intent)

Map the user's phrasing to the command table above, read that command file, and follow it. The leading `/docsmith` is optional everywhere except Claude Code.

## Universal rules (always apply — these are short on purpose)

**Path scoping (safety).** Only write inside `documentation/` (the workspace) or the configured `deploy.target_path` (deploy command only). Reject writes outside these roots. This is the core safety guarantee.

**Re-run protocol (safety).** Before producing output that already exists, default to: read existing as canonical knowledge, propose deltas (NEW / UPDATE / REMOVE / KEEP) per item, preserve untouched content verbatim. Never silently regenerate — that destroys manual edits. Ask before overwrite.

**Configuration layers.** Defaults (from `presets/<name>.yaml`) < project intake (`documentation/intake/project.md`) < module intake (`documentation/intake/modules/<n>.md`). Higher overrides lower for the same field; sources are cumulative. Intake forms are markdown with checkboxes and backtick fields — no YAML for the user to write.

**Workspace layout.** Everything docsmith produces lives under `documentation/`: `intake/`, `plan/`, `standards/`, `drafts/<locale>/<module>/`, `walkthrough/`, `images/<module>/`, `videos/`, `score/<module>/`, `deployments/`, `archive/`. Deploy syncs from here to the target repo.

**FPT compliance.** If project intake sets `compliance: fpt-user-guide`, several commands change behavior (Sitemap Pattern D, FPT voice chart, 22 verify checks, required scoring, deploy gate). Each affected command file says what to load from `fpt/` and when. Do not load `fpt/` files unless a command directs you to.

## What the agent environment must provide

docsmith is pure instructions. The capabilities come from YOUR environment, not from docsmith:

- **File operations** — create/read/write/edit files and folders (required)
- **Browser automation** — for `walkthrough` screenshot capture and `record` (required only for those commands)
- **Git** — for `deploy`/`publish` (required only for those)
- **Web/API fetch** — for `fetch` from Notion/GitHub/GDrive/URL (required only when using external sources)

If your environment lacks a capability, the dependent command can't run, but the rest of docsmith still works. For example, an agent with only file tools can still init, plan, draft, edit, verify, and score — just not walkthrough or deploy.

## Reference files (load only when a command points you to them)

- `references/intake-reference.md` — intake form fields, parsing rules, layered config, fetch/module/run/continue/update detail (large — ~1,200 lines)
- `references/process-reference.md` — PRC-010 process detail
- `references/deploy-reference.md` — deploy + categorize transforms
- `references/translate-reference.md` — block-level translation rules, review modes
- `references/tools-reference.md` — browser automation reference
- `fpt/FPT_TEMPLATES.md` — FPT Cloud content standards (structure, writing rules, voice matrix, anti-AI-tells)
- `fpt/SCORECARD_TEMPLATE.md` — 10-criteria scorecard
- `templates/*.md` — output templates for each artifact (intake forms, audience profile, sitemap, voice chart, etc.)
- `presets/*.yaml` — deploy presets (docusaurus, standalone)

See `INSTALL.md` to wire docsmith into your specific tool. See `README.md` for the overview.
