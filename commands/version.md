---
description: Git snapshot the current state of the resume data repo.
allowed-tools: Bash, Read
argument-hint: "[commit message]"
---

Commit the current resume state.

## Arguments

- `$*` — commit message. Default: auto-generated summary of changes.

## Steps

1. **Load config** to find `dataRepo`.

2. **Check git state:**
   ```bash
   cd <dataRepo> && git status --porcelain
   ```
   If nothing is staged or modified, report "No changes to commit" and stop.

3. **Stage and commit:**
   ```bash
   cd <dataRepo>
   git add -A
   git commit -m "<message>"
   ```

   If the user didn't supply a message, generate one from `git diff --stat` (e.g. "Update work entry at Acme Corp; add 2 skills").

4. **Ask whether to push.** If the repo has a remote configured (`git remote -v`) and the user confirms, `git push`. Otherwise, leave it local.

5. **Report** the commit hash and short summary.
