// Dan Yavorsky — Academic CV
// Build:  quarto typst compile cv.typ cv.pdf
//
// No --font-path needed: New Computer Modern and Libertinus Serif are embedded in
// Typst itself. The flag is only required if Font Awesome icons are ever added.
// Close cv.pdf in Acrobat/Edge before building — they hold an exclusive file lock.
//
// Standalone. Does NOT import ../resume_typst/modern-cv: that template paints a
// fixed-height sidebar into the page background, which cannot flow across pages,
// so it is structurally unable to hold a multi-page academic CV.
//
// TYPEFACE — "New Computer Modern" is the OpenType Computer Modern, i.e. the same
// face as the 2017 LaTeX CV this design is modeled on, and it has REAL small caps.
// That last point is load-bearing: `smallcaps()` applies the OpenType `smcp`
// feature and SILENTLY LEAVES TEXT UNCHANGED when the font lacks it. Verified by
// render: New Computer Modern, Libertinus Serif, Palatino Linotype, Constantia and
// Cambria all have true small caps; Avenir and Garamond do NOT — Garamond renders
// `smallcaps()` as plain lowercase with no warning. Do not substitute a font here
// without rendering a small-caps probe first.
//
// Constantia was rejected despite having small caps: it defaults to old-style
// (text) figures, so the right-hand date column renders with descending digits.
//
// No Font Awesome anywhere. Quarto injects its font path only during `quarto
// render`, so a standalone `quarto typst compile` silently drops FA glyphs to
// wrong-but-plausible fallbacks.

#let body-size = 10pt
#let rule-stroke = 0.5pt + rgb("#000000")
#let link-color = rgb("#24405e")   // near-black navy; reads classical in print

#set page(
  paper: "us-letter",
  margin: (x: 0.95in, y: 0.85in),
  numbering: "1",
  number-align: center,
)

#set text(
  font: ("New Computer Modern", "Libertinus Serif", "Cambria"),
  size: body-size,
  fill: black,
)

// `leading` is the gap between wrapped lines INSIDE a paragraph or bullet; the
// `spacing:` on `item` and `dated` below is the gap BETWEEN bullets. The latter
// must stay larger than the former, or wrapped bullets read as one run-on block.
// (They were once inverted — 0.56em leading against 0.3em between bullets.)
#set par(justify: false, leading: 0.48em, spacing: 0.6em)

#show link: it => text(fill: link-color, it)

// --- section heading: bold small caps over a full-measure rule ---------------
// Matches the reference CV. `breakable: false` keeps a heading from stranding at
// the foot of a page.
#show heading.where(level: 1): it => block(
  above: 1.25em, below: 0.6em, breakable: false, sticky: true, width: 100%,
  [
    #text(size: body-size, weight: "bold")[#smallcaps(it.body)]
    #v(-0.62em)
    #line(length: 100%, stroke: rule-stroke)
  ],
)

#show heading.where(level: 2): it => block(
  above: 0.9em, below: 0.35em, sticky: true,
  text(size: body-size, weight: "bold", style: "italic", it.body),
)

// --- helpers ----------------------------------------------------------------

// One justified row. The `1fr` spacer gives NO wrap protection, so a long left
// side and a long right side collide rather than reflow — keep left text short.
// `spacing` is the gap ABOVE this block, so it sets the leading between an entry's
// bold title row and its italic subtitle row. Kept deliberately looser than the
// document leading (0.48em): at the tighter value the italic line read as squashed
// against the bold line above it.
#let jrow(l, r) = block(width: 100%, spacing: 0.5em, grid(
  columns: (1fr, auto), column-gutter: 10pt,
  align(left, l), align(right, r),
))

// The canonical entry, per the reference CV's Work Experience block:
//   (1) bold title            + right-aligned date
//   (2) italic subtitle       + right-aligned location
//   (3) regular body beneath
// `above` must exceed `item`'s 0.65em bullet spacing, or consecutive entries
// read as one continuous list.
#let entry(title, subtitle: none, date: none, location: none, body: none) = block(
  width: 100%, breakable: false, above: 1.05em, below: 0.6em,
  [
    #jrow(text(weight: "bold", title), if date != none { date })
    #if subtitle != none or location != none {
      jrow(
        if subtitle != none { emph(subtitle) },
        if location != none { emph(location) },
      )
    }
    #if body != none { block(above: 0.32em, body) }
  ],
)

