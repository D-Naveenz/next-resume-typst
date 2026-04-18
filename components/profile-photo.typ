// Repo-local helper for square-cropped profile photos with optional position tuning.

#let profile-photo(
  source,
  aspect-ratio,
  size: 3.6cm,
  zoom: 1.12,
  offset-x: 0pt,
  offset-y: 0pt,
  alt: "Profile photo",
) = {
  let effective-zoom = calc.max(zoom, 1.0)
  let cover-width = if aspect-ratio >= 1.0 { size * aspect-ratio } else { size }
  let cover-height = if aspect-ratio >= 1.0 { size } else { size / aspect-ratio }
  let zoomed-width = cover-width * effective-zoom
  let zoomed-height = cover-height * effective-zoom
  let safe-scale = calc.max(
    1.0,
    (size + 2 * calc.abs(offset-x)) / zoomed-width,
    (size + 2 * calc.abs(offset-y)) / zoomed-height,
  )
  let image-width = zoomed-width * safe-scale
  let image-height = zoomed-height * safe-scale

  box(
    width: size,
    height: size,
    place(
      center + horizon,
      dx: offset-x,
      dy: offset-y,
      image(
        source,
        width: image-width,
        height: image-height,
        fit: "cover",
        alt: alt,
      ),
    ),
  )
}
