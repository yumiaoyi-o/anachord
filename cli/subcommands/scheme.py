import json
from argparse import Namespace

from anachord.utils.scheme import (
    get_scheme,
    get_scheme_modes,
)
from anachord.utils.theme import apply_colours


class Set:
    args: Namespace

    def __init__(self, args: Namespace) -> None:
        self.args = args

    def run(self) -> None:
        scheme = get_scheme()

        if self.args.notify:
            scheme.notify = True

        if self.args.random:
            scheme.set_random()
            apply_colours(scheme.colours, scheme.mode)
        elif self.args.mode:
            if self.args.mode:
                scheme.mode = self.args.mode
            apply_colours(scheme.colours, scheme.mode)
        else:
            print("No args given. Use --mode or --random to set dynamic colours")


class Get:
    args: Namespace

    def __init__(self, args: Namespace) -> None:
        self.args = args

    def run(self) -> None:
        scheme = get_scheme()

        if self.args.mode:
            if self.args.mode:
                print(scheme.mode)
        else:
            print(scheme)


class List:
    args: Namespace

    def __init__(self, args: Namespace) -> None:
        self.args = args

    def run(self) -> None:
        modes = get_scheme_modes()
        if self.args.modes:
            print("\n".join(modes))
        else:
            print(json.dumps({"modes": modes}))
