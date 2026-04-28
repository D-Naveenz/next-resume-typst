// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section
#import "../components/entries.typ": cv-entry


#cv-section("Projects & Associations")

#cv-entry(
  title: [Lead Developer (Backend & Unity) & System Architect],
  society: [DineEase | Customer Experience Optimizer and Sales Management System],
  date: [Nov 2023 - May 2024],
  location: [Repository: 1000-Faces #linebreak() Deployment: Azure VM],
  description: list(
    [Built full-stack restaurant management system with AR menu visualization for 15+ establishments.],
    [Achieved 99.9% system uptime, 40% increased engagement, and 50% faster order processing.],
  ),
  tags: ("C# (ASP .NET)", "Unity", "Blender", "ARCore", "Three.js", "WebGL", "Vue.js", "MS SQL Server"),
)

#cv-entry(
  title: [Modular .NET Application Framework],
  society: [Rheo],
  date: [Oct 2025 - Present],
  location: [Repository: Rheo #linebreak() Deployment: NuGet Package],
  description: list(
    [Architected multi-module C\# library reducing development time for .NET applications by 40%.],
    [Developed cross-platform storage library and specialized generic host layer for WinUI and console apps.],
  ),
  tags: ("C# (.NET 9)", "Microsoft Generic Host", "NuGet", "Async/Await Patterns"),
)

#cv-entry(
  title: [Professional LaTeX Resume Template],
  society: [NextResume],
  date: [Jan 2025 - Present],
  location: [Repository: NextResume #linebreak() Deployment: GitHub],
  description: list(
    [Created ATS-friendly LaTeX resume class with Lua-powered dynamic content generation.],
    [Designed modular architecture with SVG icons and professional typography systems.],
  ),
  tags: ("LaTeX", "Lua", "TikZ", "PowerShell Automation"),
)

#pagebreak()

#cv-entry(
  title: [Game Mod Developer],
  society: [Nexus Mods Community],
  date: [Jun 2023 - Present],
  location: [],
  description: [Developed C++/Redscript mods for Cyberpunk 2077, collaborating with developers to optimize performance and enhance game environments.],
  tags: ("C++", "Redscript", "Lua"),
)

#cv-entry(
  title: [Web Administrator],
  society: [Leo Club of University of Colombo],
  date: [Mar 2023 - Nov 2023],
  location: [],
  description: [Built and maintained club website with newsletter system, increasing member engagement and boosting event participation by 30%.],
  tags: ("PHP", "Firebase"),
)
