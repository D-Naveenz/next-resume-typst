// NextResume CV header with semantic personal info links.

#import "@preview/brilliant-cv:3.3.0": (
  _header-styles,
  _is-non-latin,
  _make-header,
  _make-header-photo-section,
  _set-accent-color,
  h-bar,
)
#import "@preview/fontawesome:0.6.0": (
  fa-envelope,
  fa-github,
  fa-gitlab,
  fa-icon,
  fa-info-circle,
  fa-linkedin,
  fa-location-dot,
  fa-medium,
  fa-orcid,
  fa-pager,
  fa-phone,
  fa-researchgate,
  fa-x-twitter,
)
#import "./info-link.typ": info-link
#import "./profile-photo.typ": profile-photo

// --------------------------------------
// Canonical URL helpers for metadata values that are stored as short handles.
#let _with-scheme(value) = if value.contains("://") { value } else { "https://" + value }
#let _clean-handle(value) = value.replace("@", "")
#let _x-url(value) = _with-scheme("x.com/" + _clean-handle(value))
#let _medium-url(value) = if value.contains("://") {
  value
} else if value.contains("@") {
  "https://medium.com/" + value
} else {
  "https://medium.com/@" + value
}
#let _repo-relative(path) = if path.starts-with("/") or path.contains(":") {
  path
} else {
  "../" + path
}

// --------------------------------------
// Shared contact-field renderer. The visible header stays compact while the PDF
// link target carries the canonical machine-readable value. Header ActualText is
// intentionally avoided because Adobe repeats it across nested link runs.
#let _field(label, text-value, icon, url: none, actual: none) = {
  info-link(
    label,
    text-value,
    url: url,
    icon: icon,
    semantic: false,
  )
}

#let _plain-field(text-value, icon, url: none) = {
  let body = [
    #if icon != none {
      pdf.artifact(kind: "page")[#icon]
      h(0.22em)
    }
    #text-value
  ]

  if url == none {
    box[#body]
  } else {
    link(url)[#box[#body]]
  }
}

// --------------------------------------
// Custom metadata helpers. Users can add personal.info.custom-N entries with a
// Font Awesome icon name or a cv.typ-provided image icon.
#let _custom-icon(key, value, custom-icons) = {
  let image-icon = custom-icons.at(key, default: none)
  if image-icon != none {
    return box(width: 10pt, {
      set image(width: 100%)
      image-icon
    })
  }

  let awesome-icon = value.at("awesomeIcon", default: "")
  if awesome-icon != "" {
    return fa-icon(awesome-icon)
  }

  none
}

#let _custom-info(key, value, custom-icons) = {
  let text-value = value.at("text", default: "")
  if text-value == "" {
    return none
  }

  let url = value.at("link", default: "")
  let icon = _custom-icon(key, value, custom-icons)
  let label = value.at("name", default: value.at("label", default: ""))
  let actual = if url == "" { text-value } else { url }

  if label == "" {
    return _plain-field(
      text-value,
      icon,
      url: if url == "" { none } else { url },
    )
  }

  _field(
    label,
    text-value,
    icon,
    url: if url == "" { none } else { url },
    actual: actual,
  )
}

#let _personal-info-item(key, value, custom-icons) = {
  if key.contains("custom") {
    return _custom-info(key, value, custom-icons)
  }

  if value == "" {
    return none
  }

  if key == "phone" {
    _field("Phone", value, fa-phone(), url: "tel:" + value.replace(" ", ""), actual: value)
  } else if key == "email" {
    _field("Email", value, fa-envelope(), url: "mailto:" + value, actual: value)
  } else if key == "linkedin" {
    let url = "https://www.linkedin.com/in/" + value
    _field("LinkedIn", value, fa-linkedin(), url: url, actual: url)
  } else if key == "github" {
    let url = "https://github.com/" + value
    _field("GitHub", value, fa-github(), url: url, actual: url)
  } else if key == "gitlab" {
    let url = "https://gitlab.com/" + value
    _field("GitLab", value, fa-gitlab(), url: url, actual: url)
  } else if key == "homepage" {
    let url = _with-scheme(value)
    _field("Website", value, fa-pager(), url: url, actual: url)
  } else if key == "orcid" {
    let url = "https://orcid.org/" + value
    _field("ORCID", value, fa-orcid(), url: url, actual: url)
  } else if key == "researchgate" {
    let url = "https://www.researchgate.net/profile/" + value
    _field("ResearchGate", value, fa-researchgate(), url: url, actual: url)
  } else if key == "x" or key == "twitter" {
    let url = _x-url(value)
    _field("X", value, fa-x-twitter(), url: url, actual: url)
  } else if key == "medium" {
    let url = _medium-url(value)
    _field("Medium", value, fa-medium(), url: url, actual: url)
  } else if key == "location" {
    _field("Location", value, fa-location-dot(), actual: value)
  } else if key == "extraInfo" {
    _field("Info", value, fa-info-circle(), actual: value)
  } else {
    _field(key, value, none, actual: value)
  }
}

