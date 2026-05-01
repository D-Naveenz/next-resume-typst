// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section
#import "../components/info-link.typ": info-link, project-link
#import "../components/project-entry.typ": project-entry


#cv-section("Projects & Associations")

#project-entry(
  [DineEase],
  [Lead Developer (Backend & Unity) & System Architect],
  [Customer experience optimizer and sales management system],
  [Nov 2023 - May 2024],
  links: (
    project-link(
      "Repository",
      [1000-Faces],
      "https://github.com/1000-Faces",
    ),
    info-link(
      "Deployment",
      [Azure VM],
      semantic: false,
    ),
  ),
  body: list(
    [Built full-stack restaurant management system with AR menu visualization for 15+ establishments.],
    [Achieved 99.9% system uptime, 40% increased engagement, and 50% faster order processing.],
  ),
  tags: ("C# (ASP .NET)", "Unity", "Blender", "ARCore", "Three.js", "WebGL", "Vue.js", "MS SQL Server"),
)

#project-entry(
  [Rheo],
  [Architect & Maintainer],
  [Modular .NET Application Framework],
  [Oct 2025 - Present],
  links: (
    project-link(
      "Repository",
      [Rheo],
      "https://github.com/D-Naveenz/Rheo",
    ),
    info-link(
      "Deployment",
      [NuGet Package],
      semantic: false,
    ),
  ),
  body: list(
    [Architected multi-module C\# library reducing development time for .NET applications by 40%.],
    [Developed cross-platform storage library and specialized generic host layer for WinUI and console apps.],
  ),
  tags: ("C# (.NET 9)", "Microsoft Generic Host", "NuGet", "Async/Await Patterns"),
)

#project-entry(
  [NextResume],
  [Creator & Maintainer],
  [Typst CV/Resume template],
  [Jan 2025 - Present],
  links: (
    project-link(
      "Repository",
      [NextResume],
      "https://github.com/D-Naveenz/next-resume-typst",
    ),
    info-link(
      "Deployment",
      [GitHub],
      semantic: false,
    ),
  ),
  body: list(
    [Built a Typst resume template that balances visual polish with copy-friendly ATS extraction.],
    [Added modular project headers, semantic link handling, and artifact-based footer rendering.],
    [Modernized the brilliant-CV foundation while preserving its compact professional layout.],
  ),
  tags: ("Typst", "PDF", "ATS", "Template"),
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