// Hanging-indent bullet using the reference CV's middot marker. `spacing` (gap
// between bullets) is deliberately larger than the document `leading`.
#let item(body) = block(width: 100%, spacing: 0.65em, grid(
  columns: (0.9em, 1fr), column-gutter: 0pt,
  [·], body,
))

// A `·`-led line with a right-aligned date, for conference lists.
// Single-line entries, so only a touch more than `leading` is needed.
#let dated(l, r) = block(width: 100%, spacing: 0.6em, grid(
  columns: (0.9em, 1fr, auto), column-gutter: (0pt, 10pt),
  [·], align(left, l), align(right, r),
))

// Publication: bold title over an italic venue line, then a regular detail line.
#let pub(title, venue: none, date: none, detail: none) = block(
  width: 100%, breakable: false, above: 1.0em, below: 0.6em,
  [
    #jrow(text(weight: "bold")["#title"], if date != none { date })
    #if venue != none { jrow(emph(venue), none) }
    #if detail != none { block(above: 0.28em, detail) }
  ],
)

// Same three-line shape as `pub`, but hung under a `·` and indented. Two reasons
// it is a separate helper rather than a flag on `pub`: set flush and unmarked, the
// four Research Contributions entries read as one undifferentiated block, and the
// indent also subordinates them to the author's own publications — which is the
// honest hierarchy, since these carry no authorship credit.
#let contrib(title, venue: none, date: none, detail: none) = block(
  width: 100%, breakable: false, above: 1.0em, below: 0.65em,
  grid(
    columns: (0.9em, 1fr), column-gutter: 0pt,
    [·],
    [
      #jrow(text(weight: "bold")["#title"], if date != none { date })
      #if venue != none { jrow(emph(venue), none) }
      #if detail != none { block(above: 0.28em, detail) }
    ],
  ),
)

#let me = [Dan Yavorsky]

// --- header -----------------------------------------------------------------

#align(center)[
  #text(size: 17pt, weight: "bold")[#smallcaps[Dan Yavorsky]]
  #v(-0.35em)
  #text(size: 9.5pt)[
    #link("mailto:dyavorsky@gmail.com")[dyavorsky\@gmail.com] #h(1em) 951-201-0927
    #h(1em) #link("https://www.danyavorsky.com")[www.danyavorsky.com] \
    #link("https://github.com/dyavorsky")[github.com/dyavorsky] #h(1em)
    ORCID #link("https://orcid.org/0000-0003-4095-6405")[0000-0003-4095-6405]
  ]
]

#v(0.2em)

= Education

#entry(
  "UCLA Anderson School of Management",
  subtitle: "PhD, Quantitative Marketing", date: "2020",
  body: [Committee: Elisabeth Honka (co-chair), Peter Rossi (co-chair),
  Keith Chen, Brett Hollenbeck],
)

#entry(
  "UCLA Anderson School of Management",
  subtitle: "MBA, Management", date: "2014",
  body: [Outstanding Student in Marketing; MBA Honor Society],
)

#entry(
  "CFA Institute",
  subtitle: "Chartered Financial Analyst Charterholder (inactive)", date: "2012",
)

#entry(
  "Claremont McKenna College",
  subtitle: "BA, Economics and Mathematics", date: "2006",
  body: [Cum Laude; Phi Beta Kappa; Omicron Delta Epsilon; Best Economics Thesis],
)

= Academic Appointments

#entry(
  "Fowler College of Business, San Diego State University",
  subtitle: "Assistant Professor of Marketing", date: "2027 – Present",
)

#entry(
  "Rady School of Management, University of California San Diego",
  subtitle: "Lecturer", date: "2022 – 2027",
)

#entry(
  "Anderson School of Management, University of California Los Angeles",
  subtitle: "Lecturer", date: "2021 – 2026",
)

#entry(
  "UCLA Anderson School of Management",
  subtitle: "Graduate Student Researcher", date: "2015 – 2019", 
  body: [
    #item[Research support to Professors Rossi, Chen, Honka, and Seiler.]
    #item[Maintained and extended the _bayesm_ R package.]
  ],
)

= Refereed Publications