// --------------------------------------
// Render contact entries in metadata order, preserving explicit line breaks.
#let _header-info(personal-info, custom-icons) = {
  let rendered = 0
  for (key, value) in personal-info {
    if key == "linebreak" {
      rendered = 0
      linebreak()
      continue
    }

    let item = _personal-info-item(key, value, custom-icons)
    if item != none {
      if rendered > 0 {
        h-bar()
      }
      item
      rendered = rendered + 1
    }
  }
}

// --------------------------------------
// Prepare the profile image inside the header so cv.typ only has to provide
// metadata. A passed profile-photo still overrides metadata for compatibility.
#let _prepare-profile-photo(metadata, profile-photo-override) = {
  if profile-photo-override != none {
    return profile-photo-override
  }

  if not metadata.layout.header.display_profile_photo {
    return none
  }

  let path = metadata.personal.at("profile_photo", default: "assets/avatar.png")
  let source = read(_repo-relative(path), encoding: none)
  let offset-x = eval(metadata.personal.at("profile_photo_offset_x", default: "0pt"))
  let offset-y = eval(metadata.personal.at("profile_photo_offset_y", default: "0pt"))
  let scale-up = metadata.personal.at("profile_photo_scale_up", default: 0)

  profile-photo(
    source,
    scale-up: scale-up,
    offset-x: offset-x,
    offset-y: offset-y,
  )
}

// --------------------------------------
// Name row. Keep the visible name as real selectable text; block boundaries in
// `_header-name-section` handle extraction order between name and contact info.
#let _header-name(styles, non-latin, non-latin-name, first-name, last-name) = {
  if non-latin {
    (styles.first-name)(non-latin-name)
  } else {
    [#(styles.first-name)(first-name) #h(5pt) #(styles.last-name)(last-name)]
  }
}

// --------------------------------------
// Rebuild brilliant-CV's header name/info/quote section with NextResume's
// semantic contact renderer.
#let _header-name-section(styles, non-latin, non-latin-name, first-name, last-name, personal-info, header-quote, custom-icons) = {
  grid(
    columns: 1fr,
    gutter: 0pt,
    row-gutter: 6mm,
    _header-name(styles, non-latin, non-latin-name, first-name, last-name),
    [#(styles.info)(_header-info(personal-info, custom-icons))],
    .. if header-quote != none { ([#(styles.quote)(header-quote)],) },
  )
}

// --------------------------------------
// Public CV header component consumed by core/nextresume.typ.
#let cv-header(
  metadata,
  profile-photo-override,
  header-font,
  regular-colors,
  awesome-colors,
  custom-icons,
) = {
  let header-alignment = eval(metadata.layout.header.header_align)
  if metadata.inject.at("inject_ai_prompt", default: none) != none {
    panic("'inject_ai_prompt' has been removed and will be fully deprecated in v4.0. Use 'custom_ai_prompt_text' in [inject] instead.")
  }
  if metadata.inject.at("inject_keywords", default: none) != none {
    panic("'inject_keywords' has been removed and will be fully deprecated in v4.0. Use 'injected_keywords_list' directly instead — if the list is present, keywords will be injected. To disable injection, remove 'injected_keywords_list'.")
  }

  let personal-info = metadata.personal.info
  let first-name = metadata.personal.first_name
  let last-name = metadata.personal.last_name
  let header-quote = metadata.lang.at(metadata.language).at("header_quote", default: none)
  let display-profile-photo = metadata.layout.header.display_profile_photo
  let profile-photo-radius = eval(metadata.layout.header.at("profile_photo_radius", default: "50%"))
  let header-info-font-size = eval(metadata.layout.header.at("info_font_size", default: "10pt"))
  let accent-color = _set-accent-color(awesome-colors, metadata)
  let non-latin-name = ""
  let non-latin = _is-non-latin(metadata.language)
  if non-latin {
    non-latin-name = metadata.lang.non_latin.name
  }

  let styles = _header-styles(header-font, regular-colors, accent-color, header-info-font-size)
  let name-section = _header-name-section(styles, non-latin, non-latin-name, first-name, last-name, personal-info, header-quote, custom-icons)
  let profile-photo = _prepare-profile-photo(metadata, profile-photo-override)
  let photo-section = _make-header-photo-section(display-profile-photo, profile-photo, profile-photo-radius)

  if display-profile-photo {
    _make-header((name-section, photo-section), (auto, 20%), header-alignment)
  } else {
    _make-header((name-section,), (auto,), header-alignment)
  }
}
