// Repo-local skill helpers used when the upstream template layout is too rigid.
#import "./tag-row.typ": tag-row

#let skill-pill-fill = luma(235)

#let _skill-row(type, body) = {
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
  v(2pt)
}

#let cv-skill(type: "Type", info: "Info") = {
  _skill-row(type, info)
}

#let cv-skill-tags(type: "Type", tags: (), actual-delimiter: " | ") = {
  _skill-row(
    type,
    tag-row(
      tags: tags,
      id-prefix: "skill-tags-v2",
      actual-delimiter: actual-delimiter,
      gap: 5pt,
      fill: skill-pill-fill,
      radius: 3pt,
      inset: (x: 0.5em, y: 0.35em),
      text-size: 9pt,
    ),
  )
}
