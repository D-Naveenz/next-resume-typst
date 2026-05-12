// Repo-local skill helpers used when the upstream template layout is too rigid.
#import "@preview/brilliant-cv:3.3.0": cv-metadata
#import "./metadata.typ": metadata-or-default
#import "./tag-row.typ": tag-row

#let skill-pill-fill = luma(235)

#let _skill-row(type, body) = context {
  let metadata = metadata-or-default(cv-metadata.get())
  let skills-layout = metadata.layout.at("skills", default: (:))
  let after-row-skip = eval(skills-layout.at("after_row_skip", default: "2pt"))
  let skill-type-style(str) = {
    text(size: 10pt, weight: "bold", str)
  }

  table(
    columns: (20%, 1fr),
    inset: 0pt,
    column-gutter: 10pt,
    stroke: none,
    [
      #align(right + horizon, skill-type-style(type))
    ],
    [
      #align(left + horizon, body)
    ],
  )
  v(after-row-skip)
}

#let cv-skill(type: "Type", info: "Info") = {
  _skill-row(type, info)
}

#let cv-skill-tags(type: "Type", tags: (), copy-delimiter: " | ") = {
  _skill-row(
    type,
    tag-row(
      tags: tags,
      copy-delimiter: copy-delimiter,
      gap: 5pt,
      fill: skill-pill-fill,
      radius: 3pt,
      inset: (x: 0.5em, y: 0.35em),
      outset: (x: 0pt, y: 0pt),
      text-size: 9pt,
    ),
  )
}
