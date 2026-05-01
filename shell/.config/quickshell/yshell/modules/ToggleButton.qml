import QtQuick
import Quickshell

Rectangle {
    property string label: ""
    property string icon: ""
    property bool active: false
    property bool hasArrow: false
    property bool arrowOpen: false
    signal toggled()
    signal arrowClicked()

    width: hasArrow ? 183 : 190
    height: 60
    color: active ? root.colRosewater : root.colSurface0
    border.color: active ? root.colRosewater : root.colSurface1
    border.width: 3

    Column {
        anchors.centerIn: hasArrow ? undefined : parent
        anchors.left: hasArrow ? parent.left : undefined
        anchors.leftMargin: hasArrow ? 14 : 0
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Text {
            text: icon
            font.family: root.fontFamily
            font.pixelSize: 20
            color: active ? root.colBase : root.colText
        }

        Text {
            text: label
            font.family: root.fontFamily
            font.pixelSize: 11
            color: active ? root.colBase : root.colText
            elide: Text.ElideRight
            width: hasArrow ? 120 : 150
        }
    }

    // Arrow button on the right
    Rectangle {
        visible: hasArrow
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 28
        color: Qt.rgba(0, 0, 0, 0.1)

        Text {
            anchors.centerIn: parent
            text: ""
            font.family: root.fontFamily
            font.pixelSize: 18
            color: active ? root.colBase : root.colText
            rotation: arrowOpen ? 90 : 0
            Behavior on rotation {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: arrowClicked()
        }
    }

    MouseArea {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: hasArrow ? parent.width - 28 : parent.width
        cursorShape: Qt.PointingHandCursor
        onClicked: toggled()
    }
}
