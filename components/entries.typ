// Repo-local wrappers around brilliant-cv entry helpers so tag rows can use
// the shared hidden-delimiter tag renderer.
#import "@preview/brilliant-cv:3.3.0": cv-entry as upstream-cv-entry, cv-entry-start as upstream-cv-entry-start, cv-entry-continued as upstream-cv-entry-continued
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
  awesome-colors: none,
  awesomeColors: none,
  copy-delimiter: " | ",
) = {
  let entry-body = if awesome-colors == none and awesomeColors == none {
    upstream-cv-entry(
      title: title,
      society: society,
      date: date,
      location: location,
      description: description,
      logo: logo,
      tags: (),
      color: color,
      metadata: metadata,
    )
  } else {
    upstream-cv-entry(
      title: title,
      society: society,
      date: date,
      location: location,
      description: description,
      logo: logo,
      tags: (),
      color: color,
      metadata: metadata,
      awesome-colors: awesome-colors,
      awesomeColors: awesomeColors,
    )
  }

  [
    #entry-body
    #_entry-tags(tags, copy-delimiter: copy-delimiter)
  ]
}

#let cv-entry-start(
  society: "Society",
  location: "Location",
  logo: "",
  color: none,
  metadata: none,
  awesome-colors: none,
  awesomeColors: none,
) = {
  if awesome-colors == none and awesomeColors == none {
    return upstream-cv-entry-start(
      society: society,
      location: location,
      logo: logo,
      color: color,
      metadata: metadata,
    )
  }

  upstream-cv-entry-start(
    society: society,
    location: location,
    logo: logo,
    color: color,
    metadata: metadata,
    awesome-colors: awesome-colors,
    awesomeColors: awesomeColors,
  )
}

#let cv-entry-continued(
  title: "Title",
  date: "Date",
  description: "",
  tags: (),
  color: none,
  metadata: none,
  awesome-colors: none,
  awesomeColors: none,
  copy-delimiter: " | ",
) = {
  let entry-body = if awesome-colors == none and awesomeColors == none {
    upstream-cv-entry-continued(
      title: title,
      date: date,
      description: description,
      tags: (),
      color: color,
      metadata: metadata,
    )
  } else {
    upstream-cv-entry-continued(
      title: title,
      date: date,
      description: description,
      tags: (),
      color: color,
      metadata: metadata,
      awesome-colors: awesome-colors,
      awesomeColors: awesomeColors,
    )
  }

  [
    #entry-body
    #_entry-tags(tags, copy-delimiter: copy-delimiter)
  ]
}
