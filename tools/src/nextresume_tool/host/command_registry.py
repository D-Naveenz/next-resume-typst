from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class CommandSpec:
    key: str
    label: str
    description: str


COMMAND_SPECS = [
    CommandSpec("build-cv", "Build CV", "Compile and post-process the final CV PDF."),
    CommandSpec("build-letter", "Build Letter", "Compile the cover letter PDF."),
    CommandSpec("build-all", "Build All", "Build both CV and letter."),
    CommandSpec("watch-cv", "Watch CV", "Watch sources and rebuild the CV."),
    CommandSpec("watch-letter", "Watch Letter", "Watch sources and rebuild the letter."),
    CommandSpec("watch-all", "Watch All", "Watch sources and rebuild both documents."),
    CommandSpec("footer-generate", "Generate Footer Assets", "Regenerate footer SVG assets from metadata."),
    CommandSpec("doctor", "Doctor", "Check the tooling environment."),
    CommandSpec("clean", "Clean Tooling", "Remove transient files under .tooling."),
    CommandSpec("clean-all", "Clean All Tooling", "Clear all files under .tooling."),
]

