import QtQuick
import Quickshell

Rectangle {
    property string label: ""
    signal chosen()

    width: 180
    height: 44
    color: optMouse.containsMouse ? root.colSurface1 : root.colSurface0
    border.color: root.colSurface0
    border.width: 3

    Text {
        anchors.centerIn: parent
        text: label
        font.family: root.fontFamily
        font.pixelSize: 12
        color: root.colText
    }

    MouseArea {
        id: optMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: chosen()
    }
}
