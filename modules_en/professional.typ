// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section
#import "../components/entry.typ": cv-entry


#cv-section("Professional Experience")

#cv-entry(
  title: [Associate Software Engineer],
  society: [AFISOL (Pvt.) Ltd.],
  logo: image("../assets/logos/afisol.png"),
  date: [Feb 2026 - Present],
  location: [Kottawa],
  description: list(
    [Delivered production systems across PMS, HRMS, CMMS, and resource-monitoring products after starting in R&D.],
    [Built an employee task monitoring system with workspace and Kanban-style workflows, then integrated it into the PMS.],
    [Created HRMS attendance review flows and Crystal Reports outputs using fingerprint validation, working-hour calculation, and modern UI work.],
    [Took ownership of a Modbus/BACnet resource-monitoring system for high-volume device networks, later folded into the modern CMMS platform.],
    [Use a hybrid manual and AI-assisted development workflow with OpenAI Codex and Obsidian-backed technical notes to accelerate production delivery.],
  ),
  tags: ("Next.js", "React", "C#", "ASP.NET", ".NET 10", "Razor Pages", "Python", "SQL Server", "Crystal Reports", "Protobuf", "Modbus", "BACnet", "OpenAI Codex"),
)

#cv-entry(
  title: [Store Administrator (Supervisor)],
  society: [Keells - Jaykay Marketing Services (Pvt) Ltd.],
  logo: image("../assets/logos/keells.png"),
  date: [Feb 2025 - Dec 2025],
  location: [Kirillawala],
  description: list(
    [Maintained audit-ready inventory, vendor invoice, delivery note, and stock movement records for branch operations.],
    [Prepared operational reports and coordinated replenishment workflows with store management, finance, procurement, and supply-chain teams.],
    [Built practical business operations judgment that strengthened later engineering work on ERP-style HRMS, PMS, and CMMS systems.],
  ),
  tags: ("Retail Operations", "Inventory Control", "SAP", "Microsoft Office", "Reporting", "Audits", "Process Coordination"),
)

#cv-entry(
  title: [Backend Developer Intern],
  society: [App 360],
  logo: image("../assets/logos/app360.jpg"),
  date: [Jun 2024 - Dec 2024],
  location: [Melbourne, Australia (Remote)],
  description: list(
    [Engineered automated reporting system reducing manual effort by 80% and accelerating query execution by 50%.],
    [Enhanced POS360 API security with JWT authentication and integrated Firebase real-time messaging.],
  ),
  tags: ("C# (ASP .NET)", "ADO.NET", "MS SQL Server", "Firebase", "JWT", "Swagger"),
)

#cv-entry(
  title: [Software Engineer Intern],
  society: [SimCentric Technologies],
  logo: image("../assets/logos/simcentric.png"),
  date: [Nov 2023 - May 2024],
  location: [Colombo 9],
  description: list(
    [Architected legacy system migration to WinUI 3, improving application scalability and performance.],
    [Built SQLite data processing engine with Entity Framework and modernized UI components.],
  ),
  tags: ("C#", "WinUI 3", "XAML", "Entity Framework", "SQLite", "Microsoft Community Toolkit"),
)
