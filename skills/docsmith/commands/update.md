# Command: update

**Purpose**: detect external source changes and propose draft updates without re-fetching everything. Also detects new/orphan modules in source structure.

**Owner**: AI · **Invocation**: `update` / `up` / "sources changed"

## Workflow

1. Read `documentation/intake/sources.lock.yaml`.
2. For each source, cheap metadata check (Notion edit time, GitHub commit SHA, GDrive revision, URL ETag, file mtime).
3. Build a 3-layer change report:
   - **Content drift**: source content changed → affected drafts to re-evaluate.
   - **Module diff**: modules in source vs in workspace — categorize as new / orphan / scope-drift.
   - **Scope drift**: an existing module's feature list lags the source.
4. User reviews via interactive prompt, picks actions.
5. On confirm:
   - Full-fetch changed sources.
   - Create new module intakes (with `--from-source` auto-fill — see `commands/module.md`).
   - Archive orphan modules (`status: archived`).
   - Update scope-drift module features.
   - Re-run `draft` in Update mode for affected docs (KB inheritance — preserve manual edits, propose deltas only).
   - Re-run `walkthrough --check` for new drift.
6. Update lock file.
7. Generate update inference report at `documentation/intake/.inference/<ts>-update.md`.

Detail: `references/intake-reference.md` § 9.10 (Missing module detection) and § 5 (the update command).

## Flags

- (no args) — check all sources; full diff (content + module structure)
- `<module>` — one module only (skip module structure detection)
- `--from-source <path>` — re-register a source URL/path (overrides lock entry)
- `--no-modules` — content drift only; skip module structure detection (faster)
- `--auto-apply` — fetch and apply all changes without prompt (CI)
- `--resume` — retry previously failed parallel sub-agents (if last run partial)

## Multi-module performance

When ≥5 modules need processing (new + scope-drift combined), the agent MAY spawn parallel sub-agents if its environment supports that (e.g. Claude Code Task tool). Sequential fallback for ≤5 modules or environments without sub-agents. Detail: `references/intake-reference.md` § 9.9.

## Which case is this?

`update` covers several real-world scenarios: content changed (re-draft affected), new module in spec (create + run it), feature deprecated (archive), spec heavily rewritten (consider archive + fresh module instead). The interactive report tells you which applies.

## Next

After update applies changes: re-run affected stages, then `verify`, `score` (if FPT), `deploy`.
