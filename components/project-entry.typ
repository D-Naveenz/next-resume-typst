// NextResume project entry with semantic project/info links.

#import "@preview/brilliant-cv:3.3.0": _regular-colors
#import "./entry.typ": cv-entry-header, cv-entry-description

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
  allow_break: false,
) = context {
  let link-row = _links-row(links)
  let project-description-style = (value, before-skip) => text(
    fill: _regular-colors.lightgray,
    {
      v(before-skip)
      value
    },
  )
  let project-subtitle-style = (value) => text(fill: _regular-colors.lightgray, value)

  block(breakable: allow_break)[
    #cv-entry-header(
      name,
      description,
      role,
      date,
      color: color,
      metadata: metadata,
      secondary-style: project-subtitle-style,
    )

    #if link-row != none {
      text(size: 9pt, fill: _regular-colors.lightgray, link-row)
    }

    #cv-entry-description(
      body,
      tags: tags,
      description-style: project-description-style,
      color: color,
      metadata: metadata,
      copy-delimiter: copy-delimiter,
    )
  ]
}
