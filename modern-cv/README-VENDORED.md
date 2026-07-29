# Vendored modern-cv

Local copy of [modern-cv](https://github.com/DeveloperPaul123/modern-cv) **0.10.0**
(MIT — see `LICENSE`), imported by [../typst-template.typ](../typst-template.typ) as
`#import "modern-cv/lib.typ": *` instead of `@preview/modern-cv:0.10.0`.

## Why vendored

The registry copy lives in Typst's download cache
(`%LOCALAPPDATA%\typst\packages\preview\modern-cv\0.10.0`). That location is shared
across every project on the machine, re-fetched on demand, and not under version
control, so edits there are neither durable nor reproducible. Several things we
wanted to change are hardcoded inside `resume()` and not reachable from show rules
— most notably the 32pt name, because the header block is composed before the
document body is inserted.

Trade-off: we are pinned to 0.10.0 and get no upstream updates. For a CV that is
mostly a feature.

## Files

Only what `lib.typ` needs at runtime. `lang.typ` data is read via
`toml("lang.toml")`, resolved relative to `lib.typ`, so it must sit alongside it.

| File | Purpose |
| --- | --- |
| `lib.typ` | the template; contains our local edits |
| `lang.toml` | localization strings, read by `lib.typ` |
| `LICENSE` | MIT, retained for attribution |

`lib.typ` still imports `@preview/fontawesome:0.6.0` and `@preview/linguify:0.5.0`
from the registry. Those are unmodified and not vendored.

## Local edits

All marked with a `LOCAL EDIT` comment — grep for it before diffing against
upstream. Additions are marked `LOCAL EDIT (addition ...)` so the same grep finds
them.

**This file is where style changes go.** `resume.qmd` is content only; it deliberately
contains no `#set` or show rules. Do not reintroduce an override layer there to
adjust appearance — change the value here. See "Where style edits go" in
`../CLAUDE.md`.

### Sizes and styling

| What | Upstream | Now | Why |
| --- | --- | --- | --- |
| name size | `32pt` | `24pt` | too large beside the reduced headings; unreachable via show rules |
| level-1 heading (section titles) | `16pt` | `13pt` | overall size reduction |
| level-1 heading rule | no `stroke` arg | `0.5pt + color` | defaulted to 1pt black, overpowering smaller gray heading text |
| level-2 heading (entry titles) | `12pt` | `11pt` | overall size reduction |
| level-3 heading (entry description) | `10pt` | `9.5pt` | overall size reduction |
| body size in `resume()` | `11pt` | `10pt` | the document density knob; was a `set` in `resume.qmd` that most of the document ignored |
| `par` in `resume()` | `spacing`, `justify` only | adds `leading: 0.55em` | same — moved from `resume.qmd`, where it could not reach bullet text |
| `resume-item` text size | `10pt` | inherited | so bullets follow the body size instead of being pinned independently |
| `resume-skill-category` size | `11pt` | inherited | Skills rendered larger than its surroundings |
| `resume-skill-values` size / weight | `11pt`, `light` | inherited / regular | as above; regular matches how Skills has been rendering |
| `resume-skill-grid` columns | `(auto, auto)`, `gutter: 10pt` | `(auto, 1fr)`, split column/row gutters | gives values the remaining width and lets rows sit tighter than the column gap |
| page margins | `15mm` all round, bottom `20mm` with footer | left/top `0.5in`, right **derived** from the band, bottom `10mm` | see "The right sidebar" |
| `page(background:)` | unset | band + sidebar content + stamp | the sidebar |
| `footer` | `date · name · page`, content width | `[]` | replaced by the sidebar stamp |
| header alignment | `align(center)` | `align(left)` when `sidebar-contacts` | centering on a 4.75in left column beside a band reads as misalignment |
| given name weight | `thin` against a `bold` family name | both `bold` | accent color alone now distinguishes them |
| `sidebar-heading` spacing | — | `above: 2.2em` | the one knob for air between sidebar sections |
| sidebar stamp | — | prefixed `Last Updated:`, no page number | hardcoded English (lang.toml has no key); page number dropped now the CV is one page — snippet to restore it is in the code |
| `address` block | emitted unconditionally | guarded on `"address" in author` | without the guard an author dict with no `address` still consumed vertical space |
| `__contact_item` link test | `"link" in item` | `... and item.link != none` | upstream bug — see below |

`resume-skill-item` (the single-row variant) is unused. Its **column widths are
untouched** — still `(3fr, 8fr)`, spending 27% of the width on the label and forcing
values to wrap. Its text sizes do now inherit, since it shares
`resume-skill-category` / `resume-skill-values` with the grid. If it ever gets used,
the columns need the same treatment as `resume-skill-grid`.

### Added functions

Not upstream at all; defined here so `resume.qmd` stays content-only.

| Function | Purpose |
| --- | --- |
| `job-entry` | entry with the **organization** in the prominent row and the job title below — the reverse of `resume-entry`. Used by Experience. |
| `edu-entry` | one-line degree + school + year, styled deliberately unlike a job entry. Used by Education. |
| `pub-entry` | publication entry in the `edu-entry` idiom (medium title, gray venue inline, light year) instead of `resume-entry`'s two heading rows. Used by Publications. |
| `sidebar-heading` | uppercase section heading with a hairline rule, sized for the sidebar. |
| `sidebar-edu-entry` | stacked degree / school+year. Used by Education, which now lives in the sidebar. |
| `sidebar-skill-list` | bold label above comma-joined values. Same dictionary shape as `resume-skill-grid`. |
| `sidebar-stacked-list` | same shape, but one item per line instead of comma-joined; items are content, so each can be a `#link`. Used by Publications. |
| `sidebar-section` | called from `resume.qmd` to register one sidebar block; emits no layout. |
| `__collect_contact_specs` | the contact cascade as plain data, shared by both renderers. |
| `__format_contact_column` | contact items as a vertical icon+text grid for the sidebar. |

**Unused as of now:** upstream's `resume-entry`, `github-link`, `resume-skill-grid` and
`resume-skill-item`, plus the local `edu-entry` and `pub-entry`. The main column carries
only Experience and Teaching (both `job-entry`); Education, Publications and Skills all
moved into the sidebar, which needs the stacked variants instead. All are left in place as
starting points if a main-column entry style is wanted again.

### The right sidebar

A `#f2f2f2` band **3.0in** wide down the right edge, full page height, holding the
contact items, Education, Publications, Skills, and Personal. Ported from pagedown's
`resume.css` in the sibling `../cv_pagedown` repo, which uses the same 3.0in.

The inset is asymmetric — 0.25in from the band edge, 0.45in from the page edge, giving a
**2.3in** text measure. pagedown uses 0.2in/0.7in (its 0.5in page margin plus 0.2in of
padding), which would give 2.1in; the extra 0.2in was kept because the sidebar is the
fuller of the two columns.

**The right page margin is derived, never hardcoded.** `sidebar-width + sidebar-gutter`
is the only thing keeping body text out from under the band. Change the geometry `#let`s
at the top of `lib.typ` and the reservation follows; hardcode the margin and the next
width change silently prints text on gray. Verified: body measure is **342pt** (it was
378pt at a 2.5in band).

**Band width trades the two columns against each other, and not symmetrically.** Half an
inch of band is 36pt off the main measure — but it widens the sidebar text column by the
same half inch, which at 2.3in unwraps enough lines to be worth far more than 36pt of
sidebar height. When the sidebar is the constraint, widening the band is the cheapest fix.

### Sidebar spacing

Three gaps, deliberately ordered smallest to largest:

| Gap | Value | Set in |
| --- | --- | --- |
| item ↔ item within a section | `sidebar-item-gap` = 1.1em | `sidebar-edu-entry`'s `below`, `sidebar-stacked-list`'s per-item `above` |
| group ↔ group inside one section | `sidebar-item-gap + 0.5em` | `sidebar-stacked-list`'s block `below` |
| section ↔ section | 2.2em | `sidebar-heading`'s `above` |

The middle one matters: if a group gap does not exceed the item gap, the next group's
label sits closer to the item above it than the items sit to each other and reads as
belonging to that item rather than heading the list below.

`par(spacing:)` inside the sidebar block is also set to `sidebar-item-gap`, so a paragraph
break reads as the same rhythm. In practice that governs only the Personal section — every
other helper separates items with blocks or line breaks, not paragraph breaks.

**Why `page(background:)`.** Background content is laid out in a region the size of the
whole page, anchored at its top-left corner — margins included — so `place(top + right)`
reaches the physical page edge and `height: 100%` spans top margin to bottom margin.
Nothing in the body flow can do that; flow content is confined to the content area. It
also consumes no flow space, so the sidebar cannot affect where the body breaks. Verified
by sampling the rendered PNG: `#F2F2F2` at both right corners and along the band's top and
bottom edges, no white hairline.

**`place` propagates its alignment inward.** `place(top + right, block)` right-aligns the
block against the page *and* right-aligns every paragraph inside it. The sidebar block
therefore does `set align(left)` as its first line. Remove it and the whole sidebar goes
ragged-right; this is not obvious from reading the `place` call.

**Sidebar content comes from `resume.qmd`, through a state.** `resume()`'s arguments are
fixed before the body exists, so the sidebar cannot take content as a parameter.
`sidebar-section` appends to `__sidebar_state`; the background renders `.final()` in a
context, which Typst resolves by iterating layout to convergence. Sections render in call
order. If the sidebar ever comes out empty, suspect convergence before suspecting the
content.

**Placed content cannot break across pages, and the sidebar is the fuller column.**
Content runs to **707pt** and the `Last Updated` stamp starts at **761pt** — about
**54pt, four lines**, of headroom.

Two silent failure modes, neither of which warns:
1. The sidebar block is placed from the top and the stamp from the bottom, so they are
   independent. Content that outgrows the gap **overlaps the stamp** rather than clipping.
2. Beyond that it runs off the page and **is clipped**, because placed content cannot
   break across pages.

Re-measure after any sidebar change. Cheapest check is to rasterize and scan the band for
inked rows; the largest vertical gap separates the content from the stamp.

**Typst cannot vary `page.margin` per page.** `margin` takes a length, not a function of
the page number — unlike `background`/`footer`, which take content and so can use
`context`. pagedown blanks its sidebar on page 2 and widens the main column; that is not
reproducible. Page 2 keeps the 342pt column whatever is painted there, so the band is
drawn on **every** page (a narrow column beside an unexplained 3.25in of white reads as a
bug; beside the band it reads as the design) while the sidebar *content* is gated to page
1 with `context here().page() == 1`.

`edu-entry` and `resume-skill-grid` are **unusable** at 2.3in — the first right-aligns the
year on the degree line, the second gives an `auto` label column that "Languages & Tools"
would monopolise. The `sidebar-*` variants stack instead. This is required scope, not a
stylistic preference.

### Icons: only the contact row has them

Section titles carried Font Awesome icons briefly and they were removed by request. The
sidebar contact row keeps its icons, via `fa-icon`.

Read this before adding any icon anywhere. **fontawesome 0.6.0 resolves names against
Font Awesome 7's table while Quarto bundles FA 6**, so most names silently land on the
wrong glyph — `screwdriver-wrench` rendered as the literal text "ɔy", `user` as a
superscript 5, `graduation-cap` as a blank card. Only a few names survive by coincidence,
which is exactly why the contact icons work and should be left alone.

The reliable route is a codepoint, not a name: `\u{f0b1}` (briefcase) rendered in
`"Font Awesome 6 Free"` at **weight 900**. There is no `"Font Awesome 6 Free Solid"`
family name — solid glyphs are the 900 face of the regular family. Verified working:
`f0b1` briefcase, `f51c` chalkboard-teacher, `f15c` file-lines, `f19d` graduation-cap,
`f7d9` screwdriver-wrench, `f007` user, `f02d` book, `f015` house, `f004` heart.

Always render a new icon before trusting it — a wrong codepoint gives a plausible glyph,
not an error.

### A leading trap worth knowing

An inner `set par(leading:)` beats a document-level one. Measured on identical
wrapped text: **30.74pt** with only the document rule, **79.74pt** when a function
re-sets leading inside itself. `resume-item` does exactly that, so its `0.65em` — not
the `0.55em` in `resume()` — is the effective leading for nearly all body text, since
almost everything in the CV sits inside a `resume-item`. Retighten bullets there.

### The `__contact_item` bug

The `custom` contact-item handler always inserts a `link` key, substituting `none`
when the caller omits one. `__contact_item` then tested only for key *presence*,
so any link-less custom item called `link(none)` and failed the build with
`URL must not be empty`. Checking the value as well makes plain-text custom items
work — which is what allows a location like "Encino, CA" to sit in the contact row
as plain text.

**This fix is now load-bearing.** Since the contacts were refactored through
`__collect_contact_specs`, *every* spec carries a `link` key whose value may be `none` —
exactly the case upstream's key-presence test got wrong. Reverting it breaks the entire
contact block, not just an unlinked location.

## Upgrading

There is no update path that preserves these edits automatically. To move to a
newer modern-cv: copy the new `lib.typ` and `lang.toml` in, then re-apply each
`LOCAL EDIT` above, checking whether the `__contact_item` bug has been fixed
upstream (if so, drop that one). Carry **every added function** across too —
`job-entry`, `edu-entry`, `pub-entry`, the three `sidebar-*` helpers, and the contacts
refactor (`__collect_contact_specs` / `__format_contact_column`). `resume.qmd` and
`typst-show.typ` call them throughout, so the build fails immediately without them.
Re-derive the right margin from the sidebar geometry rather than copying a number, and
re-verify the full bleed.

Then render and confirm the CV is still one page, and that the sidebar has not grown into
the `Last Updated` stamp (see CLAUDE.md, "Verifying a render").
