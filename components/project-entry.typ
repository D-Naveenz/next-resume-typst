// NextResume project entry with semantic project/info links.

#import "@preview/brilliant-cv:3.3.0": cv-metadata, _regular-colors
#import "./entry.typ": cv-entry-header, cv-entry-description
#import "./metadata.typ": metadata-or-default

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
  let metadata = metadata-or-default(if metadata != none { metadata } else { cv-metadata.get() })
  let project-layout = metadata.layout.at("project", default: (:))
  let after-header-skip = eval(project-layout.at("after_header_skip", default: "0pt"))
  let after-links-skip = eval(project-layout.at("after_links_skip", default: "1pt"))
  let link-font-size = eval(project-layout.at("link_font_size", default: "9pt"))
  let link-gap = eval(project-layout.at("link_gap", default: "1em"))

  let link-row = _links-row(links, link-gap)
  let project-description-style = (value) => text(fill: _regular-colors.lightgray, value)
  let project-subtitle-style = (value) => text(fill: _regular-colors.lightgray, value)
  let has-body = body != none and body != ""
  let has-details = has-body or tags.len() > 0

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
      v(after-header-skip)
      text(size: link-font-size, fill: _regular-colors.lightgray, link-row)
      if has-details {
        v(after-links-skip)
      }
    } else if has-details {
      v(after-header-skip)
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
