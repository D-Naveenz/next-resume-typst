// Repo-local skill helpers used when the upstream template layout is too rigid.

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

#let _skill-tag(skill) = {
  box(
    inset: (x: 0.5em, y: 0.35em),
    fill: skill-pill-fill,
    radius: 3pt,
    align(center + horizon, text(size: 9pt, skill)),
  )
}

#let cv-skill-tags(type: "Type", tags: ()) = {
  _skill-row(
    type,
    [
      #for (index, tag) in tags.enumerate() {
        _skill-tag(tag)
        if index < tags.len() - 1 {
          h(5pt)
        }
      }
    ],
  )
}
