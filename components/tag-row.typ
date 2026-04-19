// Universal repo-local tag row for decorative pill lists with ATS semantics.
#import "./actual-text.typ": actual-text-row, actual-text-target

#let tag-pill(
  tag,
  fill: luma(235),
  radius: 3pt,
  inset: (x: 0.5em, y: 0.35em),
  text-size: 9pt,
) = {
  box(
    inset: inset,
    fill: fill,
    radius: radius,
    align(center + horizon, text(size: text-size, tag)),
  )
}

#let tag-row(
  tags: (),
  id-prefix: "tag-row",
  actual-delimiter: " | ",
  gap: 5pt,
  fill: luma(235),
  radius: 3pt,
  inset: (x: 0.5em, y: 0.35em),
  text-size: 9pt,
) = {
  if tags.len() == 0 {
    return none
  }

  let row-id = id-prefix + "-row"
  let anchor-id = id-prefix + "-0"
  let actual = tags.join(actual-delimiter)

  [
    #actual-text-row(row-id, actual, anchor-id)
    #for (index, tag) in tags.enumerate() {
      let tag-id = id-prefix + "-" + str(index)
      actual-text-target(
        tag-id,
        row-id,
        tag-pill(
          tag,
          fill: fill,
          radius: radius,
          inset: inset,
          text-size: text-size,
        ),
      )
      if index < tags.len() - 1 {
        h(gap)
      }
    }
  ]
}
