import QtQuick
import Quickshell

PopupWindow {
    id: popupWindow
    visible: false
    
    // خصائص نمررها عند الفتح
    property var menuItems: []
    
    // التنسيق الجمالي حقك (Catppuccin)
    Rectangle {
        width: 190
        height: menuCol.implicitHeight + 16
        color: root.colBase
        border.color: root.colRosewater
        border.width: 1
        radius: 10

        // إغلاق عند خروج الفأرة بمسافة
        MouseArea {
            anchors.fill: parent
            z: -1
            anchors.margins: -50
            hoverEnabled: true
            onExited: popupWindow.visible = false
        }

        Column {
            id: menuCol
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 8
            }
            spacing: 4

            Repeater {
                model: popupWindow.menuItems

                delegate: Item {
                    width: parent.width
                    height: modelData.isSeparator ? 9 : 28

                    Rectangle {
                        visible: modelData.isSeparator
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 6
                        height: 1
                        color: root.colMuted
                        opacity: 0.2
                    }

                    Rectangle {
                        visible: !modelData.isSeparator
                        anchors.fill: parent
                        color: itemMouse.containsMouse && modelData.enabled ? root.colSurface0 : "transparent"
                        radius: 6

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            text: modelData.label
                            font.family: root.fontFamily
                            font.pixelSize: 13
                            color: modelData.enabled ? root.colText : root.colMuted
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: modelData.enabled && !modelData.isSeparator
                            onClicked: {
                                modelData.entry.triggered();
                                popupWindow.visible = false;
                            }
                        }
                    }
                }
            }
        }
    }
}
