// Fallback metadata for editor diagnostics and standalone component previews.

#let default-cv-metadata = (
  language: "en",
  layout: (
    awesome_color: "skyblue",
    after_section_title_skip: "6pt",
    section_body_gap: "8pt",
    after_section_skip: "8pt",
    after_entry_header_skip: "1pt",
    after_entry_body_skip: "1pt",
    date_width: "4.8cm",
    entry: (
      display_entry_society_first: true,
      display_logo: true,
    ),
    project: (
      after_header_skip: "0pt",
      after_links_skip: "1pt",
      link_font_size: "9pt",
      link_gap: "1em",
    ),
    certificates: (
      after_section_title_skip: "6pt",
      after_section_skip: "6pt",
      body_gap: "0pt",
    ),
    skills: (
      after_section_title_skip: "6pt",
      after_section_skip: "0pt",
      body_gap: "1pt",
    ),
  ),
)

#let metadata-or-default(metadata) = {
  if metadata == none {
    default-cv-metadata
  } else {
    metadata
  }
}
