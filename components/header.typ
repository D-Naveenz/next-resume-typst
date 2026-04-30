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
  fa-certificate,
  fa-envelope,
  fa-github,
  fa-gitlab,
  fa-graduation-cap,
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
#import "./info-link.typ": actual-value, info-link

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

#let _field(label, text-value, icon, url: none, actual: none) = {
  let actual = if actual == none { text-value } else { actual }

  info-link(
    label,
    text-value,
    url: url,
    icon: icon,
    actual: label + ": " + actual,
    id-prefix: "header-info",
  )
}

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
    return actual-value(
      text-value,
      actual,
      url: if url == "" { none } else { url },
      icon: icon,
      id-prefix: "header-info",
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
    _field("LinkedIn", value, fa-linkedin(), url: "https://www.linkedin.com/in/" + value, actual: "https://www.linkedin.com/in/" + value)
  } else if key == "github" {
    _field("GitHub", value, fa-github(), url: "https://github.com/" + value, actual: "https://github.com/" + value)
  } else if key == "gitlab" {
    _field("GitLab", value, fa-gitlab(), url: "https://gitlab.com/" + value, actual: "https://gitlab.com/" + value)
  } else if key == "homepage" {
    _field("Website", value, fa-pager(), url: _with-scheme(value), actual: _with-scheme(value))
  } else if key == "orcid" {
    _field("ORCID", value, fa-orcid(), url: "https://orcid.org/" + value, actual: "https://orcid.org/" + value)
  } else if key == "researchgate" {
    _field("ResearchGate", value, fa-researchgate(), url: "https://www.researchgate.net/profile/" + value, actual: "https://www.researchgate.net/profile/" + value)
  } else if key == "x" or key == "twitter" {
    _field("X", value, fa-x-twitter(), url: _x-url(value), actual: _x-url(value))
  } else if key == "medium" {
    _field("Medium", value, fa-medium(), url: _medium-url(value), actual: _medium-url(value))
  } else if key == "location" {
    _field("Location", value, fa-location-dot(), actual: value)
  } else if key == "extraInfo" {
    _field("Info", value, fa-info-circle(), actual: value)
  } else {
    _field(key, value, none, actual: value)
  }
}

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

#let _header-name-section(styles, non-latin, non-latin-name, first-name, last-name, personal-info, header-quote, custom-icons) = {
  table(
    columns: 1fr,
    inset: 0pt,
    stroke: none,
    row-gutter: 6mm,
    if non-latin {
      (styles.first-name)(non-latin-name)
    } else {
      [#(styles.first-name)(first-name) #h(5pt) #(styles.last-name)(last-name)]
    },
    [#(styles.info)(_header-info(personal-info, custom-icons))],
    .. if header-quote != none { ([#(styles.quote)(header-quote)],) },
  )
}

#let cv-header(
  metadata,
  profile-photo,
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
  let photo-section = _make-header-photo-section(display-profile-photo, profile-photo, profile-photo-radius)

  if display-profile-photo {
    _make-header((name-section, photo-section), (auto, 20%), header-alignment)
  } else {
    _make-header((name-section,), (auto,), header-alignment)
  }
}
