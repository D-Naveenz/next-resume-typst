// NextResume metadata normalization helpers.
// User-facing metadata.toml should stay focused on user options. This file
// fills in compatibility defaults before handing metadata to brilliant-CV.

#let normalize-metadata(metadata) = {
  metadata + (
    // brilliant-CV reads metadata.inject directly in a few places. Keep the key
    // available without requiring hidden keyword fields in metadata.toml.
    inject: metadata.at("inject", default: (:)),
  )
}

#let to-brilliant-cv-metadata(metadata, suppress-footer: false) = {
  let normalized = normalize-metadata(metadata)

  if not suppress-footer {
    return normalized
  }

  let footer = normalized.layout.at("footer", default: (:))

  normalized + (
    layout: normalized.layout + (
      footer: footer + (
        // NextResume renders its own artifact footer, so the upstream footer
        // and page counter must stay disabled even when users enable ours.
        display_footer: false,
        display_page_counter: false,
      ),
    ),
  )
}
