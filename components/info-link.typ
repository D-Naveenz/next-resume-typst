// Link helpers that keep polished visible text while exposing a richer PDF
// semantic string through the build-time ActualText post-processor.

#import "@preview/fontawesome:0.6.0": fa-github, fa-link, fa-cube

#let _link-body(label, text, icon: none) = [
  #label:#h(0.25em)
  #if icon != none {
    icon
    h(0.22em)
  }
  #text
]

#let info-link(
  label,
  text,
  url,
  icon: fa-link(),
  id-prefix: "info-link",
) = {
  let actual = label + ": " + url

  // Typst query exports this manifest entry; tools/apply-actual-text.py then
  // turns the matching artifact wrapper into a Span with /ActualText.
  [
    #metadata((kind: id-prefix, actual: actual, url: url)) <nextresume-actualtext>
    #pdf.artifact(kind: "other")[
      #link(url)[
        #_link-body(label, text, icon: icon)
      ]
    ]
  ]
}

#let project-link(
  kind,
  text,
  url,
  icon: none,
) = {
  let default-icon = if kind == "Repository" {
    fa-github()
  } else if kind == "Deployment" {
    fa-cube()
  } else {
    fa-link()
  }

  info-link(
    kind,
    text,
    url,
    icon: if icon == none { default-icon } else { icon },
    id-prefix: "project-link",
  )
}
