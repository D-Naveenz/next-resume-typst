// Imports
#import "@preview/brilliant-cv:3.3.0": cv-section, h-bar
#import "../components/skills.typ": cv-skill, cv-skill-tags


#cv-section("Skills")

#cv-skill(
  type: [Languages],
  info: [English (Native) #h-bar() French (Fluent) #h-bar() Chinese (Conversational)],
)

#cv-skill(
  type: [Programming],
  info: [Python #h-bar() SQL #h-bar() R],
)

#cv-skill(
  type: [Tech Stack],
  info: [Tableau #h-bar() Snowflake #h-bar() AWS #h-bar() Docker #h-bar() Git],
)

#cv-skill(
  type: [Frameworks & Libraries],
  info: [Pandas #h-bar() NumPy #h-bar() Scikit-learn #h-bar() TensorFlow #h-bar() FastAPI],
)

#cv-skill-tags(
  type: [Certifications],
  tags: (
    [AWS Certified],
    [Google Analytics],
    [Tableau Desktop],
    [Scrum Master],
  ),
)

#cv-skill(
  type: [Personal Interests],
  info: [Swimming #h-bar() Cooking #h-bar() Reading #h-bar() Photography],
)
