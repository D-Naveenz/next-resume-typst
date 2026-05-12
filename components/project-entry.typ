// NextResume project entry with semantic project/info links.

#import "@preview/brilliant-cv:3.3.0": cv-metadata, _regular-colors
#import "./entry.typ": cv-entry-header, cv-entry-description

#let _links-row(links, gap) = {
  if links.len() == 0 {
    return none
  }

  [
    #for (index, item) in links.enumerate() {
      if index > 0 {
        h(gap)
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
  let metadata = if metadata != none { metadata } else { cv-metadata.get() }
  let project-layout = metadata.layout.at("project", default: (:))
  let before-links-skip = eval(project-layout.at("before_links_skip", default: "0pt"))
  let before-body-skip = eval(project-layout.at(
    "before_body_skip",
    default: metadata.layout.at("before_entry_description_skip", default: "1pt"),
  ))
  let link-font-size = eval(project-layout.at("link_font_size", default: "9pt"))
  let link-gap = eval(project-layout.at("link_gap", default: "1em"))

  let link-row = _links-row(links, link-gap)
  let project-description-style = (value, before-skip) => text(
    fill: _regular-colors.lightgray,
    {
      v(before-body-skip)
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
      v(before-links-skip)
      text(size: link-font-size, fill: _regular-colors.lightgray, link-row)
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
