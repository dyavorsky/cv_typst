// Quarto partial override: replaces the default `article` template definition.
//
// Quarto assembles the generated .typ in this order:
//   numbering.typ -> definitions.typ -> typst-template.typ -> page.typ
//   -> typst-show.typ -> body
//
// So this file only needs to make modern-cv's functions available; the actual
// document setup happens in typst-show.typ. We deliberately do NOT define
// `article` here, because typst-show.typ no longer calls it.
//
// modern-cv is VENDORED at modern-cv/lib.typ rather than imported from
// @preview/modern-cv:0.10.0. The registry copy lives in Typst's read-only
// download cache, which is shared across projects, re-fetched on demand, and not
// under version control — so template internals such as the 32pt name size could
// not be edited there in any durable way. The local copy is editable and
// committed. See modern-cv/README-VENDORED.md for what was changed and why.
#import "modern-cv/lib.typ": *
