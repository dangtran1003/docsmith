# Installing docsmith-universal

docsmith installs differently per harness — each AI tool has its own plugin/extension mechanism. Pick your tool below. If you use more than one, install separately for each.

Replace `dangtran1003/docsmith-universal` with your actual repo path if different.

---

## Claude Code

Register the marketplace, then install:

```
/plugin marketplace add dangtran1003/docsmith-universal
/plugin install docsmith@dangtran1003-docsmith-universal
```

The session-start hook nudges the agent to read the skill index when you do documentation work. Then just talk: `docsmith init`, `docsmith run`, `docsmith deploy`.

---

## Codex (CLI & App)

Codex natively discovers skills from the `skills/` directory via the manifest.

**CLI**: open `/plugins`, search `docsmith`, select Install Plugin.

**App**: Plugins sidebar -> find `docsmith` -> click `+` and follow prompts.

(If you distribute via the OpenAI plugins marketplace, point it at this repo. Otherwise clone and add the local path per Codex docs.)

---

## Cursor

In Cursor Agent chat:

```
/add-plugin docsmith
```

Or search "docsmith" in the plugin marketplace UI. The `.cursor-plugin/` manifest + `hooks/hooks-cursor.json` inject skill awareness at session start. Restart Cursor after install so the hook initializes.

---

## Gemini CLI

```
gemini extensions install https://github.com/dangtran1003/docsmith-universal
```

Update later: `gemini extensions update docsmith`.

`gemini-extension.json` sets `contextFileName: GEMINI.md`, pointing the agent at the skill index.

---

## GitHub Copilot CLI

```
copilot plugin marketplace add dangtran1003/docsmith-universal
copilot plugin install docsmith@dangtran1003-docsmith-universal
```

Best for file-based stages (init through score); browser walkthrough needs a separate browser tool.

---

## OpenCode

Tell OpenCode to fetch and follow the install file:

```
Fetch and follow instructions from https://raw.githubusercontent.com/dangtran1003/docsmith-universal/main/.opencode/INSTALL.md
```

Detail: [.opencode/INSTALL.md](.opencode/INSTALL.md).

---

## Any other tool / custom agent (Qwen, GPT, MiniMax, etc.)

**A. Symlink the skill index** into your tool's rules path. From your docs project root:

```bash
/path/to/docsmith-universal/scripts/symlink-setup.sh /path/to/docsmith-universal <tool>
```

`<tool>`: `claude-code`, `cursor`, `cline`, `windsurf`, `aider`, `copilot`, or `all`.

**B. System prompt** pointing at `skills/docsmith/SKILL.md` — full guide + example loop in [adapters/generic-agent/README.md](adapters/generic-agent/README.md).

---

## How it stays small (progressive disclosure)

Every harness reads the same `skills/docsmith/SKILL.md` — a ~1,200-token index. The agent loads individual command files (~500 tokens each) only as needed, and references/templates/fpt only when a command points to them. A typical task loads ~2,000 tokens instead of the full ~49,000. This is why docsmith runs even on small-context models.

---

## Environment capabilities

| Command group | Needs | If missing |
|---|---|---|
| init, module, plan, voice, draft, edit, verify, score | file ops only | always works |
| fetch, update | web/API fetch | use local-file sources |
| walkthrough, record | browser automation (+ ffmpeg for record) | keep screenshot placeholders |
| deploy, publish | git | run git by hand |

Source credentials (when using external sources):

```bash
export NOTION_TOKEN="secret_..."
export GITHUB_TOKEN="ghp_..."
export MYPRODUCT_TEST_USER="..."   # walkthrough
export MYPRODUCT_TEST_PASS="..."
```

---

## Verify it works

Open your tool in a docs project and say `docsmith help`. The agent reads `skills/docsmith/SKILL.md` and lists commands. Then `docsmith init` scaffolds `documentation/`.

---

## Maintainers: keeping versions in sync

All manifests carry a version. Bump them together:

```bash
./scripts/bump-version.sh 1.1.0
```

Then commit and tag `v1.1.0`.

## Troubleshooting

- **Agent loads too much / slow**: the index says "read one command file per task." Some models need a reminder — reinforce in your tool's rules.
- **Windows symlink issues**: copy `skills/docsmith/SKILL.md` to the target path instead, or use WSL / enable Developer Mode.
- **Hook didn't fire**: ensure the plugin installed fully and you restarted the tool; check the hook path in the manifest.
