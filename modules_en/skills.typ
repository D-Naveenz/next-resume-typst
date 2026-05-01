// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section, h-bar
#import "../components/skills.typ": cv-skill


#cv-section("Skills")

#cv-skill(
  type: [Languages],
  info: [C\# #h-bar() Rust #h-bar() Python #h-bar() JavaScript/TypeScript #h-bar() Lua],
)

#cv-skill(
  type: [Frameworks & APIs],
  info: [.NET #h-bar() ASP.NET #h-bar() .NET 10 #h-bar() Next.js #h-bar() React #h-bar() Razor Pages #h-bar() WinUI 3 #h-bar() Entity Framework #h-bar() REST #h-bar() Crystal Reports],
)

#cv-skill(
  type: [Industrial & IoT],
  info: [Modbus #h-bar() BACnet #h-bar() Resource Monitoring #h-bar() Device Networks],
)

#cv-skill(
  type: [Data & Storage],
  info: [SQL Server #h-bar() DHBIN #h-bar() MessagePack #h-bar() Protobuf #h-bar() SQLite #h-bar() Firebase],
)

#cv-skill(
  type: [Tools & Operations],
  info: [OpenAI Codex #h-bar() Obsidian #h-bar() GitHub Actions #h-bar() Docker #h-bar() Azure DevOps #h-bar() SAP #h-bar() Reporting #h-bar() Audits #h-bar() Process Coordination],
)
