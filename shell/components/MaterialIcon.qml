import qs.services
import qs.config

StyledText {
    property real fill
    property int grade: 0
    readonly property real _fillAxis: Math.round(Math.max(0, Math.min(1, fill)) * 8) / 8
    readonly property int _opszAxis: Math.max(20, Math.min(48, Math.round(fontInfo.pixelSize / 2) * 2))
    readonly property int _wghtAxis: Math.round(fontInfo.weight / 50) * 50

    font.family: Appearance.font.family.material
    font.pointSize: Appearance.font.size.larger
    font.variableAxes: ({
            FILL: _fillAxis,
            GRAD: grade,
            opsz: _opszAxis,
            wght: _wghtAxis
        })
}
