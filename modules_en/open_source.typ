// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section
#import "../components/entries.typ": cv-entry


#pagebreak()

#cv-section("Open Source Contributions")

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
