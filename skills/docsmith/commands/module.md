# Commands: module, fetch

Two setup commands. Both AI-owned.

---

## module

**Purpose**: manage module intake files (one per feature area).

**Invocation**: `module` / `m` / "add a module"

**Sub-commands**:
```
module <n>                          # create new module
module <n> --from <existing>        # clone from another module
module <n> --from-source <path>     # AI auto-fill from source
module list                         # list modules with status
module archive <n>                  # mark archived (skipped in run)
module unarchive <n>                # un-archive
```

**Create behavior**:
1. Re-run protocol check on `documentation/intake/modules/<n>.md` (see SKILL.md).
2. Copy `templates/MODULE_INTAKE_TEMPLATE.md` to that path.
3. Pre-fill module slug + display name from argument.
4. If `--from <existing>`: copy non-identity fields (sources, voice override, etc.).
5. If `--from-source <path>`: AI auto-fills features and content types from source (same logic as `init --from-source`, scoped to one module — see `commands/init.md` § From-source mode). Generate inference report at `.inference/<timestamp>-<module>.md`. Ask about scope when ambiguous: "Source mentions 'snapshot' under Storage — include in this module's scope? Y/N".
6. Update `project.md` `Module intake files` section (between BEGIN/END MODULES LIST markers).
7. Print: "Module '<n>' created. Edit and run `run <n>` when ready."

**Archive**: sets `status: archived` in module intake. `run`, `verify`, `score`, `deploy` skip archived modules. Files preserved (not deleted) for git history. `unarchive` reverses.

---

## fetch

**Purpose**: pull content from external knowledge sources declared in intakes. Usually called automatically by `run` and `update`; can run manually.

**Invocation**: `fetch` / `f` / "pull sources"

**Prerequisites**: environment must provide web/API fetch capability. Env vars set for any auth-required sources (Notion `NOTION_TOKEN`, private GitHub `GITHUB_TOKEN`, GDrive OAuth). See `references/intake-reference.md` § External source fetching for per-type detail and auth.

**Flags**:
- (no args) — fetch all sources for project + all active modules
- `--module <n>` — only this module
- `--source <id>` — only this source
- `--force` — ignore lock file freshness, re-fetch

**Behavior**: fetch each source per its type, write content to `documentation/.cache/sources/<source-id>.{md,dir}`, update `documentation/intake/sources.lock.yaml` (hash + timestamp per source). See `templates/SOURCES_LOCK_TEMPLATE.md`.

**Source types** (detail in `references/intake-reference.md`):
- File local — no auth
- Notion page/database — `NOTION_TOKEN`
- GitHub repo/file — `GITHUB_TOKEN` for private
- Google Drive doc — OAuth via gcloud
- Public URL — no auth

---

## Next

Once intakes are filled and sources fetched: `run`. See `commands/run.md`.
