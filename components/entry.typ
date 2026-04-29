// NextResume entry primitives based on brilliant-cv's entry layout.
#import "@preview/brilliant-cv:3.3.0": cv-metadata, _awesome-colors, _prepare-entry-params, _entry-styles
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

  _prepare-entry-params(metadata, awesome-colors, color: color)
}

#let _entry-visible(value) = value != none and value != ""

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
  let metadata = if metadata != none { metadata } else { cv-metadata.get() }
  let params = _entry-params(metadata, color, awesome-colors, awesomeColors)
  let styles = _entry-styles(params.accent-color, params.before-entry-description-skip)
  let display-logo = metadata.layout.entry.display_logo
  let secondary-style = if secondary-style == auto { styles.b1 } else { secondary-style }

  v(params.before-entry-skip)
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
) = context {
  let metadata = if metadata != none { metadata } else { cv-metadata.get() }
  let params = _entry-params(metadata, color, awesome-colors, awesomeColors)
  let styles = _entry-styles(params.accent-color, params.before-entry-description-skip)
  let description-style = if description-style == auto {
    (value, before-skip) => (styles.description)(value)
  } else {
    description-style
  }

  if _entry-visible(description) {
    description-style(description, params.before-entry-description-skip)
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
) = context {
  let metadata = if metadata != none { metadata } else { cv-metadata.get() }
  let params = _entry-params(metadata, color, awesome-colors, awesomeColors)
  let styles = _entry-styles(params.accent-color, params.before-entry-description-skip)
  let society-first = metadata.layout.entry.display_entry_society_first

  let primary = if society-first { society } else { title }
  let secondary = if society-first { title } else { society }
  let right-primary = if society-first { location } else { (styles.dates)(date) }
  let right-secondary = if society-first { (styles.dates)(date) } else { location }

  cv-entry-header(
    primary,
    secondary,
    right-primary,
    right-secondary,
    logo: logo,
    color: color,
    metadata: metadata,
    awesome-colors: awesome-colors,
  )
  cv-entry-description(
    description,
    tags: tags,
    color: color,
    metadata: metadata,
    awesome-colors: awesome-colors,
    copy-delimiter: copy-delimiter,
  )
}
