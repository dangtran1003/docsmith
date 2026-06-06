# Command: init

**Purpose**: scaffold a docsmith workspace at the current directory. One-time setup.

**Owner**: AI

**Invocation**: `init` / `i` / "set up docs" / "/docsmith init"

## Pre-checks

1. If a `documentation/` folder already exists at the current directory:
   - Inspect its contents. If it has files NOT matching docsmith's structure (e.g., user-authored docs), STOP and report. Suggest `--force` only after the user moves or backs up content.
   - If contents match docsmith structure (intake/, plan/, etc.) → re-run protocol gate (see SKILL.md § universal rules).
2. If running in a directory with a `docusaurus.config.{js,ts,mjs}` AND user did NOT specify `--target`:
   - Suggest in-place mode and confirm with user.
   - If confirmed: set `deploy.target_path = .` in pre-fill.
   - If declined: ask for sibling target path.
3. If running in a directory with a `package.json` AND no `docusaurus.config`:
   - This is an unrelated Node project. Confirm intent before scaffolding.
4. If running in a non-empty directory with no recognizable config:
   - List existing folders/files. Ask user to confirm or move first. Refuse to scaffold next to user content silently.

## Behavior

1. Detect host project context (per pre-checks): `docusaurus.config.{js,ts,mjs}` present → suggest `docusaurus` preset; otherwise `standalone`. Load the chosen preset from `presets/<name>.yaml`.
2. Inspect target if Docusaurus: read `<target>/CLAUDE.md` (or `<target>/AGENTS.md`), parse `docusaurus.config` for paths.
3. Create directory structure (see § Workspace layout below). All paths inside `documentation/`.
4. Create or update `.gitignore`:
   - If `.gitignore` exists at project root: APPEND a docsmith block between `# BEGIN docsmith` and `# END docsmith` markers. Don't duplicate on re-run.
   - If none: create one with the block.
   - Entries:
     ```
     # BEGIN docsmith
     documentation/.cache/
     documentation/videos/raw/
     documentation/.run-state/
     # END docsmith
     ```
5. Pre-fill `project.md` from `templates/PROJECT_INTAKE_TEMPLATE.md` with detected values (product slug from package.json or directory name; deploy target from inspected Docusaurus path; etc.).
6. Print: "Workspace scaffolded. Edit documentation/intake/project.md, then run `module <n>` for each feature area."

## Flags

- `--from-source <path-or-url>` — AI auto-fills intake from source document(s). Multiple sources comma-separated. See § From-source mode.
- `--force` — overwrite existing intake files (requires confirm).
- `--in-place` — explicitly request in-place mode (skip prompt when in Docusaurus repo).
- `--reformat-intake` — re-render existing intake with current template (preserves filled values; backup at `.backup-pre-<version>/`).
- `--resume` — retry previously failed parallel sub-agents from last `init --from-source` run with >5 modules. Only when last run reported partial completion.
- `--upgrade-from-1.4` — read existing `.docsmithrc.yaml`, pre-fill `project.md` (deprecated compat).

## From-source mode

Use `--from-source` to skip manual intake authoring. AI reads BA doc / PRD / existing docs, infers fields, writes `project.md`.

1. **Fetch source(s)** using fetch logic (Notion / GitHub / GDrive / URL / file) — see `commands/fetch.md` and `references/intake-reference.md` § External source fetching.
2. **Infer fields** by category:
   - **Facts** (high confidence): direct quotes — product name, audience role, module names, feature lists.
   - **Guesses** (medium): inferred — primary goal, voice tone, scope. Marked `← AI guess` in intake.
   - **Defaults** (no data): conservative fallback. Marked `← default applied`.
3. **Interactive Q&A** for fields source doesn't cover: source language (confirm), target locales, deploy preset + target path, walkthrough credential env var names, voiceover strategy (if videos), pause gate preference.
4. **Write `project.md`** with inline `> Auto-filled from <source>: "<quote>"` annotations and `← AI guess` markers.
5. **Detect modules** from source structure; prompt: "Create module intake for each? Y/N/select".
6. **Generate inference report** at `documentation/intake/.inference/<timestamp>-project.md` (template: `templates/INTAKE_INFERENCE_REPORT_TEMPLATE.md`).
7. **Print summary**:
   ```
   ✓ Created project.md (8 facts, 4 guesses, 7 defaults, 3 asked)
   ✓ Detected 2 modules: instances, storage
   ⚠ 4 fields marked "← AI guess" — verify before run
   📋 Inference report: documentation/intake/.inference/<timestamp>-project.md
   ```

**Re-run with `--from-source`** (source updated): values matching AI's last inference → safe to re-infer; values BA edited manually → preserved (hash check); show diff before applying; re-run protocol gate.

## Workspace layout created

```
documentation/
├── intake/
│   ├── project.md
│   ├── modules/
│   ├── .inference/
│   └── sources.lock.yaml
├── plan/
├── standards/
├── drafts/
├── walkthrough/
├── images/
├── scripts/
├── videos/
├── score/
├── deployments/
├── archive/
├── .cache/
└── .run-state/
```

## FPT note

If the user wants FPT Cloud compliance, ensure `project.md` § 4 advanced sets `compliance: fpt-user-guide`. From-source mode should ask. This changes plan/voice/verify/score/deploy behavior later — see `fpt/FPT_TEMPLATES.md` (load only when those commands run).

## Next

After init: `module <n>` to add feature areas, then `run`. See `commands/module.md`.
