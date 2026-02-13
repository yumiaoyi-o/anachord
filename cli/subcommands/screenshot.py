import subprocess
from argparse import Namespace
from datetime import datetime

from anachord.utils.notify import notify
from anachord.utils.paths import screenshots_dir


class Command:
    args: Namespace

    def __init__(self, args: Namespace) -> None:
        self.args = args

    def run(self) -> None:
        if self.args.region:
            self.region()
        else:
            self.fullscreen()

    def region(self) -> None:
        if self.args.region == "slurp":
            subprocess.run(
                ["qs", "-c", "Anachord", "ipc", "call", "picker", "openFreeze" if self.args.freeze else "open"]
            )
        else:
            sc_data = subprocess.check_output(["grim", "-l", "0", "-g", self.args.region.strip(), "-"])

            subprocess.run(["wl-copy"], input=sc_data)

            screenshots_dir.mkdir(exist_ok=True, parents=True)
            dest = screenshots_dir / datetime.now().strftime("screenshot_%Y%m%d_%H-%M-%S.png")
            dest.write_bytes(sc_data)

            notify(
                "-i",
                "image-x-generic-symbolic",
                "-h",
                f"STRING:image-path:{dest}",
                "--action=folder=Open folder",
                "Screenshot saved",
                f"Saved to {dest} and copied to clipboard",
            )

    def fullscreen(self) -> None:
        sc_data = subprocess.check_output(["grim", "-"])

        subprocess.run(["wl-copy"], input=sc_data)

        screenshots_dir.mkdir(exist_ok=True, parents=True)
        dest = screenshots_dir / datetime.now().strftime("screenshot_%Y%m%d_%H-%M-%S.png")
        dest.write_bytes(sc_data)

        action = notify(
            "-i",
            "image-x-generic-symbolic",
            "-h",
            f"STRING:image-path:{dest}",
            "--action=folder=Open folder",
            "Screenshot saved",
            f"Saved to {dest} and copied to clipboard",
        )

        if action == "folder":
            p = subprocess.run(
                [
                    "dbus-send",
                    "--session",
                    "--dest=org.freedesktop.FileManager1",
                    "--type=method_call",
                    "/org/freedesktop/FileManager1",
                    "org.freedesktop.FileManager1.ShowItems",
                    f"array:string:file://{dest}",
                    "string:",
                ]
            )
            if p.returncode != 0:
                subprocess.Popen(["app2unit", "-O", str(dest.parent)], start_new_session=True)
