// Repo-local helper for square-cropped profile photos with optional position tuning.

#let profile-photo(
  source,
  size: 3.6cm,
  zoom: 1.12,
  offset-x: 0pt,
  offset-y: 0pt,
  alt: "Profile photo",
) = {
  let image-width = size * zoom + 2 * calc.abs(offset-x)
  let image-height = size * zoom + 2 * calc.abs(offset-y)

  box(
    width: size,
    height: size,
    clip: true,
    radius: 50%,
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
