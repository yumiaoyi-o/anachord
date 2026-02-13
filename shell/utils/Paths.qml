pragma Singleton

import qs.config
import Anachord
import Quickshell

Singleton {
    id: root

    readonly property string home: Quickshell.env("HOME")
    readonly property string pictures: Quickshell.env("XDG_PICTURES_DIR") || `${home}/Pictures`
    readonly property string videos: Quickshell.env("XDG_VIDEOS_DIR") || `${home}/Videos`

    readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${home}/.local/share`}/anachord`
    readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/anachord`
    readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/anachord`
    readonly property string config: `${Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`}/anachord`

    readonly property string imagecache: `${cache}/imagecache`
    readonly property string notifimagecache: `${imagecache}/notifs`
    readonly property string wallsdir: Quickshell.env("Anachord_WALLPAPERS_DIR") || absolutePath(Config.paths.wallpaperDir)
    readonly property string screenshotsdir: Quickshell.env("Anachord_SCREENSHOTS_DIR") || absolutePath(Config.paths.screenshotsDir)
    readonly property string recsdir: Quickshell.env("Anachord_RECORDINGS_DIR") || absolutePath(Config.paths.recordingsDir)
    readonly property string libdir: Quickshell.env("Anachord_LIB_DIR") || "/usr/lib/anachord"

    function toLocalFile(path: url): string {
        path = Qt.resolvedUrl(path);
        return path.toString() ? CUtils.toLocalFile(path) : "";
    }

    function absolutePath(path: string): string {
        return toLocalFile(path.replace(/~|(\$({?)HOME(}?))+/, home));
    }

    function shortenHome(path: string): string {
        return path.replace(home, "~");
    }
}
