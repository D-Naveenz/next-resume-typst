// Repo-local helper for square-cropped profile photos with optional position tuning.

#let profile-photo(
  source,
  size: 3.6cm,
  scale-up: 0,
  offset-x: 0pt,
  offset-y: 0pt,
  alt: "Profile photo",
) = context {
  let natural-size = measure(image(source))
  let aspect-ratio = natural-size.width / natural-size.height
  let effective-scale = 1.0 + calc.max(scale-up, 0) / 100.0
  let cover-width = if aspect-ratio >= 1.0 { size * aspect-ratio } else { size }
  let cover-height = if aspect-ratio >= 1.0 { size } else { size / aspect-ratio }
  let scaled-width = cover-width * effective-scale
  let scaled-height = cover-height * effective-scale
  let safe-scale = calc.max(
    1.0,
    (size + 2 * calc.abs(offset-x)) / scaled-width,
    (size + 2 * calc.abs(offset-y)) / scaled-height,
  )
  let image-width = scaled-width * safe-scale
  let image-height = scaled-height * safe-scale

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
