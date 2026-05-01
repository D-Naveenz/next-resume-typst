// Imports
#import "./core/nextresume.typ": cv
#import "./components/versioning.typ": validate-next-resume-version, set-next-resume-document-metadata

// --------------------------------------
// Metadata setup
// Loads repository metadata, applies the optional CLI language override, and
// validates that metadata.next_resume.version matches the root VERSION file.
#let metadata = toml("./metadata.toml")
#let cv-language = sys.inputs.at("language", default: none)
#let metadata = if cv-language != none {
  metadata + (language: cv-language)
} else {
  metadata
}
#let next-resume-version = validate-next-resume-version(metadata)

// --------------------------------------
// PDF document properties
// These values are document metadata only. Resume keywords should stay visible
// in the body, skills, and experience sections.
#set-next-resume-document-metadata(
  metadata,
  next-resume-version,
  kind: "cv",
)

// --------------------------------------
// Module loader
// Resolves section files from modules_<language>/ so the module list below can
// stay language-neutral.
#let import-modules(modules, lang: metadata.language) = {
  for module in modules {
    include {
      "modules_" + lang + "/" + module + ".typ"
    }
  }
}

// --------------------------------------
// Template setup
// Applies the NextResume CV wrapper around the imported modules. Header photo
// loading/cropping is handled by the local header component from metadata.
#show: cv.with(
  metadata,
  // To use custom image icons in personal.info.custom-N entries,
  // pass them here (keys must match the custom-N keys in metadata.toml):
  // custom-icons: (
  //   "custom-1": image("assets/my-icon.png"),
  // ),
)

// --------------------------------------
// Section selection
// Keep this list in the order the CV should render its visible sections.
#import-modules((
  "professional",
  "education",
  "projects",
  "certificates",
  "skills",
))
