# Command: score

**Purpose**: quality scoring against FPT Cloud content standards. 10 criteria × 0-2 = max 20.

**Owner**: AI · **Invocation**: `score` / "score docs"

**Authority**: `fpt/SCORECARD_TEMPLATE.md` (load this when running — it has the full criteria, evidence rubric, and output format) and `fpt/FPT_TEMPLATES.md` § Part 7.

## When to use

- REQUIRED when project intake has `compliance: fpt-user-guide` (deploy blocked until pass).
- Optional otherwise (still useful as a quality check).
- Run after `verify` passes, before `deploy`.

## Behavior

1. For each draft in scope (module or specific doc):
   - Read the draft.
   - Evaluate each of the 10 criteria, assign 0/1/2.
   - List evidence per criterion.
   - List fix suggestions for any criterion scoring <2.
   - Run the anti-AI-tells checklist (6 patterns) — separate from the score.
2. Write per-doc report: `documentation/score/<module>/<doc>.md`.
3. Write module summary: `documentation/score/<module>/_summary.md`.
4. Exit:
   - All docs ≥14 AND no anti-AI-tells violations → success, deploy unblocked.
   - Any doc <14 OR any anti-AI-tells violation → fail, list issues, deploy blocked.

## Scoring tiers

- 0-8: Poor — rewrite needed
- 9-13: Fair — major edits needed
- 14-17: Good — publishable (deploy-ready)
- 18-20: Excellent — ready to publish

The deploy gate is per-doc, not average: any single doc below 14 blocks the module even if the average is ≥14.

## The 10 criteria (summary — full rubric in fpt/SCORECARD_TEMPLATE.md)

Clear: (1) context-setting intro, (2) standard guide structure, (3) active voice with "bạn", (4) visual support.
Practical: (5) WHY before HOW, (6) next-action guidance, (7) value/risk callouts.
Consistent: (8) terminology & capitalization, (9) punctuation & formatting, (10) links & references.

## Flags

- `<module>` — score one module (default: all)
- `[<doc-glob>]` — scope to specific docs
- `--locale <locale>` — score a translated locale (default: source only)
- `--no-anti-ai-tells` — skip the anti-AI-tells checklist (still scores 10 criteria)
- `--fix` — when a criterion <2, AI auto-attempts a fix and re-scores (experimental)

## Honest limitation

AI scoring is heuristic — it reasons about each criterion in prose. Human scoring may differ. Treat the score as a strong signal, not ground truth. For FPT compliance, a human CSO Editor should still review before publish.

## Next

If all docs ≥14 and no anti-AI-tells violations: `deploy`. Otherwise fix the listed issues and re-run `score`.
