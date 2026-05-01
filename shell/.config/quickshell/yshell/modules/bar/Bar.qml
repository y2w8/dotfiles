import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: bar
    property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 35

    Rectangle {
        anchors.fill: parent
        color: root.colBase

        // left
        RowLayout {
            anchors {
                left: parent.left
                leftMargin: 10
            }
            Workspaces {
                screen: modelData
            }
        }
        // center
        RowLayout {
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            spacing: 12

            PrivacyIndicator {}

            TrayPopup {
                id: globalTrayPopup
            }

            TrayMenu {
                popupRef: globalTrayPopup
            }
        }
        // right
        RowLayout {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 25
            }
            spacing: 10

            // Music {}
            // Sep {}
            // Network {}
            // Sep {}
            Power {}
            Sep {}
            Volume {}
            Sep {}
            Memory {}
            Sep {}
            Temperature {}
            Sep {}
            Cpu {}
            // Sep {}
            // Disk {}
            Sep {}
            Time {}
        }
    }
}
