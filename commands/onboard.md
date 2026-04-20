---
description: Import an existing resume into the JSON Resume schema and configure the data repo path.
allowed-tools: Read, Write, Edit, Bash, WebFetch, Glob
---

Onboard the user to the Resume-Typesetter plugin.

## Steps

1. **Determine data repo path.** Check the plugin config file at `~/.claude/plugins/resume-typesetter/config.json`. If it exists and has a `dataRepo` field, use that. Otherwise, ask the user where the data repo should live (default suggestion: `~/repos/github/my-repos/Resume-Data`). Create the directory if it doesn't exist. Record the path in `~/.claude/plugins/resume-typesetter/config.json`:

   ```json
   { "dataRepo": "/absolute/path/to/repo" }
   ```

2. **Ask for resume source.** Offer the user four options:
   - Paste resume text directly
   - Path to a local file (PDF, DOCX, Markdown, TXT, existing JSON)
   - URL (e.g. LinkedIn profile export, personal website)
   - Start from a blank JSON Resume template

3. **Parse into JSON Resume schema.** The schema is at https://jsonresume.org/schema/ — top-level keys: `basics`, `work`, `volunteer`, `education`, `awards`, `certificates`, `publications`, `skills`, `languages`, `interests`, `references`, `projects`. For paste/file/URL inputs, parse the content and map it to these keys. Preserve all information — don't drop content to make it "cleaner."

4. **Write `<dataRepo>/data/resume.json`.** Create the `data/` subdirectory if needed. Pretty-print with 2-space indent.

5. **Initialize git in the data repo** if it isn't already a git repo (`git init`, initial commit "Initial resume import"). Do not push — pushing is the user's call.

6. **Report** the file path, a summary of what was parsed (e.g. "3 work entries, 2 education entries, 18 skills"), and suggest next steps: `/resume:render` to produce a PDF, or `/resume:iterate` to refine.

## Notes

- If the source is a PDF, use `pdftotext` (poppler-utils) to extract text before parsing.
- If parsing is ambiguous (e.g. dates in mixed formats), make a best guess and flag the uncertain fields in the report so the user can fix them via `/resume:iterate`.
- Never overwrite an existing `resume.json` without confirming.
