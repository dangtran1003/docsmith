# Command: walkthrough (wt)

**Purpose**: verify drafts against the live product and capture real screenshots, replacing placeholders.

**Owner**: AI

**Invocation**: `walkthrough` / `wt` / "capture screenshots"

**Environment requirement**: browser automation (Claude in Chrome extension, Playwright MCP, or any browser tool your agent has) AND test account credentials as env vars. If your environment has no browser capability, this command can't run — but the rest of docsmith still works.

**Interactive fill**: if product URL or credential env var names are empty in intake, prompt inline and write back. Verify env vars are actually set in the shell before proceeding. Required fields: `references/intake-reference.md` § 10 (walkthrough).

**Media policy**: respects screenshot density rules and per-locale strategy from project intake § 11 (module § 8 overrides). Default "source-only" capture (one screenshot reused across locales). Density rules per content type, style, aspect ratio: `templates/MEDIA_POLICY_TEMPLATE.md`.

## Three-phase pipeline

```
A: VERIFY    wt --check       → drift report (read-only)
   ↓
   GATE      decisions        (auto-fix / manual-fix / product-bug / skip)
   ↓
B: APPLY     wt --apply       → update drafts per decisions
   ↓
C: CAPTURE                    → screenshots, replace placeholders
```

**Default** (no flag): A → interactive gate → B → C.

**Phase A — VERIFY**: scan drafts for `https://placehold.co/` URLs and existing image refs. Build a capture plan: for each placeholder, record doc path, step, alt text, target filename (derived from alt text → kebab-case → `images/<module>/<name>.png`). Navigate the product UI per draft steps. Compare UI to alt text descriptions → drift report.

**Phase B — DRIFT GATE**: categorize each mismatch by confidence:
- HIGH — clear label/text change (e.g. doc says "Submit", UI says "Save") → auto-fix doc
- MEDIUM — ambiguous → prompt user per item
- LOW — flow doesn't exist → likely product bug, flag for dev team, don't change doc

**Phase C — APPLY + CAPTURE**: capture screenshot at each correct state, save to `documentation/images/<module>/<filename>.png`, replace the `placehold.co` URL in the draft with the local path. Keep alt text unchanged.

## Flags

- `--check` — Phase A only; fast; drift monitoring
- `--apply` — B + C with existing decisions
- `--skip-drift` — C only; first runs or known-clean drafts
- `--auto-apply-high-confidence` — skip gate, auto-apply HIGH-confidence fixes
- `--locale <locale>` — verify against a translated locale (needs product UI in that locale)

Drift report format: `templates/DRIFT_REPORT_TEMPLATE.md`. Test cases: `templates/WALKTHROUGH_TEST_CASE_TEMPLATE.md`. Items marked `product-bug` tracked in `walkthrough/active-product-bugs.yaml` across runs; auto-resolved when UI matches doc.

Browser automation detail: `references/tools-reference.md`.

## When a screenshot can't be captured

If a screenshot needs data state the agent can't create reliably (long-running process, specific historical data, customer records): KEEP the placeholder, document the reason in the walkthrough execution record. Don't delete; don't capture an inaccurate substitute.

## Next

After walkthrough: `record` (if videos), `translate`, then `verify`.
