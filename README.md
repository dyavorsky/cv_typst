# Readme

Dan Yavorsky's resume. Built with Quarto and Typst. 

The layout descends from **[modern-cv](https://typst.app/universe/package/modern-cv/)**
by **Paul Tsouchlos** ([DeveloperPaul123](https://github.com/DeveloperPaul123/modern-cv)),
which is itself a Typst port of [Awesome-CV](https://github.com/posquit0/Awesome-CV). 
This project is an extension of modern-cv, not a plain use of it. Version 0.10.0 is
vendored into [modern-cv/](modern-cv/) rather than pulled from `@preview`, because
several things worth changing are hardcoded inside the template's `resume()` function:

- A full-height **gray sidebar** down the right edge, carrying contact details,
  education, publications, skills, and personal notes. Adapted from the
  [pagedown](https://github.com/rstudio/pagedown) `html_resume` layout.
- **Entry helpers** the upstream template does not have — `job-entry` (organization above
  job title, reversing `resume-entry`'s order) and stacked `sidebar-*` variants, since
  the upstream row-justified helpers are not compatible with the narrow sidebar.
- A refactor of the contact block so one source of truth feeds both a horizontal header
  row and the vertical sidebar column.
- Assorted resizing, recoloring, and a fix for a crash on link-less custom contact items.

To render:

```
quarto render resume.qmd --to typst
```


