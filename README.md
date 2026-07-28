# cv_typst

Dan Yavorsky's résumé, built with **Quarto → Typst**. Source of truth is
[resume.qmd](resume.qmd); [resume.pdf](resume.pdf) is the output. One page.

## Credit

The layout descends from **[modern-cv](https://typst.app/universe/package/modern-cv/)**
by **Paul Tsouchlos** ([DeveloperPaul123](https://github.com/DeveloperPaul123/modern-cv)),
which is itself a Typst port of [Awesome-CV](https://github.com/posquit0/Awesome-CV).
modern-cv is MIT licensed; the full text is retained at
[modern-cv/LICENSE](modern-cv/LICENSE).

**This project is an extension of modern-cv, not a plain use of it.** Version 0.10.0 is
vendored into [modern-cv/](modern-cv/) rather than pulled from `@preview`, because
several things worth changing are hardcoded inside the template's `resume()` function and
cannot be reached from show rules — most notably the name size, since the header block is
composed before the document body is inserted.

Every local change is marked with a `LOCAL EDIT` comment and tabulated against its
upstream value in [modern-cv/README-VENDORED.md](modern-cv/README-VENDORED.md). The
substantive additions:

- A full-height **gray sidebar** down the right edge, carrying contact details,
  education, publications, skills, and personal notes. Adapted from the
  [pagedown](https://github.com/rstudio/pagedown) `html_resume` layout.
- **Entry helpers** the upstream template does not have — `job-entry` (organization above
  job title, reversing `resume-entry`'s order) and stacked `sidebar-*` variants, since
  the upstream row-justified helpers do not survive the sidebar's narrow measure.
- A refactor of the contact block so one source of truth feeds both a horizontal header
  row and the vertical sidebar column.
- Assorted resizing, recoloring, and a fix for an upstream crash on link-less custom
  contact items.

## Building

```powershell
quarto render resume.qmd --to typst
```

Close `resume.pdf` first if it is open in Acrobat — Acrobat holds an exclusive lock and
the write will fail.

Requires **Quarto ≥ 1.7** (developed against 1.10.18 / Typst 0.15.1). modern-cv 0.10.0
declares `compiler = "0.12.0"`, so the Typst 0.11.0 bundled with older Quarto cannot load
it. On any Typst package compatibility error, check `quarto typst --version` first.

Fonts: the CV asks for **Avenir**, falling back to Segoe UI and then Arial. Without a
valid entry in that chain Typst silently falls back to a serif, so check the output if it
looks wrong on a new machine.

## Layout

Quarto assembles the generated `.typ` in a fixed order:

```
numbering.typ -> definitions.typ -> typst-template.typ -> page.typ
  -> typst-show.typ -> body
```

Three partials override Quarto's defaults:

| File | Role |
| --- | --- |
| [typst-template.typ](typst-template.typ) | imports the vendored modern-cv |
| [typst-show.typ](typst-show.typ) | applies `#show: resume.with(...)`; holds contact details, fonts, and colors |
| [page.typ](page.typ) | deliberately blank — Quarto's default `#set page(...)` would fight the template's own page setup, including the sidebar background |

`resume.qmd` is **content only** and contains no `#set` or show rules. Styling belongs in
`modern-cv/lib.typ`, marked `LOCAL EDIT`; keeping one value per styled element avoids two
mechanisms competing over the same thing.

Sidebar sections are registered from `resume.qmd` with `sidebar-section("Title")[...]`.
They cannot be passed to `resume()` as an argument — Quarto emits `typst-show.typ` before
the body, so the show rule's arguments are fixed before the content exists — so they
accumulate in a Typst `state` that the page background reads back.

## License

The vendored template retains its original MIT license
([modern-cv/LICENSE](modern-cv/LICENSE)). The résumé content is Dan Yavorsky's.
