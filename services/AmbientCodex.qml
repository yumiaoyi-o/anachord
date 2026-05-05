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
    readonly property string lineCardsPath: `${basePath}/line_cards.json`
    readonly property string dashboardPath: `${basePath}/dashboard.md`

    property var state: ({})
    property var cardsDoc: ({})
    property var lineCardsDoc: ({})
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
    readonly property var office: state.office ?? ({})
    readonly property var officeWorkers: office.workers ?? []
    readonly property var cards: cardsDoc.cards ?? []
    readonly property var recentCards: cardsDoc.recent_cards ?? []
    readonly property var lineCards: lineCardsDoc.cards ?? []
    readonly property bool lineEditorEnabled: !!cardsDoc.line_editor?.enabled
    readonly property var displayCards: lineEditorEnabled && lineCards.length > 0 ? lineCards : cards

    function reload(): void {
        stateFile.reload();
        cardsFile.reload();
        lineCardsFile.reload();
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
        case "automation-guardian":
            return qsTr("自动化守门");
        case "task-planner":
            return qsTr("任务规划");
        case "retention-keeper":
            return qsTr("留存清洗");
        case "campus-intel":
            return qsTr("校园情报员");
        case "github-radar":
            return qsTr("GitHub 创意侦察员");
        case "course-clerk":
            return qsTr("课程 Clerk");
        case "file-archivist":
            return qsTr("文件管理员");
        case "office-manager":
            return qsTr("Manager / 主编");
        case "research-reviewer":
            return qsTr("科研审稿员");
        case "system-steward":
            return qsTr("系统管家");
        case "life-assistant":
            return qsTr("生活 Assistant");
        case "codex-worker":
            return qsTr("Codex worker");
        default:
            return agent ? String(agent) : qsTr("协作者");
        }
    }

    function runModeText(mode: var): string {
        if (!mode)
            return qsTr("手动巡检");
        if (String(mode).startsWith("idle-office"))
            return qsTr("空闲巡航");
        if (String(mode).startsWith("manual-office"))
            return qsTr("手动巡检");
        if (String(mode).startsWith("morning-office"))
            return qsTr("晨间巡航");
        if (String(mode).startsWith("manual-"))
            return qsTr("手动 %1").arg(String(mode).replace("manual-", ""));
        if (String(mode).startsWith("idle-"))
            return qsTr("空闲 %1").arg(String(mode).replace("idle-", ""));
        if (String(mode).startsWith("morning-"))
            return qsTr("晨间 %1").arg(String(mode).replace("morning-", ""));
        return String(mode);
    }

    function workerTitle(worker: var): string {
        if (!worker)
            return qsTr("岗位");
        return worker.title || agentText(worker.worker || worker.agent);
    }

    function workerStatusText(status: var): string {
        switch (status) {
        case "active":
            return qsTr("在岗");
        case "vacant":
            return qsTr("空置");
        case "paused":
            return qsTr("暂停");
        case "blocked":
            return qsTr("阻塞");
        case "incident":
            return qsTr("事故");
        case "idle":
            return qsTr("待命");
        default:
            return status ? String(status) : qsTr("未知");
        }
    }

    function intensityText(intensity: var): string {
        switch (intensity) {
        case "high_continuous":
            return qsTr("高强度常驻");
        case "continuous":
            return qsTr("常驻");
        case "daily_light":
            return qsTr("每日轻量");
        case "periodic":
            return qsTr("周期巡检");
        case "paused":
            return qsTr("暂停");
        default:
            return intensity ? String(intensity) : qsTr("未定");
        }
    }

    function workerDetail(worker: var): string {
        if (!worker)
            return "";

        const parts = [];
        if (worker.department)
            parts.push(String(worker.department));
        if (worker.intensity)
            parts.push(intensityText(worker.intensity));
        parts.push(workerStatusText(worker.status));
        if (worker.last_seen_at)
            parts.push(qsTr("最近 %1").arg(formatTime(worker.last_seen_at)));
        return parts.join(" · ");
    }

    function activeTaskCount(): int {
        const tasks = state.active_tasks ?? [];
        if (tasks.length !== undefined)
            return tasks.length;
        return Number(state.task_counts?.active_exported ?? 0);
    }

    function messageCount(type: string): int {
        const messages = office.recent_messages ?? [];
        let count = 0;
        for (let i = 0; i < messages.length; i++) {
            if (messages[i].message_type === type)
                count++;
        }
        return count;
    }

    function openIncidentCount(): int {
        if (office.open_incident_count !== undefined && office.open_incident_count !== null)
            return Number(office.open_incident_count);
        const incidents = office.open_incidents ?? [];
        return incidents.length ?? 0;
    }

    function hasWorkerMessage(workerId: string, type: string): bool {
        const messages = office.recent_messages ?? [];
        for (let i = 0; i < messages.length; i++) {
            const msg = messages[i];
            if ((msg.sender === workerId || msg.recipient === workerId) && msg.message_type === type)
                return true;
        }
        return false;
    }

    function workerBriefStatus(worker: var): string {
        if (!worker)
            return qsTr("未知");

        const status = String(worker.status || "");
        const id = String(worker.worker || worker.agent || "");
        if (status === "vacant" || status === "paused")
            return qsTr("空置");
        if (status === "blocked")
            return qsTr("阻塞");
        if (status === "incident")
            return qsTr("事故");
        if (worker.current_task_id)
            return qsTr("执行中");
        if (hasWorkerMessage(id, "accepted"))
            return qsTr("有交接");
        if (hasWorkerMessage(id, "handoff"))
            return qsTr("待验收");
        if (hasWorkerMessage(id, "ack"))
            return qsTr("待执行");
        if (status === "active")
            return qsTr("待首轮");
        return workerStatusText(status);
    }

    function importantCount(items: var): int {
        const cards = items ?? [];
        let count = 0;
        for (let i = 0; i < cards.length; i++) {
            if (Number(cards[i].importance ?? 0) >= 4)
                count++;
        }
        return count;
    }

    function reviewCount(items: var): int {
        const cards = items ?? [];
        let count = 0;
        for (let i = 0; i < cards.length; i++) {
            if ((cards[i].status || "open") === "open" && cards[i].permission !== "Observe")
                count++;
        }
        return count;
    }

    function officeSummary(): string {
        const workers = officeWorkers || [];
        if (workers.length <= 0)
            return qsTr("工作群等待建档");

        let active = 0;
        for (let i = 0; i < workers.length; i++) {
            if (workers[i].status === "active")
                active++;
        }
        return qsTr("%1 个岗位，%2 个在岗").arg(workers.length).arg(active);
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

    function headerSummary(): string {
        if (!loaded)
            return qsTr("等待本地工作舱状态。");
        if (runningScan)
            return qsTr("正在运行本地扫描。");

        const mode = runModeText(latestRun.mode);
        const idle = idleSummary(idleStatus);
        if (idleStatus && Object.keys(idleStatus).length > 0)
            return qsTr("最近%1；%2；自动化%3。").arg(mode).arg(officeSummary()).arg(idle);
        return qsTr("最近%1；%2；等待自动化状态。").arg(mode).arg(officeSummary());
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

    function parseLineCards(text: string): void {
        try {
            lineCardsDoc = JSON.parse(text || "{}");
        } catch (e) {
            lineCardsDoc = ({});
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

    FileView {
        id: lineCardsFile

        path: root.lineCardsPath
        watchChanges: true

        onLoaded: root.parseLineCards(text())
        onFileChanged: reload()
        onLoadFailed: err => root.lineCardsDoc = ({})
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
