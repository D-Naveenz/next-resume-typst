// Queryable metadata wrappers for PDF post-processing.

#let actual-text-row(id, actual, anchor-id) = [
  #metadata((
    kind: "actual-text-row",
    id: id,
    actual: actual,
    anchor_id: anchor-id,
  )) <next-resume-actual-text>
]

#let actual-text-target(id, row-id, body) = context {
  let loc = here()
  let pos = loc.position()
  let size = measure(body)

  [
    #metadata((
      kind: "actual-text-target",
      id: id,
      row_id: row-id,
      page: loc.page(),
      x: pos.x,
      y: pos.y,
      width: size.width,
      height: size.height,
    )) <next-resume-actual-text>
    #body
  ]
}
