# Resume-Typesetter

A Claude Code plugin for managing a resume as structured data ([JSON Resume](https://jsonresume.org/schema/) schema) and rendering it with custom [Typst](https://typst.app/) templates.

Data and presentation stay cleanly separated: the user's resume lives as `resume.json`, and the plugin ships with Typst templates that read it via Typst's built-in `json()` function.

## Workflow

1. `/resume:onboard` — import an existing resume (paste, file, or URL) into `<data-repo>/data/resume.json`. Configures the data repo path on first run.
2. `/resume:iterate` — conversational edits to `resume.json` (add a role, tighten a bullet, reorder sections).
3. `/resume:variant <name>` — fork the base resume into `data/variants/<name>.json` for a tailored version (e.g. per job application).
4. `/resume:render [template] [variant]` — render to PDF in `renders/` using a Typst template.
5. `/resume:version [message]` — git snapshot the current state of the data repo.

## Templates

Bundled under `templates/`:

- **classic** — traditional single-column layout, serif.
- **modern** — two-column layout with sidebar, sans-serif.

Each template is a Typst file that reads `data/resume.json` (or a variant) via `json()`. Add your own templates by dropping a new folder under `templates/` with a `template.typ` file.

## Requirements

- [Typst](https://github.com/typst/typst) installed on `$PATH` (`typst --version`).
- A git-backed repo to hold the resume data (the plugin stores this path in its config on first onboard).

## Installation

```bash
claude plugins install resume-typesetter@danielrosehill
```

## Data schema

[JSON Resume](https://jsonresume.org/schema/) — a pure data schema with no styling opinions. Broad ecosystem, well-documented, language-agnostic.

## License

MIT
