// Visible CV footer marked as a PDF artifact so it is not part of the
// document's semantic reading order or copied body text.

#let _footer-type-label(raw) = {
  if raw == "CV" or raw == "cv" {
    "Curriculum Vitae"
  } else if raw == "Resume" or raw == "resume" {
    "Resume"
  } else {
    raw
  }
}

#let artifact-footer(metadata) = {
  let footer = metadata.layout.at("footer", default: (:))
  let display-footer = footer.at("display_artifact_footer", default: true)

  if not display-footer {
    return none
  }

  let full-name = metadata.personal.first_name + " " + metadata.personal.last_name
  let raw-document-type = footer.at(
    "document_type",
    default: metadata.lang.at(metadata.language).at("cv_footer", default: "Resume"),
  )
  let document-type = _footer-type-label(raw-document-type)
  let footer-style(str) = text(size: 8pt, fill: rgb("#999999"), smallcaps(str))

  context pdf.artifact(kind: "footer")[
    #table(
      columns: (1fr, auto),
      inset: -5pt,
      stroke: none,
      footer-style(full-name),
      footer-style(document-type),
    )
  ]
}
