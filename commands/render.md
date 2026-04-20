---
description: Render the resume (or a variant) to PDF using a Typst template.
allowed-tools: Read, Write, Bash, Glob
argument-hint: "[template] [variant]"
---

Render the resume to PDF.

## Arguments

- `$1` — template name (folder under `<plugin>/templates/`). Default: `classic`.
- `$2` — variant name (file under `<dataRepo>/data/variants/`, without `.json`). Default: the base `resume.json`.

## Steps

1. **Load config** from `~/.claude/plugins/resume-typesetter/config.json` to get `dataRepo`. If missing, tell the user to run `/resume:onboard` first.

2. **Resolve inputs:**
   - Template path: `<plugin-dir>/templates/<template>/template.typ`. The plugin directory is typically `~/.claude/plugins/resume-typesetter/` — discover it from the location of this command file if needed.
   - Data file: `<dataRepo>/data/variants/<variant>.json` if `$2` provided, else `<dataRepo>/data/resume.json`.
   - Validate both exist.

3. **Render.** Typst's `json()` function resolves paths relative to the `.typ` file's directory, so pass the data file via `--input`:

   ```bash
   mkdir -p "<dataRepo>/renders"
   typst compile \
     --root / \
     --input resume="<absolute-path-to-json>" \
     "<template.typ>" \
     "<dataRepo>/renders/$(date +%Y-%m-%d)-<template>-<variant-or-base>.pdf"
   ```

   The template reads the path via `sys.inputs.resume` and calls `json(sys.inputs.resume)`. `--root /` is required so Typst permits the absolute path to the data file (which lives outside the template's directory).

4. **Report** the output path and file size. If Typst emits warnings, surface them.

## Errors

- If `typst` isn't on `$PATH`: point the user at https://github.com/typst/typst for install instructions.
- If the template fails to compile: show the Typst error verbatim and suggest checking whether the variant's JSON has the fields the template expects.
