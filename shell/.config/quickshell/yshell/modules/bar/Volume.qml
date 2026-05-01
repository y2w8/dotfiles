import QtQuick
import Quickshell
import Quickshell.Io

Text {
    id: volumeText

    property bool muted: root.systemInfo.volOutMuted
    property int vol: Math.round(root.systemInfo.volOut * 100)  // convert to 0-100

    property string icon: muted ? "󰝟" : vol >= 70 ? "󰕾" : vol >= 30 ? "󰖀" : "󰕿"

    text: icon + " " + (muted ? "Muted" : vol + "%")
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    color: root.colMaroon

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onWheel: function (wheel) {
            let p = Qt.createQmlObject('import Quickshell.Io; Process {}', volumeText);
            if (wheel.angleDelta.y > 0)
                root.systemInfo.increase_vol();
            else
                root.systemInfo.decrease_vol();
        }

        onClicked: root.systemInfo.mute_vol()
    }
}
