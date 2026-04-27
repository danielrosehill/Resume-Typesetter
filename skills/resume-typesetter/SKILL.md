---
name: resume-typesetter
description: Shared reference for working with JSON Resume schema data and Typst resume templates. Invoke when editing the resume JSON or a Typst template under this plugin, or when the user asks how the pieces fit together.
---

# Resume-Typesetter reference

## Architecture

- **Data**: a single `resume.json` file conforming to the [JSON Resume schema](https://jsonresume.org/schema/). Optional variants live under `data/variants/<name>.json`.
- **Presentation**: Typst templates under `templates/<name>/template.typ`. Each template reads the JSON via `json(sys.inputs.resume)` — the path is passed at compile time with `--input resume=<path>`.
- **Config**: `<plugin-data-dir>/config.json` stores `dataRepo` (absolute path to the user's resume data repo). The plugin data directory resolves as `$CLAUDE_USER_DATA/resume-typesetter/` if `CLAUDE_USER_DATA` is set; otherwise `$XDG_DATA_HOME/claude-plugins/resume-typesetter/` if `XDG_DATA_HOME` is set; otherwise `~/.local/share/claude-plugins/resume-typesetter/`. See the canonical convention in the `claude-rudder:plugin-data-storage` skill.

## JSON Resume schema — top-level keys

```
basics       — name, label, email, phone, url, summary, location, profiles[]
work         — name, position, url, startDate, endDate, summary, highlights[]
volunteer    — organization, position, url, startDate, endDate, summary, highlights[]
education    — institution, url, area, studyType, startDate, endDate, score, courses[]
awards       — title, date, awarder, summary
certificates — name, date, issuer, url
publications — name, publisher, releaseDate, url, summary
skills       — name, level, keywords[]
languages    — language, fluency
interests    — name, keywords[]
references   — name, reference
projects     — name, description, highlights[], keywords[], startDate, endDate, url, roles[], entity, type
```

Dates are ISO 8601 (`YYYY-MM-DD` or `YYYY-MM`). Omit `endDate` for current positions.

## Typst integration pattern

A template entry point looks like:

```typst
#let resume = json(sys.inputs.resume)
#let basics = resume.basics

= #basics.name
#basics.label
#basics.email · #basics.phone

== Experience
#for job in resume.work {
  [*#job.position*, #job.name \\
  #job.startDate -- #job.at("endDate", default: "Present") \\
  #for h in job.at("highlights", default: ()) [- #h]]
}
```

Always use `.at("key", default: …)` for optional JSON Resume fields — strict key access fails if the user hasn't filled in that section.

## Invariants

- Never introduce non-standard keys into `resume.json`. If a user wants a field JSON Resume doesn't cover, discuss adding it to a separate extension file rather than polluting the schema.
- Never edit the base `resume.json` when working on a variant, and vice versa.
- Templates must never write to the data file — they're read-only consumers.
- PDF output always goes to `<dataRepo>/renders/`, never into the plugin directory.

## Adding a new template

1. Create `templates/<name>/template.typ`.
2. Read data via `json(sys.inputs.resume)`.
3. Use `.at(..., default: ...)` for optional sections.
4. Test by running `/resume:render <name>`.
