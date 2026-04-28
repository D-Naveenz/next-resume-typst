// Repo-local CV wrapper that keeps the upstream brilliant-cv layout but
// renders the footer as a PDF artifact for cleaner copy/reflow behavior.

#import "@preview/brilliant-cv:3.3.0": (
  cv-metadata,
  overwrite-fonts,
  _awesome-colors,
  _cv-header,
  _is-non-latin,
  _latin-font-list,
  _latin-header-font,
  _regular-colors,
)
#import "./artifact-footer.typ": artifact-footer

#let cv-with-artifact-footer(
  metadata,
  doc,
  profile-photo: none,
  custom-icons: (:),
  profilePhoto: none,
) = {
  if profilePhoto != none {
    panic("'profilePhoto' has been renamed and will be removed in v4.0. Use 'profile-photo' instead.")
  }

  cv-metadata.update(metadata)

  let lang = metadata.language
  let fonts = _latin-font-list
  let header-font = _latin-header-font

  let font-config = overwrite-fonts(metadata, _latin-font-list, _latin-header-font)
  fonts = font-config.regular-fonts
  header-font = font-config.header-font

  if _is-non-latin(lang) {
    let non-latin-font = metadata.lang.non_latin.font
    fonts.insert(calc.min(2, fonts.len()), non-latin-font)
    header-font = non-latin-font
  }

  let font-size = eval(metadata.layout.at("font_size", default: "9pt"))
  set text(font: fonts, weight: "regular", size: font-size, fill: _regular-colors.lightgray)
  set align(left)

  let paper-size = metadata.layout.at("paper_size", default: "a4")
  set page(
    paper: {paper-size},
    margin: {
      if paper-size == "us-letter" {
        (left: 2cm, right: 1.4cm, top: 1.2cm, bottom: 1.2cm)
      } else {
        (left: 1.4cm, right: 1.4cm, top: 1cm, bottom: 1cm)
      }
    },
    footer: context artifact-footer(metadata),
  )

  _cv-header(metadata, profile-photo, header-font, _regular-colors, _awesome-colors, custom-icons)
  doc
}
