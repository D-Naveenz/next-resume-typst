// Imports
#import "@preview/brilliant-cv:3.3.0": h-bar
#import "../components/section.typ": cv-section
#import "../components/skills.typ": cv-skill, cv-skill-tags


#cv-section(
  "Skills",
  layout-key: "skills",
  body: (
    cv-skill(
      type: [Languages],
      info: [English (Native) #h-bar() French (Fluent) #h-bar() Chinese (Conversational)],
    ),
    cv-skill(
      type: [Programming],
      info: [Python #h-bar() SQL #h-bar() R],
    ),
    cv-skill(
      type: [Tech Stack],
      info: [Tableau #h-bar() Snowflake #h-bar() AWS #h-bar() Docker #h-bar() Git],
    ),
    cv-skill(
      type: [Frameworks & Libraries],
      info: [Pandas #h-bar() NumPy #h-bar() Scikit-learn #h-bar() TensorFlow #h-bar() FastAPI],
    ),
    cv-skill-tags(
      type: [Certifications],
      tags: (
        "AWS Certified",
        "Google Analytics",
        "Tableau Desktop",
        "Scrum Master",
      ),
    ),
    cv-skill(
      type: [Personal Interests],
      info: [Swimming #h-bar() Cooking #h-bar() Reading #h-bar() Photography],
    ),
  ),
)
