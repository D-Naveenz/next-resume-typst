// Imports
#import "@preview/brilliant-cv:3.3.0": cv-metadata
#import "../components/metadata.typ": metadata-or-default
#import "../components/section.typ": cv-section, cv-section-end


#let certificate-row(
  date: [],
  title: [],
  issuer: [],
  url: none,
  location: [],
) = context {
  let metadata = metadata-or-default(cv-metadata.get())
  let certificates-layout = metadata.layout.at("certificates", default: (:))
  let after-row-skip = eval(certificates-layout.at("after_row_skip", default: "0pt"))
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
  v(after-row-skip)
}


#cv-section("Certificates & Awards", layout-key: "certificates")

#certificate-row(
  date: [2024],
  title: [Complete C\# Masterclass],
  issuer: [Udemy],
  url: "https://www.udemy.com/certificate/UC-b30aa30e-9a93-44f2-9d09-67db198cf65b/",
  location: [Online],
)

#certificate-row(
  date: [2024],
  title: [Data Engineering Essentials using SQL, Python, and PySpark],
  issuer: [Udemy],
  url: "https://www.udemy.com/certificate/UC-bb6282fa-42ef-4ebc-8a32-9215b8537764/",
  location: [Online],
)

#certificate-row(
  date: [2024],
  title: [DevOps Foundations],
  issuer: [LinkedIn Learning],
  url: "https://www.linkedin.com/learning/certificates/3f4908fdc852ebac8fc8351e6e1048d608eff3930c8829c3749a92bf68b92613",
  location: [Online],
)

#cv-section-end(layout-key: "certificates")
