// Imports
#import "../components/entry.typ": cv-entry
#import "../components/section.typ": cv-section


#cv-section(
  "Professional Experience",
  body: (
    cv-entry(
      title: [Director of Data Science],
      society: [XYZ Corporation],
      logo: image("../assets/logos/xyz_corp.png"),
      date: [Date],
      location: [San Francisco, CA],
      description: list(
        [Lead a team of data scientists and analysts to develop and implement data-driven strategies, develop predictive models and algorithms to support decision-making across the organization],
        [Collaborate with executive leadership to identify business opportunities and drive growth, implement best practices for data governance, quality, and security],
      ),
      tags: ("Dataiku", "Snowflake", "SparkSQL"),
    ),
    cv-entry(
      title: [Data Scientist],
      society: [XYZ Corporation],
      logo: image("../assets/logos/xyz_corp.png"),
      date: [2017 - 2020 #linebreak() 2021 - 2022],
      location: [San Francisco, CA],
      description: list(
        [Analyze large datasets with SQL and Python, collaborate with teams to uncover business insights],
        [Create data visualizations and dashboards in Tableau, develop and maintain data pipelines with AWS],
      ),
    ),
    cv-entry(
      title: [Data Analyst],
      society: [ABC Company],
      logo: image("../assets/logos/abc_company.png"),
      date: [2017 - 2020],
      location: [New York, NY],
      description: list(
        [Analyze large datasets with SQL and Python, collaborate with teams to uncover business insights],
        [Create data visualizations and dashboards in Tableau, develop and maintain data pipelines with AWS],
      ),
    ),
    cv-entry(
      title: [Data Analysis Intern],
      society: [PQR Corporation],
      logo: image("../assets/logos/pqr_corp.png"),
      date: list(
        [Summer 2017],
        [Summer 2016],
      ),
      location: [Chicago, IL],
      description: list([Assisted with data cleaning, processing, and analysis using Python and Excel, participated in team meetings and contributed to project planning and execution]),
    ),
  ),
)
