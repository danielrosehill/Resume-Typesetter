---
description: Conversationally edit the resume JSON — add roles, tweak bullets, reorder sections.
allowed-tools: Read, Write, Edit, Bash
argument-hint: "[variant]"
---

Iterate on the resume data file.

## Arguments

- `$1` — variant name (without `.json`). Default: base `resume.json`.

## Steps

1. **Load config** to find `dataRepo`. Fail gracefully if onboarding hasn't run.

2. **Resolve target file**: `<dataRepo>/data/variants/<$1>.json` or `<dataRepo>/data/resume.json`.

3. **Read the current file.** Summarise its structure briefly (e.g. "3 work entries, most recent: X"). Ask the user what they want to change.

4. **Apply edits.** Use the `Edit` tool for surgical changes to specific fields. For larger restructuring (e.g. reordering all work entries), read, transform, and write back. Always keep the file as valid JSON Resume schema — never invent non-standard keys.

5. **Validate** that the file still parses as JSON (`python3 -c "import json; json.load(open('...'))"`).

6. **Offer next steps**: render with `/resume:render` to see the effect, or `/resume:version` to snapshot.

## Notes

- Prefer minimal, targeted edits over full rewrites — the user should be able to see exactly what changed.
- For tone/wording improvements on bullets, show the before and after before writing.
- Don't auto-commit — let the user run `/resume:version` when they're ready.
