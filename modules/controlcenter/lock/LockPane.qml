pragma ComponentBehavior: Bound

import ".."
import "../components"
import qs.components
import qs.components.controls
import qs.components.containers
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Session session

    // ── Wave geometry ──
    property real waveXGap: Config.lock.wavyLines.xGap
    property real waveAmplitude: Config.lock.wavyLines.amplitude
    property real waveNoiseScale: Config.lock.wavyLines.noiseScale
    property real waveAnimSpeed: Config.lock.wavyLines.animSpeed
    property real wavePointDensity: Config.lock.wavyLines.pointDensity

    // ── Layer rendering ──
    property real waveGlowOpacity: Config.lock.wavyLines.glowOpacity
    property real waveMediumOpacity: Config.lock.wavyLines.mediumOpacity
    property real waveCoreOpacity: Config.lock.wavyLines.coreOpacity
    property real waveGlowWidth: Config.lock.wavyLines.glowWidth
    property real waveMediumWidth: Config.lock.wavyLines.mediumWidth
    property real waveCoreWidth: Config.lock.wavyLines.coreWidth

    anchors.fill: parent

    function saveConfig(): void {
        Config.lock.wavyLines.xGap = root.waveXGap;
        Config.lock.wavyLines.amplitude = root.waveAmplitude;
        Config.lock.wavyLines.noiseScale = root.waveNoiseScale;
        Config.lock.wavyLines.animSpeed = root.waveAnimSpeed;
        Config.lock.wavyLines.pointDensity = root.wavePointDensity;
        Config.lock.wavyLines.glowOpacity = root.waveGlowOpacity;
        Config.lock.wavyLines.mediumOpacity = root.waveMediumOpacity;
        Config.lock.wavyLines.coreOpacity = root.waveCoreOpacity;
        Config.lock.wavyLines.glowWidth = root.waveGlowWidth;
        Config.lock.wavyLines.mediumWidth = root.waveMediumWidth;
        Config.lock.wavyLines.coreWidth = root.waveCoreWidth;
        Config.save();
    }

    StyledFlickable {
        id: flickable

        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        flickableDirection: Flickable.VerticalFlick
        contentHeight: layout.height

        StyledScrollBar.vertical: StyledScrollBar {
            flickable: flickable
        }

        ColumnLayout {
            id: layout

            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Appearance.spacing.small

            StyledText {
                text: qsTr("Lock Screen")
                font.pointSize: Appearance.font.size.large
                font.weight: 500
            }

            // ════════ Wave Geometry ════════
            CollapsibleSection {
                id: geometrySection
                title: qsTr("Wave Geometry")
                showBackground: true

                SectionContainer {
                    contentSpacing: Appearance.spacing.normal

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Line spacing (px)")
                        value: root.waveXGap
                        from: 1.0
                        to: 30.0
                        decimals: 1
                        suffix: "px"
                        validator: DoubleValidator { bottom: 1.0; top: 30.0 }
                        onValueModified: newValue => {
                            root.waveXGap = newValue;
                            root.saveConfig();
                        }
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Wave amplitude (px)")
                        value: root.waveAmplitude
                        from: 1.0
                        to: 100.0
                        decimals: 0
                        suffix: "px"
                        validator: DoubleValidator { bottom: 1.0; top: 100.0 }
                        onValueModified: newValue => {
                            root.waveAmplitude = newValue;
                            root.saveConfig();
                        }
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Noise complexity")
                        value: root.waveNoiseScale
                        from: 1.0
                        to: 30.0
                        decimals: 1
                        validator: DoubleValidator { bottom: 1.0; top: 30.0 }
                        onValueModified: newValue => {
                            root.waveNoiseScale = newValue;
                            root.saveConfig();
                        }
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Animation speed")
                        value: root.waveAnimSpeed
                        from: 0.0
                        to: 5.0
                        decimals: 2
                        suffix: "×"
                        validator: DoubleValidator { bottom: 0.0; top: 5.0 }
                        onValueModified: newValue => {
                            root.waveAnimSpeed = newValue;
                            root.saveConfig();
                        }
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Point density")
                        value: root.wavePointDensity
                        from: 0.1
                        to: 5.0
                        decimals: 2
                        suffix: "×"
                        validator: DoubleValidator { bottom: 0.1; top: 5.0 }
                        onValueModified: newValue => {
                            root.wavePointDensity = newValue;
                            root.saveConfig();
                        }
                    }
                }
            }

            // ════════ Layer Rendering ════════
            CollapsibleSection {
                id: layerSection
                title: qsTr("Layer Rendering")
                showBackground: true

                SectionContainer {
                    contentSpacing: Appearance.spacing.normal

                    StyledText {
                        text: qsTr("Glow (outer halo)")
                        font.pointSize: Appearance.font.size.normal
                        font.weight: 500
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Width")
                        value: root.waveGlowWidth
                        from: 0.5
                        to: 15.0
                        decimals: 1
                        suffix: "px"
                        validator: DoubleValidator { bottom: 0.5; top: 15.0 }
                        onValueModified: newValue => {
                            root.waveGlowWidth = newValue;
                            root.saveConfig();
                        }
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Opacity")
                        value: root.waveGlowOpacity
                        from: 0
                        to: 100
                        decimals: 0
                        suffix: "%"
                        validator: DoubleValidator { bottom: 0; top: 100 }
                        onValueModified: newValue => {
                            root.waveGlowOpacity = newValue;
                            root.saveConfig();
                        }
                    }

                    StyledText {
                        Layout.topMargin: Appearance.spacing.small
                        text: qsTr("Medium (mid layer)")
                        font.pointSize: Appearance.font.size.normal
                        font.weight: 500
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Width")
                        value: root.waveMediumWidth
                        from: 0.2
                        to: 10.0
                        decimals: 1
                        suffix: "px"
                        validator: DoubleValidator { bottom: 0.2; top: 10.0 }
                        onValueModified: newValue => {
                            root.waveMediumWidth = newValue;
                            root.saveConfig();
                        }
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Opacity")
                        value: root.waveMediumOpacity
                        from: 0
                        to: 100
                        decimals: 0
                        suffix: "%"
                        validator: DoubleValidator { bottom: 0; top: 100 }
                        onValueModified: newValue => {
                            root.waveMediumOpacity = newValue;
                            root.saveConfig();
                        }
                    }

                    StyledText {
                        Layout.topMargin: Appearance.spacing.small
                        text: qsTr("Core (thin line)")
                        font.pointSize: Appearance.font.size.normal
                        font.weight: 500
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Width")
                        value: root.waveCoreWidth
                        from: 0.1
                        to: 5.0
                        decimals: 1
                        suffix: "px"
                        validator: DoubleValidator { bottom: 0.1; top: 5.0 }
                        onValueModified: newValue => {
                            root.waveCoreWidth = newValue;
                            root.saveConfig();
                        }
                    }

                    SliderInput {
                        Layout.fillWidth: true
                        label: qsTr("Opacity")
                        value: root.waveCoreOpacity
                        from: 0
                        to: 100
                        decimals: 0
                        suffix: "%"
                        validator: DoubleValidator { bottom: 0; top: 100 }
                        onValueModified: newValue => {
                            root.waveCoreOpacity = newValue;
                            root.saveConfig();
                        }
                    }
                }
            }
        }
    }
}
