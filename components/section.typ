// Local CV section heading with bottom-owned spacing.

#import "@preview/brilliant-cv:3.3.0": cv-metadata, _awesome-colors, _is-non-latin, _set-accent-color
#import "./metadata.typ": metadata-or-default

#let cv-section(
  title,
  highlighted: true,
  letters: 3,
  color: none,
  metadata: none,
  awesome-colors: _awesome-colors,
  awesomeColors: none,
) = context {
  let metadata = metadata-or-default(if metadata != none { metadata } else { cv-metadata.get() })
  if awesomeColors != none {
    panic("'awesomeColors' has been renamed and will be removed in v4.0. Use 'awesome-colors' instead.")
  }

  let accent-color = if color != none { color } else { _set-accent-color(awesome-colors, metadata) }
  let highlighted-text = title.slice(0, letters)
  let normal-text = title.slice(letters)
  let after-title-skip = eval(metadata.layout.at("after_section_title_skip", default: "6pt"))
  let non-latin = _is-non-latin(metadata.language)

  let section-title-style(str, color: black) = {
    text(size: 16pt, weight: "bold", fill: color, str)
  }

  block(sticky: true)[
    #if non-latin {
      section-title-style(title, color: accent-color)
    } else if highlighted {
      section-title-style(highlighted-text, color: accent-color)
      section-title-style(normal-text, color: black)
    } else {
      section-title-style(title, color: black)
    }
    #h(2pt)
    #box(width: 1fr, line(stroke: 0.9pt, length: 100%))
  ]
  v(after-title-skip)
}
