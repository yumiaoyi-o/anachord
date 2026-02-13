import subprocess


def notify(*args: list[str]) -> str:
    try:
        result = subprocess.run(
            ["notify-send", "-a", "anachord-cli", *args],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            timeout=2,
            check=False,
        )
        return (result.stdout or "").strip()
    except subprocess.TimeoutExpired:
        return ""


def close_notification(id: str) -> None:
    subprocess.run(
        [
            "gdbus",
            "call",
            "--session",
            "--dest=org.freedesktop.Notifications",
            "--object-path=/org/freedesktop/Notifications",
            "--method=org.freedesktop.Notifications.CloseNotification",
            id,
        ],
        stdout=subprocess.DEVNULL,
    )
