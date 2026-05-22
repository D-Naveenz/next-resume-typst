// Fallback metadata for editor diagnostics and standalone component previews.

#let default-cv-metadata = (
  language: "en",
  layout: (
    awesome_color: "skyblue",
    date_width: "4.8cm",
    header: (
      header_align: "left",
      after_header_skip: "12pt",
      display_profile_photo: true,
      profile_photo_radius: "50%",
      info_font_size: "10pt",
    ),
    section: (
      after_title_skip: "6pt",
      body_gap: "8pt",
      after_section_skip: "8pt",
    ),
    entry: (
      after_header_skip: "1pt",
      after_body_skip: "1pt",
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
      after_title_skip: "6pt",
      after_section_skip: "6pt",
      body_gap: "0pt",
    ),
    skills: (
      after_title_skip: "6pt",
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
