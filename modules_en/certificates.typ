// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section


#let certificate-row(
  date: [],
  title: [],
  issuer: [],
  url: none,
  location: [],
) = {
  let title-text = text(weight: "bold", if url == none { title } else { link(url)[#title] })
  let issuer-text = if issuer == [] { [] } else { [, #issuer] }
  let left-columns = if date == [] { (1fr,) } else { (3.2em, 1fr) }
  let left-cells = if date == [] {
    (
      [#title-text#issuer-text],
    )
  } else {
    (
      align(right, date),
      [#title-text#issuer-text],
    )
  }

  table(
    columns: left-columns + (8.5em,),
    inset: 0pt,
    column-gutter: 8pt,
    align: horizon,
    stroke: none,
    ..left-cells,
    align(right, text(weight: "medium", fill: rgb("#00A0DD"), style: "oblique", location)),
  )
  v(-4pt)
}


#cv-section("Certificates & Awards")

#certificate-row(
  date: [2022],
  title: [AWS Certified Security - Specialty],
  issuer: [Amazon Web Services (AWS)],
  url: "https://aws.amazon.com/certification/",
  location: [Online],
)

#certificate-row(
  date: [2021],
  title: [Data Science Excellence Award],
  issuer: [XYZ Corporation],
  location: [San Francisco, CA],
)

#certificate-row(
  date: [2020],
  title: [Applied Data Science with Python Specialization],
  issuer: [University of Michigan via Coursera],
  url: "https://coursera.org/specializations/data-science-python",
  location: [Online],
)

#certificate-row(
  date: [2019],
  title: [Tableau Desktop Certified Professional],
  issuer: [Tableau Software],
  url: "https://www.tableau.com/learn/certification",
  location: [Online],
)

#certificate-row(
  date: [2018],
  title: [SQL Fundamentals Track],
  issuer: [DataCamp],
  location: [Online],
)
