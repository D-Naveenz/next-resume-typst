// Imports
#import "@preview/brilliant-cv:3.3.0": cv-publication
#import "../components/section.typ": cv-section


#cv-section(
  "Publications",
  body: (
    cv-publication(
      bib: bibliography("../assets/publications.bib"),
      key-list: (
        "smith2020",
        "jones2021",
        "wilson2022",
      ),
      ref-style: "ieee",
      ref-full: false,
    ),
  ),
)

// Example: All publications with APA style (commented out to avoid duplication)
// #cv-publication(
//   bib: bibliography("../assets/publications.bib"),
//   ref-style: "apa",
//   ref-full: true,
// )
