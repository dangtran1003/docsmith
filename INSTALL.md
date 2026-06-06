# Installing docsmith

docsmith works across many AI coding tools. This guide covers installing it **from your own GitHub repo** — which works as soon as the repo is pushed and public. No marketplace approval needed.

> Replace `dangtran1003/docsmith-universal` everywhere below with your actual repo path.

---

## Two kinds of install (read this first)

| | From your repo (this guide) | Official marketplace |
|---|---|---|
| Works now? | ✅ Yes, once repo is public | ❌ Needs submission/approval per platform |
| How | Point the tool at your GitHub repo | `/plugin install ...@official` |
| Effort | Push to GitHub, done | Apply to Anthropic / OpenAI / Cursor separately |

Everything below is the **from-your-repo** path. For official marketplaces, see [§ Publishing to official marketplaces](#publishing-to-official-marketplaces) at the end.

---

## Step 0 — Push the repo (one time)

```bash
cd docsmith-universal
git remote add origin https://github.com/dangtran1003/docsmith-universal.git
git push -u origin main
git push origin v1.0.0
```

The repo must be **public** so tools can fetch it. Verify by opening the GitHub URL in a browser.

---

## Quick pick

| Your tool | Jump to |
|---|---|
| Claude Code | [§ Claude Code](#claude-code) — native plugin |
| Gemini CLI | [§ Gemini CLI](#gemini-cli) — native extension |
| OpenCode | [§ OpenCode](#opencode) — fetch & follow |
| Cursor | [§ Cursor](#cursor) — symlink (marketplace needs submission) |
| Cline / Roo | [§ Cline](#cline-roo-code) — symlink |
| Windsurf | [§ Windsurf](#windsurf) — symlink |
| Aider | [§ Aider](#aider) — symlink + flag |
| GitHub Copilot | [§ Copilot](#github-copilot) — symlink |
| Qwen / GPT / custom | [§ Custom agent](#custom-agent-qwen-gpt-minimax) — system prompt |

Tools split into two groups:
- **Native install** (Claude Code, Gemini CLI, OpenCode): one command pulls from your repo.
- **Symlink install** (Cursor, Cline, Windsurf, Aider, Copilot): clone the repo once, run a script that links the skill into the tool's rules folder. (Their marketplaces require submission, so symlink is the reliable from-repo path.)

---

## Claude Code

**Native plugin.** Register your repo as a marketplace, then install:

```
/plugin marketplace add dangtran1003/docsmith-universal
/plugin install docsmith@dangtran1003-docsmith-universal
```

**Verify**: type `docsmith help` — the agent lists docsmith commands.

**Use**: in a docs project directory:
```
docsmith init
docsmith run
docsmith deploy
```

---

## Gemini CLI

**Native extension.** Install straight from the repo URL:

```
gemini extensions install https://github.com/dangtran1003/docsmith-universal
```

Update later:
```
gemini extensions update docsmith
```

**Verify**: `docsmith help`.

---

## OpenCode

**Fetch & follow.** Tell OpenCode:

```
Fetch and follow instructions from https://raw.githubusercontent.com/dangtran1003/docsmith-universal/main/.opencode/INSTALL.md
```

OpenCode reads the install file and wires the skill in. Detail: [.opencode/INSTALL.md](.opencode/INSTALL.md).

---

## Symlink install (Cursor, Cline, Windsurf, Aider, Copilot)

These tools read project "rules" files. The script links docsmith's skill index into the right path for each. Clone the repo once, then run the script from **your docs project directory**.

```bash
# One time: clone the repo somewhere stable
git clone https://github.com/dangtran1003/docsmith-universal.git ~/tools/docsmith-universal

# In your docs project root, link it for your tool (or "all"):
~/tools/docsmith-universal/scripts/symlink-setup.sh ~/tools/docsmith-universal <tool>
```

`<tool>` = `cursor`, `cline`, `windsurf`, `aider`, `copilot`, `claude-code`, or `all`.

What the script links per tool:

### Cursor
- Links to `.cursor/rules/docsmith.mdc` + top-level `AGENTS.md`.
- Restart Cursor so it picks up the rule.
- Use in Agent chat: `docsmith init`.

### Cline / Roo Code
- Links to `.clinerules/docsmith.md` + `AGENTS.md`.
- Read automatically. Use: `docsmith run`.

### Windsurf
- Links to `.windsurf/rules/docsmith.md` + `AGENTS.md`.
- Cascade reads it automatically.

### Aider
- Links to `CONVENTIONS.md` + `AGENTS.md`.
- Run aider with: `aider --read CONVENTIONS.md` (or add `read: [CONVENTIONS.md]` to `.aider.conf.yml`).
- Note: aider has no browser — `walkthrough`/`record` need a separate browser tool; everything else works.

### GitHub Copilot
- Links to `.github/copilot-instructions.md` + `AGENTS.md`.
- Read automatically in agent mode (supported IDEs).

**Verify any of these**: open the tool in the docs project, say `docsmith help`.

**Windows note**: if symlinks fail, copy `skills/docsmith/SKILL.md` to the target path instead, or use WSL / enable Developer Mode.

---

## Custom agent (Qwen, GPT, MiniMax, etc.)

No plugin system — point your agent's system prompt at the skill index.

1. Clone the repo. Note the absolute path to `skills/docsmith/`.
2. Add to your agent's system prompt:

```
You have access to docsmith, a documentation skill stored as files.
Index: <PATH>/skills/docsmith/SKILL.md — read it FIRST when the user wants
to create/plan/review/score/publish documentation. It maps commands to files
in <PATH>/skills/docsmith/commands/. Read ONLY the command file for the task,
then follow it. Load references/templates/fpt files only when a command says to.
Never load the whole skill at once.
```

3. Give the agent file read/write tools.

Full guide with an example agent loop and tool definitions: [adapters/generic-agent/README.md](adapters/generic-agent/README.md).

---

## After install — first run

In a directory where you want docs generated:

```
docsmith init          # scaffolds documentation/ workspace + intake form
docsmith module <name> # add a feature area (e.g. instances)
docsmith run           # full pipeline; pauses after draft for your review
docsmith continue      # resume after review
docsmith verify        # audit
docsmith score         # quality score (required if FPT compliance on)
docsmith deploy        # sync to your docs repo
```

Most people only need `init`, `module`, `run`, `deploy`. The rest are individual pipeline stages.

---

## Environment capabilities

docsmith is pure instructions — capabilities come from your tool:

| Commands | Need | If your tool lacks it |
|---|---|---|
| init, module, plan, voice, draft, edit, verify, score | file read/write | (every tool has this) |
| fetch, update | web/API fetch | use local-file sources instead |
| walkthrough, record | browser automation (+ ffmpeg for record) | keep screenshot placeholders, capture manually |
| deploy, publish | git | run the git steps by hand |

Source credentials, when pulling from external systems — set as environment variables:

```bash
export NOTION_TOKEN="secret_..."      # Notion sources
export GITHUB_TOKEN="ghp_..."         # private GitHub sources
export MYPRODUCT_TEST_USER="..."      # walkthrough login
export MYPRODUCT_TEST_PASS="..."
```

---

## Why it stays light (progressive disclosure)

Every tool reads the same `skills/docsmith/SKILL.md` — a ~1,200-token index. The agent loads one command file (~500 tokens) per task, and reference/template/fpt files only when a command points to them. A typical task loads ~2,000 tokens instead of the full ~49,000. That's why docsmith runs even on small-context models.

---

## Troubleshooting

**`docsmith help` does nothing / agent doesn't know docsmith**
The tool didn't load the skill index. Native installs: confirm the plugin/extension installed and restart the tool. Symlink installs: confirm you ran the script in the docs project directory and the symlink exists (`ls -la AGENTS.md`).

**Agent loads too much / runs slowly**
Some models over-read. Reinforce in the tool's rules: "Read one command file per task; don't load reference/template files unless a command names them." The index already says this; a nudge helps weaker models.

**`/plugin marketplace add` fails (Claude Code)**
Repo must be public and contain `.claude-plugin/marketplace.json` at the root. Re-check the repo path and that you pushed `main`.

**Cursor `/add-plugin docsmith` says not found**
That command needs docsmith on Cursor's marketplace (submission required). Use the symlink install for Cursor instead.

**Symlink not supported (Windows)**
Copy `skills/docsmith/SKILL.md` to the target rules path manually, or use WSL / enable Developer Mode.

**Hook didn't fire (Claude Code / Cursor)**
Confirm the plugin installed fully and you restarted the tool. Check the hook path in the manifest matches `hooks/`.

---

## Updating

- **Claude Code**: `/plugin marketplace update` then reinstall, or it auto-updates depending on settings.
- **Gemini CLI**: `gemini extensions update docsmith`.
- **Symlink installs**: `cd ~/tools/docsmith-universal && git pull` — symlinks point at the repo, so they pick up changes automatically.

---

## Publishing to official marketplaces

Optional, later. To get one-command installs like `/plugin install docsmith@official` (no repo path), submit to each platform separately:

- **Anthropic (Claude Code)**: apply to the official plugin marketplace.
- **OpenAI (Codex)**: submit to the OpenAI plugins repo (Codex uses a fork-based distribution).
- **Cursor**: submit to Cursor's plugin marketplace for `/add-plugin docsmith` to resolve.

Each has its own review process. The from-repo install in this guide works regardless and is the recommended starting point.

---

## Maintainers: version sync

All manifests carry a version. Bump them together:

```bash
./scripts/bump-version.sh 1.1.0
git commit -am "Release v1.1.0" && git tag v1.1.0
git push && git push --tags
```
