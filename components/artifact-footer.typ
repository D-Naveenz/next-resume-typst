// Visible CV footer marked as a PDF artifact so it is not part of the
// document's semantic reading order. It is rendered from an outlined SVG asset
// so the visible footer is vector-sharp but non-selectable.

#let artifact-footer(metadata) = {
  let footer = metadata.layout.at("footer", default: (:))
  let display-footer = footer.at("display_footer", default: true)

  if not display-footer {
    return none
  }

  let lang = metadata.language
  let asset-path = "../assets/footer/footer-" + lang + ".svg"

  context pdf.artifact(kind: "footer")[
    #image(asset-path, width: 100%)
  ]
}
