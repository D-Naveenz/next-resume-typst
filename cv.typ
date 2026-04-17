// Imports
#import "@preview/brilliant-cv:3.3.0": cv
#import "./components/profile-photo.typ": profile-photo
#let metadata = toml("./metadata.toml")
#let cv-language = sys.inputs.at("language", default: none)
#let metadata = if cv-language != none {
  metadata + (language: cv-language)
} else {
  metadata
}
#let profile-photo-path = metadata.personal.at("profile_photo", default: "assets/avatar.png")
#let profile-photo-source = read(profile-photo-path, encoding: none)
#let profile-photo-aspect-ratio = metadata.personal.at("profile_photo_aspect_ratio", default: 1.0)
#let profile-photo-offset-x = eval(metadata.personal.at("profile_photo_offset_x", default: "0pt"))
#let profile-photo-offset-y = eval(metadata.personal.at("profile_photo_offset_y", default: "0pt"))
#let profile-photo-zoom = metadata.personal.at("profile_photo_zoom", default: 1.12)
#let profile-photo = profile-photo(
  profile-photo-source,
  profile-photo-aspect-ratio,
  zoom: profile-photo-zoom,
  offset-x: profile-photo-offset-x,
  offset-y: profile-photo-offset-y,
)

#let import-modules(modules, lang: metadata.language) = {
  for module in modules {
    include {
      "modules_" + lang + "/" + module + ".typ"
    }
  }
}

#show: cv.with(
  metadata,
  profile-photo: profile-photo,
  // To use custom image icons in personal.info.custom-N entries,
  // pass them here (keys must match the custom-N keys in metadata.toml):
  // custom-icons: (
  //   "custom-1": image("assets/my-icon.png"),
  // ),
)

#import-modules((
  "education",
  "professional",
  "projects",
  "certificates",
  "publications",
  "skills",
))
