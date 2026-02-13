import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: layout.implicitWidth > 800 ? layout.implicitWidth : 840
    implicitHeight: layout.implicitHeight

    readonly property var today: Weather.forecast && Weather.forecast.length > 0 ? Weather.forecast[0] : null

    Component.onCompleted: Weather.reload()

    ColumnLayout {
        id: layout

        anchors.fill: parent
        spacing: Appearance.spacing.smaller

        RowLayout {
            Layout.leftMargin: Appearance.padding.large
            Layout.rightMargin: Appearance.padding.large
            Layout.fillWidth: true

            Column {
                spacing: Appearance.spacing.small / 2

                StyledText {
                    text: Weather.city || qsTr("Loading...")
                    font.pointSize: Appearance.font.size.extraLarge
                    font.weight: 600
                    color: ComponentColors.region.dashboard.weather.city
                }

                StyledText {
                    text: new Date().toLocaleDateString(Qt.locale(), "dddd, MMMM d")
                    font.pointSize: Appearance.font.size.small
                    color: ComponentColors.region.dashboard.weather.date
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                spacing: Appearance.spacing.large

                WeatherStat {
                    icon: "wb_twilight"
                    label: "Sunrise"
                    value: Weather.sunrise
                    colour: ComponentColors.region.dashboard.weather.sunriseSunset
                }

                WeatherStat {
                    icon: "bedtime"
                    label: "Sunset"
                    value: Weather.sunset
                    colour: ComponentColors.region.dashboard.weather.sunriseSunset
                }
            }
        }

        StyledRect {
            Layout.fillWidth: true
            implicitHeight: bigInfoRow.implicitHeight + Appearance.padding.small * 2

            radius: Appearance.rounding.large * 2
            color: Colours.layer(ComponentColors.region.dashboard.weather.card)

            RowLayout {
                id: bigInfoRow

                anchors.centerIn: parent
                spacing: Appearance.spacing.large

                MaterialIcon {
                    Layout.alignment: Qt.AlignVCenter
                    text: Weather.icon
                    font.pointSize: Appearance.font.size.extraLarge * 3
                    color: ComponentColors.region.dashboard.weather.mainIcon
                    animate: true
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: -Appearance.spacing.small

                    StyledText {
                        text: Weather.temp
                        font.pointSize: Appearance.font.size.extraLarge * 2
                        font.weight: 500
                        color: ComponentColors.region.dashboard.weather.temperature
                    }

                    StyledText {
                        Layout.leftMargin: Appearance.padding.small
                        text: Weather.description
                        font.pointSize: Appearance.font.size.normal
                        color: ComponentColors.region.dashboard.weather.description
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Appearance.spacing.smaller

            DetailCard {
                icon: "water_drop"
                label: "Humidity"
                value: Weather.humidity + "%"
                colour: ComponentColors.region.dashboard.weather.detail.icon
            }
            DetailCard {
                icon: "thermostat"
                label: "Feels Like"
                value: Weather.feelsLike
                colour: ComponentColors.region.dashboard.weather.detail.icon
            }
            DetailCard {
                icon: "air"
                label: "Wind"
                value: Weather.windSpeed ? Weather.windSpeed + " km/h" : "--"
                colour: ComponentColors.region.dashboard.weather.detail.icon
            }
        }

        StyledText {
            Layout.topMargin: Appearance.spacing.normal
            Layout.leftMargin: Appearance.padding.normal
            visible: forecastRepeater.count > 0
            text: qsTr("7-Day Forecast")
            font.pointSize: Appearance.font.size.normal
            font.weight: 600
            color: ComponentColors.region.dashboard.weather.forecast.heading
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Appearance.spacing.smaller

            Repeater {
                id: forecastRepeater

                model: Weather.forecast

                StyledRect {
                    id: forecastItem

                    required property int index
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: forecastItemColumn.implicitHeight + Appearance.padding.normal * 2

                    radius: Appearance.rounding.normal
                    color: Colours.layer(ComponentColors.region.dashboard.weather.forecast.card)

                    ColumnLayout {
                        id: forecastItemColumn

                        anchors.centerIn: parent
                        spacing: Appearance.spacing.small

                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: new Date(forecastItem.modelData.date).toLocaleDateString(Qt.locale(), "ddd")
                            font.pointSize: Appearance.font.size.normal
                            font.weight: Font.Bold
                            color: ComponentColors.region.dashboard.weather.forecast.day
                        }

                        StyledText {
                            Layout.topMargin: -Appearance.spacing.small / 2
                            Layout.alignment: Qt.AlignHCenter
                            text: new Date(forecastItem.modelData.date).toLocaleDateString(Qt.locale(), "M/d")
                            font.pointSize: Appearance.font.size.small
                            opacity: 0.7
                            color: ComponentColors.region.dashboard.weather.forecast.date
                        }

                        MaterialIcon {
                            Layout.alignment: Qt.AlignHCenter
                            text: forecastItem.modelData.icon
                            font.pointSize: Appearance.font.size.extraLarge
                            color: ComponentColors.region.dashboard.weather.forecast.icon
                        }

                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: Config.services.useFahrenheit ? forecastItem.modelData.maxTempF + "°" + " / " + forecastItem.modelData.minTempF + "°" : forecastItem.modelData.maxTempC + "°" + " / " + forecastItem.modelData.minTempC + "°"
                            font.weight: 600
                            color: ComponentColors.region.dashboard.weather.forecast.temps
                        }
                    }
                }
            }
        }
    }

    component DetailCard: StyledRect {
        id: detailRoot

        property string icon
        property string label
        property string value
        property color colour

        Layout.fillWidth: true
        Layout.preferredHeight: 60
        radius: Appearance.rounding.small
        color: Colours.layer(ComponentColors.region.dashboard.weather.detail.card)

        Row {
            anchors.centerIn: parent
            spacing: Appearance.spacing.normal

            MaterialIcon {
                text: detailRoot.icon
                color: detailRoot.colour
                font.pointSize: Appearance.font.size.large
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                StyledText {
                    text: detailRoot.label
                    font.pointSize: Appearance.font.size.smaller
                    opacity: 0.7
                    horizontalAlignment: Text.AlignLeft
                }
                StyledText {
                    text: detailRoot.value
                    font.weight: 600
                    horizontalAlignment: Text.AlignLeft
                }
            }
        }
    }

    component WeatherStat: Row {
        id: weatherStat

        property string icon
        property string label
        property string value
        property color colour

        spacing: Appearance.spacing.small

        MaterialIcon {
            text: weatherStat.icon
            font.pointSize: Appearance.font.size.extraLarge
            color: weatherStat.colour
        }

        Column {
            StyledText {
                text: weatherStat.label
                font.pointSize: Appearance.font.size.smaller
                color: ComponentColors.region.dashboard.weather.stat.label
            }
            StyledText {
                text: weatherStat.value
                font.pointSize: Appearance.font.size.small
                font.weight: 600
                color: ComponentColors.region.dashboard.weather.stat.value
            }
        }
    }
}
