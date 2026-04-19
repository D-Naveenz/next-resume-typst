// Queryable metadata wrapper for PDF post-processing. This produces no visible
// content beyond the wrapped body, but exposes page geometry and replacement
// text through `typst query`.

#let actual-text-tag(id, actual, body) = context {
  let loc = here()
  let pos = loc.position()
  let size = measure(body)

  [
    #metadata((
      kind: "actual-text",
      id: id,
      actual: actual,
      page: loc.page(),
      x: pos.x,
      y: pos.y,
      width: size.width,
      height: size.height,
    )) <next-resume-actual-text>
    #body
  ]
}
