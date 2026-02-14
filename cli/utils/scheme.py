import json
import random
from pathlib import Path

from anachord.utils.notify import notify
from anachord.utils.paths import atomic_dump, scheme_path


class Scheme:
    _mode: str
    _colours: dict[str, str]
    notify: bool

    def __init__(self, json: dict[str, any] | None) -> None:
        data = json or {}
        mode = data.get("mode", "dark")
        self._mode = mode if mode in get_scheme_modes() else "dark"
        self._colours = data.get("colours", {})
        self.notify = False

    @property
    def mode(self) -> str:
        return self._mode

    @mode.setter
    def mode(self, mode: str) -> None:
        if mode == self._mode:
            return

        if mode not in get_scheme_modes():
            if self.notify:
                notify(
                    "-u",
                    "critical",
                    "Unable to set scheme mode",
                    f'"{mode}" is not a valid mode. Valid modes are: {get_scheme_modes()}',
                )
            raise ValueError(f'Invalid scheme mode: "{mode}". Valid modes: {get_scheme_modes()}')

        self._mode = mode
        self.update_colours()

    @property
    def colours(self) -> dict[str, str]:
        return self._colours

    def save(self) -> None:
        scheme_path.parent.mkdir(parents=True, exist_ok=True)
        atomic_dump(
            scheme_path,
            {
                "mode": self.mode,
                "colours": self.colours,
            },
        )

    def set_random(self) -> None:
        self._mode = random.choice(get_scheme_modes())
        self.update_colours()

    def update_colours(self) -> None:
        self._update_colours()
        self.save()

    def _update_colours(self) -> None:
        from anachord.utils.material import get_colours_for_image

        try:
            self._colours = get_colours_for_image(scheme=self)
        except FileNotFoundError:
            if self.notify:
                notify(
                    "-u",
                    "critical",
                    "Unable to update dynamic colors",
                    "No wallpaper set. Please set a wallpaper via `anachord wallpaper` first.",
                )
            raise ValueError("No wallpaper set. Please set a wallpaper via `anachord wallpaper` first.")

    def __str__(self) -> str:
        return (
            f"Current dynamic colors:\n"
            f"    Mode: {self.mode}\n"
            f"    Colours:\n"
            f"        {'\n        '.join(f'{n}: \x1b[38;2;{int(c[0:2], 16)};{int(c[2:4], 16)};{int(c[4:6], 16)}m{c}\x1b[0m' for n, c in self.colours.items())}"
        )

scheme: Scheme = None


def get_scheme() -> Scheme:
    global scheme

    if scheme is None:
        try:
            scheme_json = json.loads(scheme_path.read_text())
            scheme = Scheme(scheme_json)
        except (IOError, json.JSONDecodeError, KeyError):
            scheme = Scheme(None)
            try:
                scheme.update_colours()
            except ValueError:
                scheme.save()

        if not scheme.colours:
            try:
                scheme.update_colours()
            except ValueError:
                pass

    return scheme


def get_scheme_modes() -> list[str]:
    return ["light", "dark"]
