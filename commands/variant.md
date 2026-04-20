---
description: Fork the base resume into a named variant for a tailored version (e.g. per job application).
allowed-tools: Read, Write, Bash
argument-hint: "<variant-name>"
---

Create a tailored variant of the base resume.

## Arguments

- `$1` — variant name (kebab-case, e.g. `acme-senior-eng`). Required.

## Steps

1. **Load config** to find `dataRepo`.

2. **Validate** the variant name is kebab-case and doesn't already exist at `<dataRepo>/data/variants/<$1>.json`. If it exists, ask whether to overwrite or pick a different name.

3. **Copy base → variant.** Create `<dataRepo>/data/variants/` if needed, then copy `data/resume.json` to `data/variants/<$1>.json`.

4. **Ask the user how to tailor it.** Typical tailoring:
   - Emphasise specific work bullets relevant to the target role
   - Drop or de-prioritise unrelated skills/projects
   - Rewrite the summary (`basics.summary`) to match the role
   - Reorder sections

5. **Apply the tailoring edits** to the variant file only — never touch the base `resume.json`.

6. **Report** the variant path and remind the user they can render it with `/resume:render <template> <$1>`.
