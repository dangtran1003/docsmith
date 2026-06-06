# Agent instructions — docsmith

This repository provides **docsmith**, a documentation-automation skill.

When the user asks to create, draft, plan, review, score, or publish product documentation — or mentions "docsmith" — read the skill index first:

**`skills/docsmith/SKILL.md`**

That file is a small index (~1,200 tokens). It maps each docsmith command to a file under `skills/docsmith/commands/`. Read ONLY the command file for the task at hand, then follow it. Load files from `skills/docsmith/references/`, `skills/docsmith/templates/`, or `skills/docsmith/fpt/` ONLY when a command file tells you to.

Do not load the whole skill at once — it uses progressive disclosure on purpose, so it runs efficiently even on limited context windows.

Treat `/docsmith <cmd>`, `docsmith <cmd>`, and "use docsmith to …" as the same request: map to the command, read its file, follow it.
