// Quarto partial override: intentionally empty.
//
// Quarto's default page.typ emits `#set page(paper: ..., margin: (x: 1.25in,
// y: 1.25in), ...)` before the show rule. modern-cv's `resume()` owns page
// setup (paper-size, margins, and the footer), so leaving Quarto's version in
// place means two competing `set page` rules. Blanking it lets the template win.
//
// Consequence: the `papersize` and `margin` YAML keys have no effect. Set the
// paper via `paper-size:` in typst-show.typ instead.
