// NextResume project entry with semantic project/info links.

#import "@preview/brilliant-cv:3.3.0": cv-metadata, _awesome-colors, _regular-colors, _set-accent-color
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

#let _links-row(links) = {
  if links.len() == 0 {
    return none
  }

  [
    #for (index, item) in links.enumerate() {
      if index > 0 {
        text(", ")
      }
      item
    }
  ]
}

#let project-entry(
  name,
  role,
  description,
  date,
  links: (),
  body: none,
  tags: (),
  color: none,
  metadata: none,
  copy-delimiter: " | ",
) = context {
  let metadata = if metadata != none { metadata } else { cv-metadata.get() }
  let accent = if color != none { color } else { _set-accent-color(_awesome-colors, metadata) }
  let date-width = eval(metadata.layout.at("date_width", default: "4.8cm"))
  let before-entry-skip = eval(metadata.layout.at("before_entry_skip", default: "4pt"))
  let before-description-skip = eval(metadata.layout.at("before_entry_description_skip", default: "1pt"))

  v(before-entry-skip)
  grid(
    columns: (1fr, date-width),
    column-gutter: 10pt,
    row-gutter: 1pt,
    inset: 0pt,
    text(size: 10pt, weight: "bold", fill: _regular-colors.darkgray, name),
    align(right, text(size: 10pt, weight: "bold", fill: accent, role)),
    text(size: 9pt, fill: _regular-colors.lightgray, description),
    align(right, text(size: 9pt, fill: _regular-colors.lightgray, date)),
    grid.cell(colspan: 2)[#text(size: 9pt, fill: _regular-colors.lightgray, _links-row(links))],
  )

  if body != none {
    v(before-description-skip)
    body
  }

  _entry-tags(tags, copy-delimiter: copy-delimiter)
}
