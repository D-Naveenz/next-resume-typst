// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section, h-bar
#import "../components/skills.typ": cv-skill


#cv-section("Skills")

#cv-skill(
  type: [Cloud],
  info: [Azure VM #h-bar() Azure DevOps #h-bar() Azure Cosmos DB #h-bar() GCP BigQuery #h-bar() GCP Dataproc #h-bar() Databricks],
)

#cv-skill(
  type: [Languages],
  info: [C\# #h-bar() Python #h-bar() JavaScript/TypeScript #h-bar() Lua],
)

#cv-skill(
  type: [Frameworks & APIs],
  info: [.NET Core #h-bar() Entity Framework #h-bar() WinUI 3 #h-bar() WinAppSDK #h-bar() Node.js #h-bar() Vue.js #h-bar() Angular #h-bar() REST #h-bar() Apache Spark #h-bar() Pandas],
)

#cv-skill(
  type: [Databases],
  info: [MS SQL Server #h-bar() MySQL #h-bar() Firebase #h-bar() SQLite],
)

#cv-skill(
  type: [DevOps & Tools],
  info: [GitHub Actions #h-bar() Docker #h-bar() Azure DevOps #h-bar() Git #h-bar() Bitbucket #h-bar() Swagger],
)
