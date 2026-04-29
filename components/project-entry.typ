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
        h(1em)
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
  let name-style = (value) => text(size: 10pt, weight: "bold", value)
  let role-style = (value) => align(right, text(weight: "medium", fill: accent, style: "oblique", value))
  let date-style = (value) => align(right, text(size: 8pt, weight: "medium", fill: gray, style: "oblique", value))
  let description-style = (value) => text(fill: _regular-colors.lightgray, value)
  let link-row = _links-row(links)

  v(before-entry-skip)
  table(
    columns: (1fr, date-width),
    inset: 0pt,
    stroke: 0pt,
    gutter: 6pt,
    align: (x, y) => if x == 1 { right } else { auto },
    name-style(name),
    role-style(role),
    description-style(description),
    date-style(date),
  )

  if link-row != none {
    text(size: 9pt, fill: _regular-colors.lightgray, link-row)
  }

  if body != none {
    v(before-description-skip)
    description-style(body)
  }

  _entry-tags(tags, copy-delimiter: copy-delimiter)
}
