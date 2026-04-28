// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section
#import "../components/entries.typ": cv-entry


#cv-section("Professional Experience")

#cv-entry(
  title: [Backend Developer - Intern],
  society: [App 360],
  logo: image("../assets/logos/app360.jpg"),
  date: [Jun 2024 - Dec 2024],
  location: [Melbourne, Australia (Remote)],
  description: list(
    [Engineered automated reporting system reducing manual effort by 80% and accelerating query execution by 50%.],
    [Optimized database architecture achieving 25% faster query performance and enhanced data integrity.],
    [Enhanced POS360 API security with JWT authentication and integrated Firebase real-time messaging.],
  ),
  tags: ("C# (ASP .NET)", "ADO.NET", "MS SQL Server", "Firebase", "JWT", "Swagger"),
)

#cv-entry(
  title: [Software Engineer - Intern],
  society: [SimCentric Technologies],
  logo: image("../assets/logos/simcentric.png"),
  date: [Nov 2023 - May 2024],
  location: [Colombo 9],
  description: list(
    [Architected legacy system migration to WinUI 3, improving application scalability and performance.],
    [Developed integrated add-on store with user profiles, increasing platform usage by 25%.],
    [Built SQLite data processing engine with Entity Framework and modernized UI components.],
  ),
  tags: ("C#", "WinUI 3", "XAML", "Entity Framework", "SQLite", "Microsoft Community Toolkit"),
)
