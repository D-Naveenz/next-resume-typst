// Universal repo-local tag row for decorative pill lists with copy-friendly delimiters.

#let _hidden-copy-delimiter(delim) = {
  box(
    width: 0pt,
    text(
      size: 1pt,
      fill: white,
      delim,
    ),
  )
}

#let tag-pill(
  tag,
  fill: luma(235),
  radius: 3pt,
  inset: (x: 0.5em, y: 0.35em),
  outset: (x: 0pt, y: 0pt),
  text-size: 9pt,
) = {
  box(
    inset: inset,
    outset: outset,
    fill: fill,
    radius: radius,
    align(center + horizon, text(size: text-size, weight: "regular", tag)),
  )
}

#let tag-row(
  tags: (),
  copy-delimiter: " | ",
  gap: 5pt,
  fill: luma(235),
  radius: 3pt,
  inset: (x: 0.5em, y: 0.35em),
  outset: (x: 0pt, y: 0pt),
  text-size: 9pt,
) = {
  if tags.len() == 0 {
    return none
  }

  [
    #for (index, tag) in tags.enumerate() {
      if index > 0 {
        _hidden-copy-delimiter(copy-delimiter)
        h(gap)
      }
      tag-pill(
        tag,
        fill: fill,
        radius: radius,
        inset: inset,
        outset: outset,
        text-size: text-size,
      )
    }
  ]
}
