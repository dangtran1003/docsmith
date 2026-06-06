# Command: verify

**Purpose**: structural and compliance audit of drafts before deploy.

**Owner**: AI · **Invocation**: `verify` / `vf` / "check docs"

## Default 11 checks (always run)

1. No `placehold.co` URLs remain
2. No broken image refs
3. Voice consistency score ≥ threshold
4. Glossary consistency (translated docs)
5. Code blocks unchanged across translations
6. Frontmatter complete
7. Links resolve (internal)
8. Cross-references valid
9. Sitemap entries match draft files
10. Sitemap consistency: all modules use the project pattern; warns when a module is missing a section the pattern includes (non-blocking — **blocking with Pattern D, FPT mandatory sections enforced**)
11. Media compliance: screenshots match density policy per content type; videos within length caps; voiceover/subtitle files exist when strategy expects them; per-locale media follows project strategy

## FPT compliance checks 12-22

Activated ONLY when project intake has `compliance: fpt-user-guide`. Full rules: `fpt/FPT_TEMPLATES.md` § Part 4 (load only when running these checks).

12. **Page titles** (4.1): sentence case, ≤60 chars, no period/colon at end
13. **Section headings** (4.2): not numbered, parallel structure within same level
14. **Introductions** (4.3): ≤2 sentences, lead with user benefit, second person
15. **Prerequisites** (4.4): plain bullets, no ✅ emoji
16. **Procedures** (4.5): numbered list, ≤10 steps, each step starts with a verb
17. **Code examples** (4.13): language tag present, SCREAMING_SNAKE_CASE placeholders, ≤20 lines per block
18. **Button labels** (4.7): no "Click here" / "Nhấn vào đây"
19. **UI references** (4.12): buttons in bold, navigation paths use `→`
20. **Callouts** (4.6): ≤2 per section, correct emoji per type (💡/📝/⚠️/🚨)
21. **Status messages** (4.8-4.9): success/error/loading/empty-state use canonical templates
22. **Anti-AI-tells** (4.15) — CRITICAL, 6 sub-checks:
    - No ✅ ❌ emoji outside callouts
    - Em-dashes ≤1 per paragraph
    - No "...đặc biệt khi X mở rộng qua Y" intro formula
    - Parallel structure varies naturally (not all bullets ±10% same length)
    - "Bước tiếp theo" not rigidly 3 items
    - Verification step used when needed, not rigid in every flow

Checks 12-22 BLOCK deploy when `compliance: fpt-user-guide`. For non-FPT projects they're skipped.

## Flags

- `[<doc-glob>]` — scope to specific docs (faster iteration)
- `--locale <locale>` — verify a target locale's drafts
- `--fpt-only` — run only checks 12-22 (skip 1-11; fast when fixing FPT violations)
- `--no-fpt` — run only checks 1-11 (skip 12-22)

## Output

Report each check pass/fail with file:line for failures and a suggested fix. On any blocking failure, deploy is gated until resolved.

## Next

After verify passes: `score` (if FPT), then `deploy`. See `commands/score.md`, `commands/deploy.md`.