#pub(
  "Consumer Search in the U.S. Auto Industry: The Role of Dealership Visits",
  venue: "Quantitative Marketing and Economics, 19(1)", date: "2021",
  detail: [with Elisabeth Honka and Keith Chen. #h(0.4em)
  #link("https://doi.org/10.1007/s11129-020-09229-4")[doi:10.1007/s11129-020-09229-4]],
)

= Working Papers

#pub(
  "Outside Good Uncertainty: Ordinal Dual Response in Choice-Based Conjoint",
  venue: "In progress; with Geoffery Zheng (NYU Shanghai).", 
  detail: [A behavioral model of
  outside-good uncertainty extending the dual-response purchase question from binary to
  ordinal, nesting the existing binary models as its two-point special case. #h(0.3em)
  #link("https://dyavorsky.github.io/ordinalDualresponse_paper/")[Draft available.]],
)

#pub(
  "SIFT: Search Conjoint — Measuring Preferences and Search Costs in a Single Survey Instrument",
  venue: "In progress; with Tinghan Zhang (Tilburg University).",
  detail: [A survey instrument reproducing the
  list-then-detail architecture of digital storefronts; the resulting click-and-choose data
  fit with a sequential search model recovers both preference parameters and search costs.
   #link("https://dyavorsky.github.io/sift_paper/")[Early draft available.]],
)

= Books in Progress

#pub(
  "Discrete Choice Model Estimation with R",
  venue: "Open-access book, in progress",
  detail: [#link("http://dcme-r.danyavorsky.com/")[dcme-r.danyavorsky.com]],
)

= Software

Author and maintainer of R packages for common analytical methodologies in consumer research:

#block(above: 0.5em)[
  #item[#text(weight: "bold")[#link("https://github.com/dyavorsky/maxdiff")[maxdiff]] —
  best-worst scaling; adapts _bayesm_'s hierarchical Bayesian MNL sampler to varying
  choice-set sizes.]
  #item[#text(weight: "bold")[#link("https://github.com/dyavorsky/shapley")[shapley]] —
  R-squared contribution averaged over all predictor orderings, extended to binary (logit)
  and ordinal (ordered logit) outcomes.]
  #item[#text(weight: "bold")[#link("https://github.com/dyavorsky/keydrivers")[keydrivers]] —
  eight complementary variable-importance methods with bootstrapped confidence intervals.]
  #item[#text(weight: "bold")[#link("https://github.com/dyavorsky/turf")[turf]] —
  total unduplicated reach and frequency; exhaustive bundle search made tractable via C++
  and parallel computation.]
]

= Professional Experience

#entry(
  "GBK Collective",
  subtitle: "Head of Analytics", date: "2022 – 2026", location: "Los Angeles, CA",
  body: [
    #item[Led the marketing science and analytics function across all client engagements,
    from proposal through design, fielding, estimation, and reporting.]
    #item[Applied econometric, statistical, and machine learning methods to inform marketing
    strategy, often with academic experts such as Eric Bradlow (Wharton) and Dominique Hanssens (UCLA).]
    #item[Developed R packages for core survey-research methods.]
  ],
)

#entry(
  "Bain & Company",
  subtitle: "Manager, Advanced Analytics", date: "2020 – 2021", location: "Los Angeles, CA",
  body: [
    #item[Marketing analytics in support of strategy engagements: conjoint analysis,
    maximum-difference scaling, segmentation, perceptual mapping, factor analysis, and
    structural equation modeling.]
    #item[Built a model ecosystem enabling a media conglomerate to value streaming content
    and optimize licensing decisions.]
  ],
)

#entry(
  "Cornerstone Research",
  subtitle: "Analyst, Senior Analyst, Research Associate", date: "2006 – 2014",
  location: "San Francisco, CA",
  body: [
    #item[Economic, financial, statistical, and causal analyses supporting academic expert
    witnesses in over 100 commercial litigation matters.]
    #item[Led firm-wide analyst training and West Coast analyst recruiting.]
  ],
)

= Teaching

== Courses Taught as Instructor of Record

