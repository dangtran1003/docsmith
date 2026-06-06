# Commands: deploy, categorize, publish

The final stages — workspace → target repo → live.

---

## deploy

**Purpose**: copy/sync workspace to the host project (e.g. Docusaurus repo) with transforms.

**Owner**: AI · **Invocation**: `deploy` / `dep` / "publish to repo"

**Environment requirement**: file ops (always). Reads target repo structure.

**Transforms applied**: frontmatter injection, image namespacing (`/img/<slug>/`), MDX escape (`<`, `>`, `{` in prose), category generation.

### FPT compliance gate

When project intake has `compliance: fpt-user-guide`:
1. `verify` checks 12-22 must pass (anti-AI-tells included).
2. `score` must show all docs ≥14.
3. Both auto-run before deploy starts.
4. Failure → deploy refuses, lists issues.
5. Override: `--force-deploy` (logs warning to deployment manifest).

### Flags

- `--dry-run` — detect + plan, exit without writes
- `--target <path>` — override `deploy.target_path` for this run
- `--force` — override conflicts
- `--force-deploy` — skip FPT compliance gate (verify 12-22 + score). Logs warning.
- `--locale <locale>` — single locale
- `--sync-deletes` — propagate workspace deletions to target (default: report orphans only)

### Workflow (full detail: references/deploy-reference.md)

1. FPT compliance gate (if applicable): run `verify --fpt-only` + `score`; block on fail.
2. Translation completeness check (warn if `locales.targets` incomplete).
3. Detect target context (CLAUDE.md/AGENTS.md, docusaurus.config.*, folder signals).
4. Plan file actions (create / update / skip / conflict / delete-if-sync).
5. Show plan; if `--dry-run`, exit.
6. Apply if no unresolved conflicts; create audit folder under `documentation/deployments/`.
7. Save manifest, target-config snapshot, diff, pre-deploy hashes.

File mapping (Docusaurus preset): drafts → `docs/`, translated → `i18n/<locale>/.../`, images → `static/img/<slug>/`, videos → `static/videos/<slug>/`. Detail + presets in `references/deploy-reference.md` and `presets/docusaurus.yaml`.

---

## categorize

**Purpose**: generate Docusaurus `_category_.json` from the sitemap.

**Invocation**: `categorize` / `cat`

Normalize titles (acronyms uppercase: API, CLI, JSON; articles lowercase mid-title; first/last word capitalized). Sidebar position computed from the sitemap pattern order. Display labels respect project intake `Section display names`; slugs stay canonical.

Auto-runs on `deploy` if `generate_categories: true` (Docusaurus preset default). Detail: `references/deploy-reference.md` § Categorize, `templates/CATEGORY_FILE_TEMPLATE.md`, `templates/SITEMAP_PATTERNS_TEMPLATE.md`.

---

## publish

**Purpose**: final human step — get the deployed files into the target repo and live.

**Owner**: HUMAN (the agent does NOT auto-commit; git on the target is the safety net).

**Invocation**: `publish` / `pub`

Checklist:
1. Review the deploy summary and target diff.
2. Coordinate with code/product release if applicable.
3. In target project: `git diff` → `git add` → `git commit` → `git push`.
4. Trigger documentation platform build if not auto-triggered.
5. Verify live site.
6. Announce.

For the full org workflow (MR → CI draft build → review → merge → prod deploy), this maps to the FPT Cloud documentation process: the agent's `deploy` produces the files, then a human opens the MR and the CI/CD pipeline + reviewers take over.

---

## Done

That's the full pipeline. For maintenance over time, use `update` when sources change.
