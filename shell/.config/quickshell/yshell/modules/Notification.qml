import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Notifications

WlrLayershell {
    id: notificationWindow

    layer: WlrLayer.Overlay
    keyboardFocus: WlrKeyboardFocus.None  // fix: keyboard passthrough

    anchors {
        top: true
        right: true
    }

    margins {
        top: 20
        right: 20
    }

    color: "transparent"
    implicitWidth: 400
    implicitHeight: 800

    // fix: mouse passthrough except on actual cards
    mask: Region {
        item: notificationList
    }

    ListModel {
        id: notificationModel
    }

    NotificationServer {
        id: notifyServer
        actionsSupported: true
        bodySupported: true

        onNotification: function (notification) {
            notification.tracked = true;  // must be FIRST before anything else

            if (controlCenter.dnd) {
                return; // Don't show popup if DND is on
            }

            console.log("[Quickshell] -> RECEIVED: " + notification.appName + " (Urgency: " + notification.urgency + ")");

            if (notification.actions && notification.actions.length > 0) {
                let a = notification.actions[0];
                console.log("action keys:", JSON.stringify(Object.keys(a)));
            }

            var finalTimeout = 5000;
            if (notification.expireTimeout > 0) {
                finalTimeout = notification.expireTimeout * 1000;
            } else if (notification.urgency === NotificationUrgency.Critical) {
                finalTimeout = -1;
            }

            notificationModel.insert(0, {
                "notifObj": notification,
                "timeLeft": finalTimeout,
                "isTimerRunning": finalTimeout > 0
            });
        }
    }

    function removeNotification(notification, isExpired) {
        for (var i = 0; i < notificationModel.count; i++) {
            if (notificationModel.get(i).notifObj === notification) {
                notificationModel.remove(i);
                if (notification && notification.tracked) {
                    try {
                        if (isExpired)
                            notification.expire();
                        else
                            notification.dismiss();
                    } catch (e) {}
                }
                break;
            }
        }
    }

    Timer {
        interval: 100
        running: notificationModel.count > 0
        repeat: true
        onTriggered: {
            for (var i = 0; i < notificationModel.count; i++) {
                var item = notificationModel.get(i);
                if (item.isTimerRunning) {
                    item.timeLeft -= 100;
                    if (item.timeLeft <= 0)
                        removeNotification(item.notifObj, true);
                }
            }
        }
    }

    Column {
        id: notificationList
        width: 400
        spacing: 12
        anchors.top: parent.top
        anchors.right: parent.right

        Repeater {
            model: notificationModel

            delegate: Rectangle {
                id: card
                width: 400
                height: Math.max(80, contentRow.implicitHeight + 24)
                color: root.colBase
                clip: true

                property bool isHovered: false
                property var activeNotif: model.notifObj

                border.width: 3
                border.color: {
                    if (!activeNotif)
                        return root.colRosewater;
                    if (activeNotif.urgency === NotificationUrgency.Critical)
                        return root.colRed;
                    if (activeNotif.urgency === NotificationUrgency.Low)
                        return root.colGreen;
                    return root.colRosewater;
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        card.isHovered = true;
                        if (model.timeLeft > 0)
                            model.isTimerRunning = false;
                    }
                    onExited: {
                        card.isHovered = false;
                        if (model.timeLeft > 0)
                            model.isTimerRunning = true;
                    }
                    // Card click — invoke default action
                    onClicked: {
                        if (activeNotif.actions) {
                            for (var i = 0; i < activeNotif.actions.length; i++) {
                                if (activeNotif.actions[i].identifier === "default") {
                                    activeNotif.actions[i].invoke();
                                    break;
                                }
                            }
                        }
                        removeNotification(activeNotif, false);
                    }
                }

                Row {
                    id: contentRow
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 12
                    }
                    spacing: 12

                    Rectangle {
                        id: iconBox
                        width: 40
                        height: 40
                        color: root.colSurface0
                        anchors.verticalCenter: parent.verticalCenter

                        IconImage {
                            width: 32
                            height: 32
                            anchors.centerIn: parent
                            source: Quickshell.iconPath(card.activeNotif.appIcon || "preferences-desktop-notification", "preferences-desktop-notification")
                        }
                    }

                    Column {
                        width: parent.width - iconBox.width - 24
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            text: card.activeNotif?.appName ?? "Notification"
                            font.pixelSize: 16
                            font.bold: true
                            font.family: root.fontFamily
                            color: root.colText
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Text {
                            text: card.activeNotif?.body ?? ""
                            font.pixelSize: 14
                            font.family: root.fontFamily
                            color: root.colSubtext0
                            width: parent.width
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere  // fix: wrap body
                            maximumLineCount: 4                           // fix: max 4 lines
                            elide: Text.ElideRight
                        }

                        // Action buttons
                        Row {
                            spacing: 6
                            visible: card.activeNotif?.actions?.length > 0

                            Repeater {
                                model: card.activeNotif?.actions ?? []

                                delegate: Rectangle {
                                    visible: modelData.identifier !== "default"
                                    height: 24
                                    width: actionText.width + 16
                                    color: actionMouse.containsMouse ? root.colSurface1 : root.colSurface0
                                    border.color: root.colRosewater
                                    border.width: 1

                                    Text {
                                        id: actionText
                                        anchors.centerIn: parent
                                        text: modelData.identifier  // or modelData.text if that's the label
                                        font.family: root.fontFamily
                                        font.pixelSize: 12
                                        color: root.colText
                                    }

                                    MouseArea {
                                        id: actionMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            modelData.invoke();
                                            removeNotification(card.activeNotif, false);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: closeButton
                    width: 18
                    height: 18
                    color: closeMouse.containsMouse ? root.colMaroon : root.colRed
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 10
                    anchors.rightMargin: 10
                    visible: card.isHovered || closeButton.isHovered
                    property bool isHovered: false

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        font.pixelSize: 16
                        color: root.colBase
                    }

                    MouseArea {
                        id: closeMouse
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: closeButton
                        hoverEnabled: true
                        onEntered: {
                            closeButton.isHovered = true;
                            if (model.timeLeft > 0)
                                model.isTimerRunning = false;
                        }
                        onExited: {
                            closeButton.isHovered = false;
                            if (model.timeLeft > 0)
                                model.isTimerRunning = true;
                        }
                        onClicked: removeNotification(card.activeNotif, false)
                    }
                }
            }
        }
    }
}
