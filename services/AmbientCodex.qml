pragma Singleton

import qs.utils
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string basePath: `${Paths.home}/.codex/ambient`
    readonly property string runnerPath: `${basePath}/bin/ambient.py`
    readonly property string statePath: `${basePath}/state.json`
    readonly property string cardsPath: `${basePath}/cards.json`
    readonly property string dashboardPath: `${basePath}/dashboard.md`

    property var state: ({})
    property var cardsDoc: ({})
    property bool stateLoaded: false
    property bool cardsLoaded: false
    property string error: ""
    property string lastRunOutput: ""
    property string lastRunError: ""

    readonly property bool loaded: stateLoaded && cardsLoaded
    readonly property bool runningScan: runScanProc.running
    readonly property var latestRun: state.latest_run ?? ({})
    readonly property var recentRuns: state.recent_runs ?? []
    readonly property var agents: state.agents ?? []
    readonly property var usageLatest: state.usage_latest ?? ({})
    readonly property var readinessLatest: state.readiness_latest ?? ({})
    readonly property var idleStatus: state.idle_status ?? ({})
    readonly property var cardCounts: state.card_counts ?? ({})
    readonly property var cards: cardsDoc.cards ?? []
    readonly property var recentCards: cardsDoc.recent_cards ?? []

    function reload(): void {
        stateFile.reload();
        cardsFile.reload();
    }

    function runScan(): void {
        if (runScanProc.running)
            return;

        lastRunOutput = "";
        lastRunError = "";
        runScanProc.running = true;
    }

    function resolvePath(path: string): string {
        if (!path)
            return "";
        if (path.startsWith("/"))
            return path;
        if (path.startsWith("~"))
            return path.replace("~", Paths.home);
        return `${Paths.home}/${path}`;
    }

    function openPath(path: string): void {
        const resolved = resolvePath(path);
        if (resolved)
            Quickshell.execDetached(["xdg-open", resolved]);
    }

    function openDashboard(): void {
        openPath(latestRun.report_path || dashboardPath);
    }

    function modeText(mode: var): string {
        switch (mode) {
        case "ready":
            return qsTr("可工作");
        case "local-only":
            return qsTr("仅本地");
        case "paused":
            return qsTr("暂停");
        default:
            return mode ? String(mode) : qsTr("未知");
        }
    }

    function statusText(status: var): string {
        switch (status) {
        case "complete":
            return qsTr("完成");
        case "running":
            return qsTr("运行中");
        case "idle":
            return qsTr("空闲");
        case "open":
            return qsTr("待处理");
        case "archived":
            return qsTr("已归档");
        default:
            return status ? String(status) : qsTr("缺失");
        }
    }

    function permissionText(permission: var): string {
        switch (permission) {
        case "Observe":
            return qsTr("观察");
        case "Prepare":
            return qsTr("准备");
        case "LocalEdit":
            return qsTr("本地编辑");
        case "GitPush":
            return qsTr("Git 推送");
        case "SystemChange":
            return qsTr("系统更改");
        case "ExternalAction":
            return qsTr("外部动作");
        case "SecretDenied":
            return qsTr("凭据禁区");
        default:
            return permission ? String(permission) : qsTr("观察");
        }
    }

    function agentText(agent: var): string {
        switch (agent) {
        case "orchestrator":
            return qsTr("主控");
        case "system-safety":
            return qsTr("安全/系统");
        case "capability-scout":
            return qsTr("能力侦察");
        case "research-code":
            return qsTr("项目扫描");
        default:
            return agent ? String(agent) : qsTr("协作者");
        }
    }

    function runModeText(mode: var): string {
        if (!mode)
            return qsTr("手动 v0.3");
        if (String(mode).startsWith("manual-"))
            return qsTr("手动 %1").arg(String(mode).replace("manual-", ""));
        if (String(mode).startsWith("idle-"))
            return qsTr("空闲 %1").arg(String(mode).replace("idle-", ""));
        if (String(mode).startsWith("morning-"))
            return qsTr("晨间 %1").arg(String(mode).replace("morning-", ""));
        return String(mode);
    }

    function boolText(value: var): string {
        if (value === null || value === undefined)
            return qsTr("未知");
        return value ? qsTr("是") : qsTr("否");
    }

    function idleSummary(idle: var): string {
        if (!idle || Object.keys(idle).length === 0)
            return qsTr("未启动");

        const enabled = idle.enabled ? qsTr("已启用") : qsTr("未启用");
        const running = idle.running ? qsTr("运行中") : qsTr("未运行");
        const seconds = Number(idle.idle_seconds ?? 0);
        const threshold = Number(idle.idle_threshold_seconds ?? 0);
        if (threshold > 0)
            return qsTr("%1，%2，空闲 %3/%4 分").arg(enabled).arg(running).arg(Math.floor(seconds / 60)).arg(Math.floor(threshold / 60));
        return qsTr("%1，%2").arg(enabled).arg(running);
    }

    function shortId(value: var): string {
        if (!value)
            return "";

        const text = String(value);
        return text.length > 15 ? `${text.slice(0, 12)}...` : text;
    }

    function formatTime(value: var): string {
        if (!value)
            return qsTr("从未");

        const date = new Date(value);
        if (isNaN(date.getTime()))
            return String(value);

        return Qt.formatDateTime(date, "MM-dd hh:mm");
    }

    function percentText(value: var): string {
        if (value === null || value === undefined || value === "")
            return "--";
        return `${Number(value).toFixed(1)}%`;
    }

    function parseState(text: string): void {
        try {
            state = JSON.parse(text || "{}");
            stateLoaded = true;
            error = "";
        } catch (e) {
            error = `state.json: ${e.message}`;
            stateLoaded = false;
        }
    }

    function parseCards(text: string): void {
        try {
            cardsDoc = JSON.parse(text || "{}");
            cardsLoaded = true;
            error = "";
        } catch (e) {
            error = `cards.json: ${e.message}`;
            cardsLoaded = false;
        }
    }

    FileView {
        id: stateFile

        path: root.statePath
        watchChanges: true

        onLoaded: root.parseState(text())
        onFileChanged: reload()
        onLoadFailed: err => {
            root.stateLoaded = false;
            root.error = `state.json: ${FileViewError.toString(err)}`;
        }
    }

    FileView {
        id: cardsFile

        path: root.cardsPath
        watchChanges: true

        onLoaded: root.parseCards(text())
        onFileChanged: reload()
        onLoadFailed: err => {
            root.cardsLoaded = false;
            root.error = `cards.json: ${FileViewError.toString(err)}`;
        }
    }

    Process {
        id: runScanProc

        command: ["env", "PYTHONDONTWRITEBYTECODE=1", "python", root.runnerPath, "run"]
        stdout: StdioCollector {
            onStreamFinished: root.lastRunOutput = text.trim()
        }
        stderr: StdioCollector {
            onStreamFinished: root.lastRunError = text.trim()
        }
        onExited: root.reload()
    }
}
