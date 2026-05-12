// NextResume CV template based on brilliant-cv.
// Keeps the upstream layout model while rendering the CV footer as an outlined
// SVG PDF artifact for cleaner copy/reflow behavior.

#import "@preview/brilliant-cv:3.3.0": (
  cv-metadata,
  overwrite-fonts,
  _awesome-colors,
  _is-non-latin,
  _latin-font-list,
  _latin-header-font,
  _regular-colors,
)
#import "../components/artifact-footer.typ": artifact-footer
#import "../components/header.typ": cv-header
#import "./metadata.typ": normalize-metadata, to-brilliant-cv-metadata

#let cv(
  metadata,
  doc,
  profile-photo: none,
  custom-icons: (:),
  profilePhoto: none,
) = {
  if profilePhoto != none {
    panic("'profilePhoto' has been renamed and will be removed in v4.0. Use 'profile-photo' instead.")
  }

  // Keep NextResume metadata separate from the upstream-safe copy. Our artifact
  // footer still needs the user's original footer preference.
  let nextresume-metadata = normalize-metadata(metadata)
  let upstream-metadata = to-brilliant-cv-metadata(nextresume-metadata, suppress-footer: true)

  cv-metadata.update(upstream-metadata)

  let lang = upstream-metadata.language
  let fonts = _latin-font-list
  let header-font = _latin-header-font

  let font-config = overwrite-fonts(upstream-metadata, _latin-font-list, _latin-header-font)
  fonts = font-config.regular-fonts
  header-font = font-config.header-font

  if _is-non-latin(lang) {
    let non-latin-font = upstream-metadata.lang.non_latin.font
    fonts.insert(calc.min(2, fonts.len()), non-latin-font)
    header-font = non-latin-font
  }

  let font-size = eval(upstream-metadata.layout.at("font_size", default: "9pt"))
  set text(font: fonts, weight: "regular", size: font-size, fill: _regular-colors.lightgray)
  set align(left)

  let paper-size = upstream-metadata.layout.at("paper_size", default: "a4")
  set page(
    paper: {paper-size},
    margin: {
      if paper-size == "us-letter" {
        (left: 2cm, right: 1.4cm, top: 1.2cm, bottom: 1.2cm)
      } else {
        (left: 1.4cm, right: 1.4cm, top: 1cm, bottom: 1cm)
      }
    },
    footer: context artifact-footer(nextresume-metadata),
  )

  cv-header(upstream-metadata, profile-photo, header-font, _regular-colors, _awesome-colors, custom-icons)
  v(eval(upstream-metadata.layout.at("after_header_skip", default: "12pt")))
  doc
}
