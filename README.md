# Readme

Dan Yavorsky's academic CV. Written directly in Typst.

Extracted from `sdsu_app_aug2026` on 2026-09-03 so the CV has its own repo and can be
published to danyavorsky.com the same way the resume is. The copy left behind in that
folder is a frozen snapshot of what was submitted to SDSU — **edits belong here.**

## To render

```
quarto typst compile cv.typ cv.pdf
```

**Close `cv.pdf` in your PDF viewer first** — Acrobat and Edge hold an exclusive lock on
the file and the write fails with `os error 32`.

No `--font-path` needed: New Computer Modern and Libertinus Serif are embedded in Typst
itself. The flag would only be required if Font Awesome icons were ever added — and they
shouldn't be, because `quarto typst compile` (unlike `quarto render`) does not inject
Quarto's font path, so FA glyphs silently fall back to wrong-but-plausible substitutes.

## Not built on modern-cv

Unlike the resume in [`dyavorsky/resume_typst`](https://github.com/dyavorsky/resume_typst),
`cv.typ` is standalone and imports nothing. That is deliberate: modern-cv paints a
fixed-height gray sidebar into the *page background*, which cannot flow across pages, so
it is structurally unable to hold a multi-page academic CV.

The typeface is **New Computer Modern** — the OpenType Computer Modern, i.e. the same
face as the 2017 LaTeX CV this design is modeled on. It has real small caps, which is
load-bearing: `smallcaps()` applies the OpenType `smcp` feature and **silently leaves
text unchanged** when the font lacks it. New Computer Modern, Libertinus Serif, Palatino
Linotype, Cambria and Constantia all have true small caps; Avenir and Garamond do not.
Constantia was rejected anyway — it defaults to old-style figures, which wrecks the
right-hand date column. Don't substitute a font here without rendering a small-caps
probe first. See the comment block at the top of `cv.typ`.

## Publishing to danyavorsky.com

The CV at [danyavorsky.com/cv/vita](https://www.danyavorsky.com/cv/vita/) is a copy of
this repo's `cv.pdf`, **synced automatically.** Rendering, committing, and pushing
`cv.pdf` to `main` here is the entire publish step — nothing on the website needs
updating by hand.

The machinery lives in the website repo:
[`dyavorsky/quarto_website`](https://github.com/dyavorsky/quarto_website) →
`.github/workflows/sync-docs.yml`. It runs nightly at 03:12 PT, fetches `cv.pdf` from
this repo's `main`, renames it to `cv/vita/yavorsky_dan_cv_<yyyymmdd>.pdf`, updates the
CV page's "Last updated" date, and redeploys the site. The same workflow does the resume.
To skip the wait, trigger it from that repo: **Actions → Sync resume and CV → Run
workflow**.

The date is read out of the PDF itself. Typst leaves the PDF info dict uncompressed, so
`/CreationDate` is greppable from the raw bytes with no `pdftotext`. It is
`datetime.today()` at render time, which is the same value `cv.typ` prints in its own
"Last Updated" line — so the site's "Last updated" can never disagree with the PDF it is
serving.

To update the website by hand:

```bash
# 1. read the render date out of the PDF itself
grep -ao '/CreationDate(D:[0-9]\{8\}' cv.pdf | head -1   # -> /CreationDate(D:20260828

# 2. copy the new PDF to the website with its dated name; remove the old one
cp cv.pdf ../quarto_website/cv/vita/yavorsky_dan_cv_20260828.pdf
cd ../quarto_website
git rm cv/vita/yavorsky_dan_cv_20260827.pdf

# 3. update the two keys in quarto_website/cv/vita/index.qmd that name it:
#      date: 2026-08-28
#      cv:
#        pdf: "yavorsky_dan_cv_20260828.pdf"

# 4. commit and push to main; publish.yml renders and deploys
```
