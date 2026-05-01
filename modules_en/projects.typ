// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section
#import "../components/info-link.typ": info-link, project-link
#import "../components/project-entry.typ": project-entry


#cv-section("Projects & Associations")

#project-entry(
  [Dhara Toolchain],
  [Creator & Maintainer],
  [Open-source storage runtime, package format, and BACnet tooling],
  [2025 - Present],
  links: (
    project-link(
      "Repository",
      [dhara_storage],
      "https://github.com/D-Naveenz/dhara_storage",
    ),
    project-link(
      "Crate",
      [dhara_storage],
      "https://crates.io/crates/dhara_storage",
    ),
    project-link(
      "DHBIN",
      [dhara_dhbin],
      "https://crates.io/crates/dhara_dhbin",
    ),
  ),
  body: list(
    [Built a Rust-first storage toolchain around file analysis, directory operations, debounced watching, and reusable package formats.],
    [Developed dhara_storage and dhara_dhbin for runtime storage operations and MessagePack-based container packaging.],
    [Built Dhara.BACnet.Explorer as a WinUI 3 and Python BACnet exploration/simulation app backed by Dhara libraries.],
  ),
  tags: ("Rust", "C#", "WinUI 3", "Python", "DHBIN", "MessagePack", "FFI", ".NET", "BACnet"),
)

#project-entry(
  [NextResume],
  [Creator & Maintainer],
  [AI-assisted Typst resume generator and template system],
  [Jan 2025 - Present],
  links: (
    project-link(
      "Repository",
      [NextResume],
      "https://github.com/D-Naveenz/next-resume-typst",
    ),
    info-link(
      "Deployment",
      [Typst Universe (Planned)],
      semantic: false,
    ),
  ),
  body: list(
    [Built an AI-assisted resume workflow where agent-generated content flows through a Python preprocessor into Typst.],
    [Added post-processing for PDF metadata, semantic contact/project links, page rendering, inspection, and artifact footers.],
    [Generated this resume with the same NextResume toolchain to validate the template against real tailoring work.],
  ),
  tags: ("Typst", "Python", "PDF", "ATS", "AI Workflow", "Template"),
)

#project-entry(
  [Nexus Mods Community],
  [Game Mod Developer],
  [Cyberpunk 2077 gameplay and environment enhancements],
  [Jun 2023 - Present],
  body: [Developed C++/Redscript mods for Cyberpunk 2077, collaborating with developers to optimize performance and enhance game environments.],
  tags: ("C++", "Redscript", "Lua"),
)

#project-entry(
  [Leo Club of University of Colombo],
  [Web Administrator],
  [Club website and newsletter platform],
  [Mar 2023 - Nov 2023],
  body: [Built and maintained club website with newsletter system, increasing member engagement and boosting event participation by 30%.],
  tags: ("PHP", "Firebase"),
)
