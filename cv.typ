// Imports
#import "./core/nextresume.typ": cv
#import "./components/profile-photo.typ": profile-photo
#import "./components/versioning.typ": validate-next-resume-version, set-next-resume-document-metadata

// --------------------------------------
// Load metadata, apply the requested language, and validate the template version.
#let metadata = toml("./metadata.toml")
#let cv-language = sys.inputs.at("language", default: none)
#let metadata = if cv-language != none {
  metadata + (language: cv-language)
} else {
  metadata
}
#let next-resume-version = validate-next-resume-version(metadata)

// Keep PDF document properties aligned with the selected metadata.
#set-next-resume-document-metadata(
  metadata,
  next-resume-version,
  kind: "cv",
)

// --------------------------------------
// Include section modules from the active language folder.
#let import-modules(modules, lang: metadata.language) = {
  for module in modules {
    include {
      "modules_" + lang + "/" + module + ".typ"
    }
  }
}

// --------------------------------------
// Prepare a square-cover profile image before handing it to the template.
#let profile-photo-path = metadata.personal.at("profile_photo", default: "assets/avatar.png")
#let profile-photo-source = read(profile-photo-path, encoding: none)
#let profile-photo-offset-x = eval(metadata.personal.at("profile_photo_offset_x", default: "0pt"))
#let profile-photo-offset-y = eval(metadata.personal.at("profile_photo_offset_y", default: "0pt"))
#let profile-photo-scale-up = metadata.personal.at("profile_photo_scale_up", default: 0)
#let profile-photo = profile-photo(
  profile-photo-source,
  scale-up: profile-photo-scale-up,
  offset-x: profile-photo-offset-x,
  offset-y: profile-photo-offset-y,
)

// --------------------------------------
// Apply the NextResume CV wrapper around the imported modules.
#show: cv.with(
  metadata,
  profile-photo: profile-photo,
  // To use custom image icons in personal.info.custom-N entries,
  // pass them here (keys must match the custom-N keys in metadata.toml):
  // custom-icons: (
  //   "custom-1": image("assets/my-icon.png"),
  // ),
)

// --------------------------------------
// Select which language-specific modules appear in the CV.
#import-modules((
  "education",
  "professional",
  "projects",
  "certificates",
  "publications",
  "skills",
))
