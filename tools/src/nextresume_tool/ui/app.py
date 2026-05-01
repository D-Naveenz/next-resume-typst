from __future__ import annotations

import subprocess
import sys
from pathlib import Path

from textual import work
from textual.app import App, ComposeResult
from textual.containers import Horizontal, Vertical
from textual.widgets import Button, Footer, Header, Input, Label, RichLog, Select, Static

from nextresume_tool.host.command_registry import COMMAND_SPECS


COMMAND_CHOICES = [(spec.label, spec.key) for spec in COMMAND_SPECS]


class NextResumeTui(App[None]):
    TITLE = "NextResume Tools"
    CSS = """
    Screen {
      layout: vertical;
    }
    #body {
      height: 1fr;
    }
    #controls {
      width: 42;
      min-width: 42;
      border: round $surface;
      padding: 1;
    }
    #log-pane {
      border: round $surface;
      padding: 1;
    }
    #log {
      height: 1fr;
    }
    Button {
      width: 100%;
      margin-top: 1;
    }
    """

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        with Horizontal(id="body"):
            with Vertical(id="controls"):
                yield Static("NextResume Tools", classes="title")
                yield Label("Command")
                yield Select(COMMAND_CHOICES, value="build-cv", id="command")
                yield Label("Language")
                yield Input(value="en", placeholder="en", id="language")
                yield Label("Output (optional)")
                yield Input(placeholder="cv.pdf or letter.pdf", id="output")
                yield Button("Run Command", variant="primary", id="run")
                yield Button("Quit", id="quit")
            with Vertical(id="log-pane"):
                yield Label("Execution Log")
                yield RichLog(id="log", auto_scroll=True, wrap=True, highlight=True)
        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "quit":
            self.exit()
            return
        if event.button.id == "run":
            self.run_selected_command()

    @work(thread=True)
    def run_selected_command(self) -> None:
        command = self.query_one("#command", Select).value or "build-cv"
        language = self.query_one("#language", Input).value.strip()
        output = self.query_one("#output", Input).value.strip()
        args = self._build_args(str(command), language, output)
        log = self.query_one("#log", RichLog)
        log.write(f"$ {' '.join(args)}")

        completed = subprocess.run(
            args,
            cwd=Path(__file__).resolve().parents[4],
            text=True,
            capture_output=True,
            check=False,
        )
        if completed.stdout:
            log.write(completed.stdout.rstrip())
        if completed.stderr:
            log.write(completed.stderr.rstrip())
        log.write(f"Exit code: {completed.returncode}")

    def _build_args(self, command: str, language: str, output: str) -> list[str]:
        args = [sys.executable, "-m", "nextresume_tool"]
        if command == "build-cv":
            args.extend(["build", "cv", "--language", language or "en"])
            if output:
                args.extend(["--output", output])
        elif command == "build-letter":
            args.extend(["build", "letter", "--language", language or "en"])
            if output:
                args.extend(["--output", output])
        elif command == "build-all":
            args.extend(["build", "all", "--language", language or "en"])
        elif command == "watch-cv":
            args.extend(["watch", "cv", "--language", language or "en"])
        elif command == "watch-letter":
            args.extend(["watch", "letter", "--language", language or "en"])
        elif command == "watch-all":
            args.extend(["watch", "all", "--language", language or "en"])
        elif command == "footer-generate":
            args.extend(["footer", "generate"])
        elif command == "doctor":
            args.extend(["doctor"])
        elif command == "clean-all":
            args.extend(["clean", "--all"])
        else:
            args.extend(["clean"])
        return args
