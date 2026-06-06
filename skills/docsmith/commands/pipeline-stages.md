# Commands: audience, plan, voice, draft, edit

The five core pipeline stages. All AI-owned. Each can run standalone or be chained by `run`.

**Shared behavior** (all five):
- Read resolved config from intake (defaults < project < module).
- **Interactive fill**: if a stage needs an empty intake field, prompt the user inline and write the answer back to intake. Avoids upfront full-form fill. Per-stage required fields + prompt format: `references/intake-reference.md` § 10.
- Re-run protocol applies (if output exists, gate — see SKILL.md).
- Write to the conventional output path.
- Return control — do NOT chain to the next stage (that's `run`'s job).
- `--no-prompt` flag: fail immediately if a required field is empty (CI mode).

---

## audience

**Output**: `documentation/plan/audience-profile.md` from `templates/AUDIENCE_PROFILE_TEMPLATE.md`.
**Input**: intake `Audience` section.
Produces a narrative profile: personas, technical level, primary goals, motivations. Used as context by later stages.

---

## plan

**Outputs**:
- `documentation/plan/documentation-plan.md` from `templates/DOCUMENTATION_PLAN_TEMPLATE.md`
- `documentation/plan/sitemap.md`

**Input**: intake `Scope` (per module).

Sitemap follows the project's pattern (from project intake § Sitemap pattern) and per-module section selection. Canonical section types and patterns: `templates/SITEMAP_PATTERNS_TEMPLATE.md`.

- Patterns A (Learning path), B (Task-first), C (Custom): AI warns when a module is missing a section the pattern includes, but doesn't auto-fix.
- **Pattern D (FPT User Guide)**: only when `compliance: fpt-user-guide`. Mandatory sections (overview, initial-setup, quick-starts, tutorials) are ENFORCED — a module missing any mandatory section STOPS planning and prompts the user. Load `templates/SITEMAP_PATTERNS_TEMPLATE.md` § Pattern D and `fpt/FPT_TEMPLATES.md` § Part 2 only when compliance is set.

**Flag**: `--migrate-sitemap` — for old workspaces: AI proposes a pattern, confirms, updates intakes.

---

## voice

**Output**: `documentation/standards/voice-chart.md` from `templates/VOICE_CHART_TEMPLATE.md`.

- Default: quick voice chart.
- `--full`: also generates UX text patterns + content scorecard.
- **FPT**: when `compliance: fpt-user-guide`, generate the FPT voice chart (3 principles × 6 aspects matrix, vocabulary guide, 5 tone variants) instead of the generic chart. Load `templates/VOICE_CHART_TEMPLATE.md` § FPT Cloud Preset and `fpt/FPT_TEMPLATES.md` § Part 5 only then.

---

## draft

**Output**: `documentation/drafts/<source-locale>/<feature>/<doc>.md`.
**Input**: cached sources from `.cache/sources/`, plus audience profile, sitemap, voice chart.

- Uses `templates/CONTENT_TYPE_TEMPLATES.md` for per-type structure (tutorial / how-to / concept / reference).
- Image refs: workspace-absolute paths `/images/<feature>/<asset>.png`. For screenshots not yet captured, use placeholder: `![<detailed alt text>](https://placehold.co/600x400)` placed right after the step it illustrates. `walkthrough` replaces these later.
- Caption rules: `templates/MEDIA_POLICY_TEMPLATE.md` § 3.5.
- Video markers: `<!-- VIDEO id: <id> -->` per `templates/VIDEO_SCRIPT_TEMPLATE.md`.
- **FPT**: when `compliance: fpt-user-guide`, follow content writing rules 4.1-4.15 from `fpt/FPT_TEMPLATES.md` § Part 4 — especially 4.15 anti-AI-tells. Load that file only when compliance is set.

---

## edit

Five self-review passes over each draft:
1. Voice match (against voice chart)
2. UX text patterns
3. Clarity / reading level
4. Accuracy markers
5. Links / cross-references

**Flag**: `--from-review <file>` — apply a reviewer's feedback file (Markdown with `// FEEDBACK:` annotations).

- **FPT**: edit pass should also check anti-AI-tells patterns (`fpt/FPT_TEMPLATES.md` § 4.15) when compliance is set.

---

## Next

After `edit`: `walkthrough` (screenshots), `record` (videos, if any), `translate` (locales). Then `verify`, `score` (if FPT), `deploy`.
