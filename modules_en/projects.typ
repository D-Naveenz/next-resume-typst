// Imports
#import "../components/info-link.typ": project-link
#import "../components/project-entry.typ": project-entry
#import "../components/section.typ": cv-section


#cv-section(
  "Projects & Associations",
  body: (
    project-entry(
      [NextResume],
      [Maintainer],
      [Typst CV/Resume template],
      [2025 - Present],
      links: (
        project-link(
          "Repository",
          [next-resume-typst],
          "https://github.com/D-Naveenz/next-resume-typst",
        ),
        project-link(
          "Deployment",
          [Crates],
          "https://crates.io/crates/dhara_storage",
        ),
      ),
      body: list(
        [Built a Typst resume template that balances visual polish with copy-friendly ATS extraction],
        [Added modular project headers, semantic link handling, and artifact-based footer rendering],
        [Modernized the brilliant-CV foundation while preserving its compact professional layout],
      ),
      tags: ("Typst", "PDF", "ATS", "Template"),
    ),
    project-entry(
      [Python Data Science Libraries],
      [Open Source Contributor],
      [Community-maintained analysis and visualization tooling],
      [2018 - Present],
      links: (
        project-link(
          "Repository",
          [pandas],
          "https://github.com/pandas-dev/pandas",
        ),
      ),
      body: list(
        [Contributed to pandas, scikit-learn, and matplotlib projects],
        [Fixed bugs, improved documentation, and added new features],
        [Mentored new contributors during Google Summer of Code],
      ),
      tags: ("Open Source", "Python", "Community"),
    ),
    project-entry(
      [Time Series Forecasting],
      [Research Developer],
      [Transformer-based machine learning research project],
      [Summer 2020],
      links: (
        project-link(
          "Repository",
          [forecasting-lab],
          "https://github.com/johndoe/forecasting-lab",
        ),
      ),
      body: list(
        [Developed a novel approach to time series forecasting using transformer architectures],
        [Published research paper and open-sourced implementation on GitHub],
        [Achieved 15% improvement over baseline models on benchmark datasets],
      ),
      tags: ("Research", "Deep Learning", "Time Series"),
    ),
  ),
)