// Unbreakable: six rows split across a page read badly. With `sticky` headings
// above, the whole Teaching section moves together.
#block(above: 0.5em, breakable: false)[
  #set text(size: 9.5pt)
  #table(
    columns: (2.25fr, 1fr, 0.95fr, auto, auto),
    stroke: none,
    align: (left, left, left, center, left),
    inset: (x: 2pt, y: 3.4pt),
    table.hline(stroke: rule-stroke),
    table.header(
      [*Course*], [*Level*], [*Institution*], [*Sections*], [*Years*],
    ),
    table.hline(stroke: 0.4pt + black),
    [MGT 100 — Customer Analytics], [Undergrad], [UCSD Rady], [12], [2022 – 2026],
    [MGTA 495 — Marketing Analytics], [MSBA], [UCSD Rady], [3], [2024 – 2026],
    [MGT 153 — Technology for Business Analytics], [Undergrad], [UCSD Rady], [1], [2022],
    [MFE 402 — Econometrics], [MFE], [UCLA Anderson], [7], [2022 – 2025],
    [MGMT 411 — Marketing Strategy and Policy], [Exec MBA], [UCLA Anderson], [2], [2022],
    [R Workshop], [MFE], [UCLA Anderson], [8], [2018 – 2025],
    table.hline(stroke: rule-stroke),
  )
]

#block(above: 0.5em)[
  #text(size: 9.5pt)[Syllabi, slides, and complete unedited student evaluations for every
  section: #link("https://www.danyavorsky.com/teaching")[danyavorsky.com/teaching].]
]

= Research Contributions

Substantive research and programming contributions to the following, without authorship credit:

#contrib(
  "The Sequential Search Model: A Framework for Empirical Research",
  venue: "Quantitative Marketing and Economics", date: "2025",
  detail: [Raluca Ursu, Stephan Seiler, and Elisabeth Honka. #h(0.4em)
  #link("https://doi.org/10.1007/s11129-024-09291-2")[doi:10.1007/s11129-024-09291-2]],
)

#contrib(
  "The Value of Flexible Work: Evidence from Uber Drivers",
  venue: "Journal of Political Economy, 127(6)", date: "2019",
  detail: [M. Keith Chen, Judith Chevalier, Peter Rossi, and Emily Oehlsen. #h(0.4em)
  #link("https://doi.org/10.1086/702171")[doi:10.1086/702171]],
)

#contrib(
  "bayesm: Bayesian Inference for Marketing / Micro-Econometrics",
  venue: "R package, CRAN",
  detail: [Peter Rossi. Posterior samplers, vignettes, and documentation. #h(0.4em)
  #link("https://cran.r-project.org/package=bayesm")[cran.r-project.org/package=bayesm]],
)

#block(above: 0.8em)[
  #item[Acknowledged contributor to Wickham, Navarro, and Pedersen, _ggplot2: Elegant
  Graphics for Data Analysis_ (3rd ed.), and Wickham and Bryan, _R Packages_ (2nd ed.).]
]

= Presentations and Invited Workshops

#block(above: 0.5em)[
  #dated([_Outside Good Uncertainty: Ordinal Dual Response in Conjoint_, Sawtooth Research Conference], [2027])
  #dated([_Consumer Search in the U.S. Auto Industry_, UCLA Marketing Seminar Series], [2019])
  #dated([_Consumer Search in the U.S. Auto Industry_, University of Houston Doctoral Consortium], [2018])
  #dated([Machine Learning workshop, UCLA MSBA], [2018, 2019])
  #dated([Causality and Online Experiments workshop, UCLA MSBA], [2018])
  #dated([Tools for Reproducible Research workshop, Claremont McKenna College], [2016])
]

= Honors and Awards

#block(above: 0.5em)[
  #dated([Doctoral Fellow, AMA–Sheth Foundation Doctoral Consortium], [2018])
  #dated([Doctoral Fellow, Summer Institute in Competitive Strategy, UC Berkeley], [2017])
  #dated([Doctoral Fellow, ISMS Marketing Science Doctoral Consortium], [2017])
  #dated([Doctoral Fellow, Quantitative Marketing and Structural Econometrics Workshop], [2015])
  #dated([Doctoral Fellowship, UCLA Anderson], [2014 – 2020])
  #dated([Outstanding Student in Marketing, UCLA Anderson MBA], [2014])
  #dated([MBA Honor Society, UCLA Anderson], [2014])
  #dated([Best Economics Thesis, Claremont McKenna College], [2006])
  #dated([Phi Beta Kappa · Omicron Delta Epsilon · Cum Laude, Claremont McKenna College], [2006])
]

#v(0.8em)
#align(right)[#text(size: 9pt, style: "italic")[
  Last Updated #datetime.today().display("[month repr:long] [day], [year]")
]]
