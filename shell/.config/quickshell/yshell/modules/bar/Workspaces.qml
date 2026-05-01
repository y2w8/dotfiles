import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: workspacesRoot
    required property var screen

    height: 30
    Layout.fillHeight: true
    width: workspaceLayout.implicitWidth

    Rectangle {
        id: workspaceLayout
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        color: "transparent"
        width: innerRow.implicitWidth
        height: innerRow.implicitHeight

        RowLayout {
            id: innerRow
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            Repeater {
                model: niri.workspaces

                Column {
                    visible: output === screen.name
                    width: visible ? implicitWidth : 0
                    height: visible ? implicitHeight : 0

                    anchors.bottom: parent.bottom

                    Text {
                        id: workspaceText
                        text: index
                        leftPadding: 7
                        rightPadding: 7
                        bottomPadding: 2
                        font.family: root.fontFamily
                        font.pixelSize: 18
                        color: isActive ? root.colRosewater : root.colSubtext1

                        Behavior on color {
                            ColorAnimation {
                                duration: root.colorAnimation
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: niri.focusWorkspaceById(model.id)
                        }
                    }

                    Rectangle {
                        width: workspaceText.width
                        height: 3
                        color: isActive ? root.colRosewater : "transparent"

                        Behavior on color {
                            ColorAnimation {
                                duration: root.colorAnimation
                            }
                        }
                    }
                }
            }
        }
    }
}
