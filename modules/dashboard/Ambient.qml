pragma ComponentBehavior: Bound

import qs.components
import qs.components.containers
import qs.components.controls
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    readonly property var run: AmbientCodex.latestRun
    readonly property var usage: AmbientCodex.usageLatest
    readonly property var readiness: AmbientCodex.readinessLatest
    readonly property var idle: AmbientCodex.idleStatus
    readonly property var counts: AmbientCodex.cardCounts
    readonly property int cardCount: AmbientCodex.cards.length
    property int cardIndex: 0
    property real maxHeight: 720

    onCardCountChanged: cardIndex = Math.min(cardIndex, Math.max(cardCount - 1, 0))

    function showCard(index: int): void {
        if (cardCount <= 0) {
            cardIndex = 0;
            return;
        }
        cardIndex = (index + cardCount) % cardCount;
    }

    implicitWidth: 860
    implicitHeight: Math.min(page.implicitHeight, maxHeight)

    StyledFlickable {
        id: flickable

        anchors.fill: parent
        clip: true
        flickableDirection: Flickable.VerticalFlick
        contentWidth: width
        contentHeight: page.implicitHeight

        StyledScrollBar.vertical: StyledScrollBar {
            flickable: flickable
        }

        ColumnLayout {
            id: page

            width: flickable.width
            spacing: Appearance.spacing.normal

            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.normal

                MaterialIcon {
                    text: "neurology"
                    fill: 1
                    color: ComponentColors.region.shared.controls.common.accent
                    font.pointSize: Appearance.font.size.extraLarge
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    StyledText {
                        text: qsTr("Codex 本地工作舱")
                        font.pointSize: Appearance.font.size.large
                        font.weight: 600
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: AmbientCodex.headerSummary()
                        color: ComponentColors.region.shared.controls.common.subtext
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }
                }

                IconTextButton {
                    icon: AmbientCodex.runningScan ? "sync" : "refresh"
                    text: AmbientCodex.runningScan ? qsTr("运行中") : qsTr("手动扫描")
                    enabled: !AmbientCodex.runningScan
                    type: IconTextButton.Tonal
                    onClicked: AmbientCodex.runScan()
                }

                IconTextButton {
                    icon: "open_in_new"
                    text: qsTr("打开报告")
                    type: IconTextButton.Text
                    onClicked: AmbientCodex.openDashboard()
                }
            }

            StyledRect {
                Layout.fillWidth: true
                implicitHeight: overview.implicitHeight + Appearance.padding.large * 2
                radius: Appearance.rounding.large
                color: Colours.layer(ComponentColors.region.dashboard.card.container.surface)

                ColumnLayout {
                    id: overview

                    anchors.fill: parent
                    anchors.margins: Appearance.padding.large
                    spacing: Appearance.spacing.normal

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Appearance.spacing.normal

                        Metric {
                            title: qsTr("运行")
                            value: AmbientCodex.statusText(root.run.status)
                            detail: root.run.id ? AmbientCodex.shortId(root.run.id) : qsTr("还没有运行")
                            icon: "task_alt"
                        }

                        Metric {
                            title: qsTr("卡片")
                            value: String(root.counts.open ?? root.counts.latest_run ?? AmbientCodex.cards.length)
                            detail: qsTr("重要 %1 · 待审 %2").arg(root.counts.high_importance ?? 0).arg(root.counts.needs_review ?? 0)
                            icon: "inbox"
                        }

                        Metric {
                            title: qsTr("额度")
                            value: AmbientCodex.percentText(root.usage.primary_used_percent)
                            detail: qsTr("长期 %1").arg(AmbientCodex.percentText(root.usage.secondary_used_percent))
                            icon: "speed"
                        }

                        Metric {
                            title: qsTr("更新")
                            value: AmbientCodex.formatTime(root.run.finished_at)
                            detail: AmbientCodex.runModeText(root.run.mode)
                            icon: "schedule"
                        }

                        Metric {
                            title: qsTr("守门")
                            value: AmbientCodex.modeText(root.readiness.mode)
                            detail: root.readiness.can_codex_worker ? qsTr("后台可用") : root.readiness.can_prepare ? qsTr("仅本地") : qsTr("暂停")
                            icon: "shield"
                        }
                    }

                    StyledText {
                        visible: AmbientCodex.error !== ""
                        Layout.fillWidth: true
                        text: AmbientCodex.error
                        color: ComponentColors.region.state.error
                        wrapMode: Text.WordWrap
                    }

                    StyledText {
                        visible: AmbientCodex.lastRunError !== ""
                        Layout.fillWidth: true
                        text: AmbientCodex.lastRunError
                        color: ComponentColors.region.state.error
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.normal

                StyledRect {
                    Layout.fillWidth: true
                    implicitHeight: agentsColumn.implicitHeight + Appearance.padding.large * 2
                    radius: Appearance.rounding.normal
                    color: Colours.layer(ComponentColors.region.dashboard.card.container.surface)

                    ColumnLayout {
                        id: agentsColumn

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: Appearance.padding.large
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Appearance.spacing.small

                        Header {
                            title: qsTr("协作者状态")
                            icon: "hub"
                        }

                        Repeater {
                            model: AmbientCodex.agents

                            AgentRow {
                                required property var modelData
                                agent: modelData
                            }
                        }
                    }
                }

                StyledRect {
                    Layout.fillWidth: true
                    implicitHeight: boundaryColumn.implicitHeight + Appearance.padding.large * 2
                    radius: Appearance.rounding.normal
                    color: Colours.layer(ComponentColors.region.dashboard.card.container.surface)

                    ColumnLayout {
                        id: boundaryColumn

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: Appearance.padding.large
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Appearance.spacing.small

                        Header {
                            title: qsTr("边界")
                            icon: "verified_user"
                        }

                        BoundaryRow {
                            icon: "shield"
                            text: qsTr("守门状态：%1").arg(AmbientCodex.modeText(root.readiness.mode))
                        }

                        BoundaryRow {
                            icon: "settings_backup_restore"
                            text: qsTr("自动化：%1").arg(AmbientCodex.idleSummary(root.idle))
                        }

                        BoundaryRow {
                            icon: "visibility"
                            text: qsTr("只读本地扫描")
                        }

                        BoundaryRow {
                            icon: "edit_off"
                            text: qsTr("不编辑项目，不推送 Git")
                        }

                        BoundaryRow {
                            icon: "lock"
                            text: qsTr("不使用 sudo、浏览器、邮件或 HPC")
                        }

                        BoundaryRow {
                            icon: "data_object"
                            text: qsTr("只解析额度元数据")
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.small

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Appearance.spacing.small

                    Header {
                        title: qsTr("行动卡片")
                        icon: "view_agenda"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    StyledText {
                        visible: root.cardCount > 0
                        text: qsTr("%1 / %2").arg(root.cardIndex + 1).arg(root.cardCount)
                        color: ComponentColors.region.shared.controls.common.subtext
                    }

                    IconButton {
                        icon: "chevron_left"
                        type: IconButton.Text
                        disabled: root.cardCount <= 1
                        onClicked: root.showCard(root.cardIndex - 1)
                    }

                    IconButton {
                        icon: "chevron_right"
                        type: IconButton.Text
                        disabled: root.cardCount <= 1
                        onClicked: root.showCard(root.cardIndex + 1)
                    }
                }

                Item {
                    visible: root.cardCount > 0
                    Layout.fillWidth: true
                    implicitHeight: currentCard.implicitHeight

                    ActionCard {
                        id: currentCard

                        anchors.left: parent.left
                        anchors.right: parent.right
                        card: root.cardCount > 0 ? AmbientCodex.cards[root.cardIndex] : ({})
                    }

                    MouseArea {
                        anchors.fill: currentCard
                        acceptedButtons: Qt.NoButton

                        onWheel: event => {
                            if (root.cardCount <= 1)
                                return;

                            const delta = Math.abs(event.angleDelta.x) > Math.abs(event.angleDelta.y) ? event.angleDelta.x : event.angleDelta.y;
                            if (delta < 0)
                                root.showCard(root.cardIndex + 1);
                            else if (delta > 0)
                                root.showCard(root.cardIndex - 1);
                            event.accepted = true;
                        }
                    }
                }

                RowLayout {
                    visible: root.cardCount > 1
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Appearance.spacing.smaller

                    Repeater {
                        model: root.cardCount

                        StyledRect {
                            required property int index

                            implicitWidth: index === root.cardIndex ? 22 : 7
                            implicitHeight: 7
                            radius: Appearance.rounding.full
                            color: index === root.cardIndex ? ComponentColors.region.shared.controls.common.accent : ComponentColors.region.shared.controls.common.subtext
                            opacity: index === root.cardIndex ? 1 : 0.45

                            StateLayer {
                                radius: parent.radius

                                function onClicked(): void {
                                    root.showCard(index);
                                }
                            }

                            Behavior on implicitWidth {
                                Anim {}
                            }
                        }
                    }
                }

                StyledRect {
                    visible: root.cardCount === 0
                    Layout.fillWidth: true
                    implicitHeight: emptyCardText.implicitHeight + Appearance.padding.large * 2
                    radius: Appearance.rounding.normal
                    color: Colours.layer(ComponentColors.region.dashboard.card.container.surface)

                    StyledText {
                        id: emptyCardText

                        anchors.centerIn: parent
                        text: qsTr("还没有行动卡片")
                        color: ComponentColors.region.shared.controls.common.subtext
                    }
                }
            }
        }
    }

    component Header: RowLayout {
        id: header

        required property string title
        required property string icon

        spacing: Appearance.spacing.small

        MaterialIcon {
            text: header.icon
            color: ComponentColors.region.shared.controls.common.accent
            fill: 1
            font.pointSize: Appearance.font.size.large
        }

        StyledText {
            text: header.title
            font.weight: 600
            font.pointSize: Appearance.font.size.normal
        }
    }

    component Metric: StyledRect {
        id: metric

        required property string title
        required property string value
        required property string detail
        required property string icon

        Layout.fillWidth: true
        implicitHeight: metricColumn.implicitHeight + Appearance.padding.normal * 2
        radius: Appearance.rounding.normal
        color: Colours.layer(ComponentColors.region.shared.controls.common.surface, 2)

        ColumnLayout {
            id: metricColumn

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Appearance.padding.normal
            anchors.verticalCenter: parent.verticalCenter
            spacing: Appearance.spacing.small / 2

            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.small

                MaterialIcon {
                    text: metric.icon
                    color: ComponentColors.region.shared.controls.common.accent
                    fill: 1
                }

                StyledText {
                    Layout.fillWidth: true
                    text: metric.title
                    color: ComponentColors.region.shared.controls.common.subtext
                    elide: Text.ElideRight
                }
            }

            StyledText {
                Layout.fillWidth: true
                text: metric.value
                font.pointSize: Appearance.font.size.larger
                font.weight: 600
                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true
                text: metric.detail
                color: ComponentColors.region.shared.controls.common.subtext
                elide: Text.ElideRight
            }
        }
    }

    component AgentRow: RowLayout {
        id: agentRow

        required property var agent

        Layout.fillWidth: true
        spacing: Appearance.spacing.small

        StyledRect {
            implicitWidth: 8
            implicitHeight: 8
            radius: Appearance.rounding.full
            color: agentRow.agent.status === "idle" ? ComponentColors.region.state.success : ComponentColors.region.state.warning
        }

        StyledText {
            Layout.preferredWidth: 150
            text: AmbientCodex.agentText(agentRow.agent.agent)
            font.weight: 500
            elide: Text.ElideRight
        }

        StyledText {
            Layout.fillWidth: true
            text: agentRow.agent.message || agentRow.agent.status || ""
            color: ComponentColors.region.shared.controls.common.subtext
            elide: Text.ElideRight
        }
    }

    component BoundaryRow: RowLayout {
        id: boundaryRow

        required property string icon
        required property string text

        Layout.fillWidth: true
        spacing: Appearance.spacing.small

        MaterialIcon {
            text: boundaryRow.icon
            color: ComponentColors.region.shared.controls.common.subtext
        }

        StyledText {
            Layout.fillWidth: true
            text: boundaryRow.text
            color: ComponentColors.region.shared.controls.common.subtext
            wrapMode: Text.WordWrap
        }
    }

    component ActionCard: StyledRect {
        id: actionCard

        required property var card

        Layout.fillWidth: true
        implicitHeight: cardColumn.implicitHeight + Appearance.padding.large * 2
        radius: Appearance.rounding.normal
        color: Colours.layer(ComponentColors.region.dashboard.card.container.surface)

        ColumnLayout {
            id: cardColumn

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Appearance.padding.large
            anchors.verticalCenter: parent.verticalCenter
            spacing: Appearance.spacing.small

            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.small

                StyledText {
                    Layout.fillWidth: true
                    text: actionCard.card.title || qsTr("未命名")
                    font.weight: 600
                    font.pointSize: Appearance.font.size.normal
                    wrapMode: Text.WordWrap
                }

                Pill {
                    text: AmbientCodex.agentText(actionCard.card.agent)
                    tone: "neutral"
                }

                Pill {
                    text: AmbientCodex.permissionText(actionCard.card.permission)
                    tone: actionCard.card.permission === "Observe" ? "success" : "warning"
                }
            }

            StyledText {
                Layout.fillWidth: true
                text: actionCard.card.conclusion || ""
                wrapMode: Text.WordWrap
            }

            StyledText {
                Layout.fillWidth: true
                text: actionCard.card.next_action || ""
                color: ComponentColors.region.shared.controls.common.subtext
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.small

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("重要性 %1  置信度 %2").arg(actionCard.card.importance ?? "-").arg(actionCard.card.confidence ?? "-")
                    color: ComponentColors.region.shared.controls.common.subtext
                    elide: Text.ElideRight
                }

                IconTextButton {
                    visible: !!actionCard.card.report_path
                    icon: "article"
                    text: qsTr("报告")
                    type: IconTextButton.Text
                    onClicked: AmbientCodex.openPath(actionCard.card.report_path)
                }
            }
        }
    }

    component Pill: StyledRect {
        id: pill

        required property string text
        property string tone: "neutral"

        implicitWidth: label.implicitWidth + Appearance.padding.small * 2
        implicitHeight: label.implicitHeight + Appearance.padding.smaller
        radius: Appearance.rounding.full
        color: tone === "success" ? ComponentColors.region.state.successContainer : tone === "warning" ? ComponentColors.region.state.warningContainer : ComponentColors.region.shared.controls.button.tonalBg

        StyledText {
            id: label

            anchors.centerIn: parent
            text: pill.text
            color: pill.tone === "success" ? ComponentColors.region.state.onSuccessContainer : pill.tone === "warning" ? ComponentColors.region.state.onWarningContainer : ComponentColors.region.shared.controls.button.tonalText
            font.pointSize: Appearance.font.size.small
        }
    }
}
