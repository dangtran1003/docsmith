# Commands: record, translate

---

## record

**Purpose**: record short tutorial videos from `<!-- VIDEO id: <id> -->` markers in drafts.

**Owner**: AI · **Invocation**: `record` / `rec` / "make video"

**Environment requirement**: browser automation (for screen capture) + ffmpeg (video encoding). If voiceover strategy is "AI synthetic voice", also a TTS provider (local Piper/Coqui binary, or remote API key). Silent strategy (default) needs no TTS. If your environment lacks these, skip this command.

**Interactive fill**: if voiceover = "AI synthetic voice" and TTS provider/voice not set, prompt inline and write back. Silent (default) needs no prompts. Required fields: `references/intake-reference.md` § 10 (record).

**Media policy**: video density, length caps, voiceover strategy, TTS provider from project intake § 11 (module § 8 overrides). Default: "Silent + on-screen captions". Full options: `templates/MEDIA_POLICY_TEMPLATE.md` § 4-7.

**Script files**: each video has a script at `documentation/scripts/<module>/<id>.md` (source narration + per-locale translations). Format: `templates/VIDEO_SCRIPT_TEMPLATE.md`.

**Workflow**:
1. Scan drafts for `<!-- VIDEO id: <id> -->` markers.
2. For each, look up `documentation/scripts/<module>/<id>.md`:
   - Missing → generate initial script from surrounding draft prose, save, pause for review.
   - Stale (draft section changed >20%) → warn.
3. User reviews/edits script.
4. On confirm: TTS generates audio per locale (skipped if silent), capture screen, encode video.
5. Replace VIDEO marker with `<video>` embed; preserve marker as comment for re-record.

**Flags**: `--migrate-scripts`, `--check` (validate scripts exist, no generation), `--re-record <id>`.

**Translate integration**: `translate` processes script files alongside drafts — translates `# Source script` into `## <locale>` sections, same review gate.

---

## translate

**Purpose**: translate drafts (and video scripts) from source locale to each target locale.

**Owner**: AI · **Invocation**: `translate` / `tr`

**Required** when `locales.targets` is non-empty. Position: after `edit`, before `deploy`.

**Interactive fill**: if `locales.targets` empty, prompt user to pick target languages, write back to project intake § 3. Required fields: `references/intake-reference.md` § 10 (translate).

**Default review mode**: `batch` (whole-file diff). Opt into `--per-block` for safer per-block review.

**Block-level rules + full workflow**: `references/translate-reference.md`.

**Glossary** (per locale): `documentation/standards/glossary.<locale>.yaml` from `templates/GLOSSARY_TEMPLATE.yaml`. Optional but recommended — enforces consistent terminology, persists across re-runs.

**FPT vocabulary**: when `compliance: fpt-user-guide`, the glossary should follow the FPT Vocabulary Guide (tech terms stay English, actions in Vietnamese, FPT product names unchanged) — `fpt/FPT_TEMPLATES.md` § Part 5 Vocabulary Guide. Load only when compliance is set.

**Flags**: `[<module>]`, `--locale <locale>`, `--per-block`, `--auto-approve` (CI/bulk), `--glob <pattern>`.

---

## Next

After translate: `verify`, then `score` (if FPT), then `deploy`.
