// NextResume entry primitives with bottom-owned spacing.
#import "@preview/brilliant-cv:3.3.0": cv-metadata, _awesome-colors, _regular-colors, _set-accent-color
#import "./metadata.typ": metadata-or-default
#import "./tag-row.typ": tag-row

#let _entry-tags(tags, copy-delimiter: " | ") = {
  if tags.len() == 0 {
    return none
  }

  tag-row(
    tags: tags,
    copy-delimiter: copy-delimiter,
    gap: 5pt,
    fill: luma(235),
    radius: 3pt,
    inset: (x: 0.25em, y: 0pt),
    outset: (x: 0pt, y: 0.25em),
    text-size: 8pt,
  )
}

#let _entry-params(metadata, color, awesome-colors, awesomeColors) = {
  if awesomeColors != none {
    panic("'awesomeColors' has been renamed and will be removed in v4.0. Use 'awesome-colors' instead.")
  }

  let date-width = metadata.layout.at("date_width", default: "4.8cm")
  (
    accent-color: if color != none { color } else { _set-accent-color(awesome-colors, metadata) },
    date-width: eval(date-width),
    after-entry-header-skip: eval(metadata.layout.at("after_entry_header_skip", default: "1pt")),
    after-entry-body-skip: eval(metadata.layout.at("after_entry_body_skip", default: "1pt")),
  )
}

#let _entry-visible(value) = value != none and value != ""

#let _entry-styles(accent-color) = (
  a1: (str) => text(size: 10pt, weight: "bold", str),
  a2: (str) => align(right, text(weight: "medium", fill: accent-color, style: "oblique", str)),
  b1: (str) => text(size: 8pt, fill: accent-color, weight: "medium", smallcaps(str)),
  b2: (str) => align(right, text(size: 8pt, weight: "medium", fill: gray, style: "oblique", str)),
  dates: (dates) => [
    #set list(marker: [])
    #dates
  ],
  description: (value) => text(fill: _regular-colors.lightgray, value),
)

#let cv-entry-header(
  primary,
  secondary,
  right-primary,
  right-secondary,
  logo: "",
  color: none,
  metadata: none,
  awesome-colors: _awesome-colors,
  awesomeColors: none,
  secondary-style: auto,
) = context {
  let metadata = metadata-or-default(if metadata != none { metadata } else { cv-metadata.get() })
  let params = _entry-params(metadata, color, awesome-colors, awesomeColors)
  let styles = _entry-styles(params.accent-color)
  let display-logo = metadata.layout.entry.display_logo
  let secondary-style = if secondary-style == auto { styles.b1 } else { secondary-style }

  table(
    columns: (1fr, params.date-width),
    inset: 0pt,
    stroke: 0pt,
    gutter: 6pt,
    align: (x, y) => if x == 1 { right } else { auto },
    table(
      columns: (if display-logo and logo != "" { 4% } else { 0% }, 1fr),
      inset: 0pt,
      stroke: 0pt,
      align: horizon,
      column-gutter: if display-logo and logo != "" { 4pt } else { 0pt },
      if logo == "" [] else {
        set image(width: 100%)
        logo
      },
      table(
        columns: auto,
        inset: 0pt,
        stroke: 0pt,
        row-gutter: 6pt,
        align: auto,
        {
          if _entry-visible(primary) {
            (styles.a1)(primary)
          }
        },
        {
          if _entry-visible(secondary) {
            secondary-style(secondary)
          }
        },
      ),
    ),
    table(
      columns: auto,
      inset: 0pt,
      stroke: 0pt,
      row-gutter: 6pt,
      align: auto,
      {
        if _entry-visible(right-primary) {
          (styles.a2)(right-primary)
        }
      },
      {
        if _entry-visible(right-secondary) {
          (styles.b2)(right-secondary)
        }
      },
    ),
  )
}

#let cv-entry-description(
  description,
  tags: (),
  description-style: auto,
  color: none,
  metadata: none,
  awesome-colors: _awesome-colors,
  awesomeColors: none,
  copy-delimiter: " | ",
  allow_break: false,
) = context {
  let metadata = metadata-or-default(if metadata != none { metadata } else { cv-metadata.get() })
  let params = _entry-params(metadata, color, awesome-colors, awesomeColors)
  let styles = _entry-styles(params.accent-color)
  let description-style = if description-style == auto {
    (value) => (styles.description)(value)
  } else {
    description-style
  }

  if _entry-visible(description) {
    description-style(description)
    if tags.len() > 0 {
      v(params.after-entry-body-skip)
    }
  }

  _entry-tags(tags, copy-delimiter: copy-delimiter)
}

#let cv-entry(
  title: "Title",
  society: "Society",
  date: "Date",
  location: "Location",
  description: "",
  logo: "",
  tags: (),
  color: none,
  metadata: none,
  awesome-colors: _awesome-colors,
  awesomeColors: none,
  copy-delimiter: " | ",
  allow_break: false,
) = context {
  let metadata = metadata-or-default(if metadata != none { metadata } else { cv-metadata.get() })
  let params = _entry-params(metadata, color, awesome-colors, awesomeColors)
  let styles = _entry-styles(params.accent-color)
  let society-first = metadata.layout.entry.display_entry_society_first

  let primary = if society-first { society } else { title }
  let secondary = if society-first { title } else { society }
  let right-primary = if society-first { location } else { (styles.dates)(date) }
  let right-secondary = if society-first { (styles.dates)(date) } else { location }

  block(breakable: allow_break)[
    #cv-entry-header(
      primary,
      secondary,
      right-primary,
      right-secondary,
      logo: logo,
      color: color,
      metadata: metadata,
      awesome-colors: awesome-colors,
    )
    #if _entry-visible(description) or tags.len() > 0 {
      v(params.after-entry-header-skip)
    }
    #cv-entry-description(
      description,
      tags: tags,
      color: color,
      metadata: metadata,
      awesome-colors: awesome-colors,
      copy-delimiter: copy-delimiter,
    )
  ]
}
