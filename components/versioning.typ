// Repo-local NextResume version validation and PDF metadata helpers.

#let _parse-next-resume-version(raw, source: "version value") = {
  let value = raw.trim()
  let parts = value.split(".")

  assert.eq(
    parts.len(),
    3,
    message: source + " must use major.minor.patch format.",
  )

  version(
    int(parts.at(0)),
    int(parts.at(1)),
    int(parts.at(2)),
  )
}

#let validate-next-resume-version(
  metadata,
  version-path: "../VERSION",
) = {
  let product-version-raw = read(version-path).trim()
  let metadata-version-raw = metadata
    .at("next_resume", default: (:))
    .at("version", default: none)

  assert(
    metadata-version-raw != none,
    message: "metadata.toml is missing next_resume.version.",
  )

  let product-version = _parse-next-resume-version(
    product-version-raw,
    source: version-path,
  )
  let metadata-version = _parse-next-resume-version(
    metadata-version-raw,
    source: "metadata.toml next_resume.version",
  )

  assert.eq(
    metadata-version,
    product-version,
    message: "metadata.toml next_resume.version must exactly match " + version-path + ".",
  )

  (
    raw: product-version-raw,
    parsed: product-version,
  )
}

#let set-next-resume-document-metadata(
  metadata,
  next-resume-version,
  kind: "cv",
) = {
  let full-name = metadata.personal.first_name + " " + metadata.personal.last_name
  let title = if kind == "letter" {
    full-name + " - Cover Letter"
  } else {
    full-name + " - Resume"
  }
  let description = "Generated with NextResume v" + next-resume-version.raw + " (" + kind + ")"
  let keywords = (
    "NextResume",
    "v" + next-resume-version.raw,
    kind,
  )

  set document(
    title: [#title],
    author: (full-name,),
    description: [#description],
    keywords: keywords,
  )
}
