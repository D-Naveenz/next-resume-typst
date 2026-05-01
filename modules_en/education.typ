// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section, h-bar
#import "../components/entry.typ": cv-entry


#cv-section("Education")

#cv-entry(
  title: [Computer Science | B.Sc.],
  society: [University of Colombo School of Computing],
  logo: image("../assets/logos/ucsc.png"),
  date: [May 2022 - Aug 2025],
  location: [Colombo 7],
  description: list(
    [Relevant Courses: Software Engineering #h-bar() DSA #h-bar() OOP #h-bar() Rapid Application Development #h-bar() Databases #h-bar() Human Computer Interaction #h-bar() Middleware Architecture],
  ),
)

#cv-entry(
  title: [Mathematics | GCE A/L],
  society: [Royal College],
  logo: image("../assets/logos/royal_college.png"),
  date: [Apr 2015 - Aug 2019],
  location: [Colombo 7],
  description: list(
    [Results: ABC],
  ),
)
