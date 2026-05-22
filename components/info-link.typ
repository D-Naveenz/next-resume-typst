// Link helpers that keep polished visible text while exposing copy-safe values
// through the build-time ActualText post-processor.

#import "@preview/brilliant-cv:3.3.0": cv-metadata, _awesome-colors, _set-accent-color
#import "@preview/fontawesome:0.6.0": fa-github, fa-link, fa-cube
#import "./metadata.typ": metadata-or-default

#let _decorative-icon(icon) = {
  if icon != none {
    // Use a typed artifact so the post-processor can distinguish decorative
    // icon text from the plain artifact wrappers used for ActualText spans.
    pdf.artifact(kind: "page")[#icon]
  }
}

#let _value-body(text-value, icon: none) = [
  #if icon != none {
    _decorative-icon(icon)
    h(0.22em)
  }
  #text-value
]

#let _maybe-fill(color, body) = {
  if color == none {
    body
  } else {
    text(fill: color, body)
  }
}

#let actual-value(
  text-value,
  actual,
  url: none,
  icon: none,
  color: none,
  id-prefix: "info-link",
) = [
  // Typst query exports this manifest entry; tools/apply-actual-text.py then
  // turns the matching artifact wrapper into a Span with /ActualText.
  #metadata((kind: id-prefix, actual: actual, url: url)) <nextresume-actualtext>
  #{
    let visible = _maybe-fill(color, _value-body(text-value, icon: icon))
    let artifact = pdf.artifact(kind: "other")[#visible]

    if url == none {
      box[#artifact]
    } else {
      link(url)[
        // Group the mixed icon/text run into one annotation so Adobe-style
        // copy uses one ActualText replacement instead of repeating it.
        #box[#artifact]
      ]
    }
  }
]

#let info-link(
  name,
  text-value,
  url: none,
  icon: none,
  color: none,
  link-color: none,
  actual: none,
  id-prefix: "info-link",
  semantic: true,
) = context {
  let metadata = metadata-or-default(cv-metadata.get())
  let accent = if link-color != none { link-color } else { _set-accent-color(_awesome-colors, metadata) }
  let value-color = if url == none {
    color
  } else {
    accent
  }
  let actual-text = if actual != none {
    actual
  } else if url != none {
    url
  } else {
    none
  }
  let visible = [
    #_maybe-fill(color, [#name:#h(0.25em)])
    #text-value
  ]

  [
    #if not semantic {
      let body = _maybe-fill(value-color, _value-body(visible, icon: icon))
      if url == none {
        box[#body]
      } else {
        link(url)[#box[#body]]
      }
    } else if actual-text == none {
      _maybe-fill(color, _value-body(visible, icon: icon))
    } else if url == none {
      actual-value(
        visible,
        actual-text,
        icon: icon,
        color: value-color,
        id-prefix: id-prefix,
      )
    } else {
      actual-value(
        visible,
        actual-text,
        url: url,
        icon: icon,
        color: value-color,
        id-prefix: id-prefix,
      )
    }
  ]
}

#let project-link(
  kind,
  text,
  url,
  icon: none,
) = context {
  let metadata = metadata-or-default(cv-metadata.get())
  let default-icon = if kind == "Repository" {
    fa-github()
  } else if kind == "Deployment" {
    fa-cube()
  } else {
    fa-link()
  }

  [
    #kind:#h(0.25em)
    #actual-value(
      text,
      url,
      url: url,
      icon: if icon == none { default-icon } else { icon },
      color: _set-accent-color(_awesome-colors, metadata),
      id-prefix: "project-link",
    )
  ]
}
