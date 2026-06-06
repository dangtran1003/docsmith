# Commands: run, continue

The orchestrated pipeline. Both AI-owned.

---

## run

**Purpose**: orchestrate the full pipeline from intake to translated drafts.

**Invocation**: `run` / `r` / "generate the docs"

**Requires**: filled project + module intake; environment capabilities for sources/credentials in scope (file ops always; web fetch if external sources; browser if walkthrough runs).

**Workflow**:
1. Validate intakes (see `references/intake-reference.md` § Validation). Stop on critical errors.
2. Resolve layered config (defaults < project < module); snapshot to `documentation/deployments/<ts>/resolved-config.yaml`.
3. Call `fetch` internally (uses lock file if recent).
4. Run pipeline stages in sequence:
   `audience` → `plan` → `voice` → `draft` → `edit` → `walkthrough` → `record` → `translate`.
   Each stage's instructions are in `commands/pipeline-stages.md` (audience/plan/voice/draft/edit), `commands/walkthrough.md`, `commands/record.md`, `commands/translate.md`. Load each as you reach that stage — do NOT load all upfront.
5. Pause at the configured gate (default: `after-draft`).
6. Save state to `documentation/.run-state/<module>.yaml` (per-module — multiple modules can be in different stages simultaneously).
7. Print resume instructions.

**Flags**:
- `[<module>]` — single module instead of all
- `--pause-at <gate>` — override configured pause point
- `--from <stage>` — start from a specific stage (e.g. `--from walkthrough`)
- `--no-prompt` — CI mode: skip interactive fill prompts, fail if required intake fields empty

**Pause gates**: `after-plan`, `after-draft` (default), `before-walkthrough`, `after-walkthrough`, `before-deploy`, `never`.

**Interactive fill**: each stage checks ITS required intake fields. If empty and not `--no-prompt`, prompt the user inline, write the answer back to intake, continue. Required-field tables per stage: `references/intake-reference.md` § 10.

---

## continue

**Purpose**: resume a paused `run`.

**Invocation**: `continue` / `c` / "resume"

Resume from `documentation/.run-state/<module>.yaml`:
- No args: if exactly one module paused, resume it. If multiple, list and ask which. If none, error.
- `<module>`: resume that module's state.

If state stale (>7 days) or workspace modified outside docsmith since last `run`, warn before resuming.

---

## FPT note

When `compliance: fpt-user-guide`:
- `plan` uses Sitemap Pattern D (mandatory sections enforced)
- `voice` uses FPT voice chart matrix
- pipeline still pauses at the same gates
- after the pipeline, `verify` (22 checks) and `score` (≥14) are required before `deploy`

Each affected stage file tells you what to load from `fpt/`. Do not pre-load.

## Next

After the pause gate and review: `continue`, then `verify`, `score` (if FPT), `deploy`.
