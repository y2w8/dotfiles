import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: trayRoot
    height: 30
    width: collapsed ? collapseBtn.width : collapseBtn.width + trayRow.implicitWidth + 8

    property bool collapsed: true

    // نربط النافذة الخارجية هنا عشان نتحكم فيها
    property var popupRef: null

    Behavior on width {
        NumberAnimation {
            duration: 220
            easing.type: Easing.InOutQuad
        }
    }

    // --- زر الفتح والإغلاق ---
    Rectangle {
        id: collapseBtn
        width: 24
        height: 24
        radius: 6
        anchors.verticalCenter: parent.verticalCenter
        color: btnMouse.containsMouse ? root.colSurface0 : "transparent"

        Text {
            anchors.centerIn: parent
            text: ""
            font.family: root.fontFamily
            font.pixelSize: 18
            color: btnMouse.containsMouse ? root.colRosewater : root.colSubtext1
            rotation: trayRoot.collapsed ? 0 : 90
            Behavior on rotation {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        MouseArea {
            id: btnMouse
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: trayRoot.collapsed = !trayRoot.collapsed
        }
    }

    // --- صف الأيقونات ---
    Row {
        id: trayRow
        anchors.left: collapseBtn.right
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
        visible: !trayRoot.collapsed

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayItem
                width: 22
                height: 22
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    id: itemVisual
                    anchors.fill: parent
                    radius: 4
                    color: itemMouse.containsMouse ? root.colSurface0 : "transparent"
                }

                Image {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: modelData.icon
                    fillMode: Image.PreserveAspectFit
                }

                QsMenuAnchor {
                    id: menuAnchor
                    anchor.window: trayItem.QsWindow.window
                    anchor.rect: {
                        if (trayItem.QsWindow.window && trayItem.QsWindow.window.contentItem) {
                            const pos = trayItem.mapToItem(trayItem.QsWindow.window.contentItem, 0, 0);
                            return Qt.rect(pos.x, pos.y, trayItem.width, trayItem.height);
                        }
                        return Qt.rect(0, 0, 0, 0);
                    }
                    anchor.edges: Qt.BottomEdge
                    anchor.gravity: Qt.BottomEdge
                    menu: modelData.menu
                }

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    hoverEnabled: true

                    onClicked: function (mouse) {
                        if (mouse.button === Qt.RightButton) {
                            if (modelData.menu)
                                menuAnchor.open();
                        } else {
                            if (modelData.menuOnly && modelData.menu) {
                                let items = [];
                                for (let entry of modelData.menu.children) {
                                    items.push({
                                        label: entry.label ?? "",
                                        enabled: entry.enabled ?? true,
                                        isSeparator: entry.isSeparator ?? false,
                                        entry: entry
                                    });
                                }

                                if (trayRoot.popupRef) {
                                    if (trayItem.QsWindow.window && trayItem.QsWindow.window.contentItem) {
                                        let localPos = trayItem.mapToItem(trayItem.QsWindow.window.contentItem, 0, 0);
                                        
                                        // تمرير البيانات للـ PopupWindow المستقل
                                        trayRoot.popupRef.anchor.window = trayItem.QsWindow.window;
                                        trayRoot.popupRef.anchor.rect = Qt.rect(localPos.x, localPos.y, trayItem.width, trayItem.height);
                                        trayRoot.popupRef.anchor.edges = Qt.BottomEdge;
                                        trayRoot.popupRef.anchor.gravity = Qt.BottomEdge;
                                        trayRoot.popupRef.margins.top = 4;
                                        
                                        trayRoot.popupRef.menuItems = items;
                                        trayRoot.popupRef.visible = true;
                                    }
                                }
                            } else {
                                modelData.activate();
                            }
                        }
                    }
                }
            }
        }
    }
}
