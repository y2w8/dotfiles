import QtQuick
import Quickshell
import Quickshell.Io

Text {
    id: netText
    property string netType: ""
    property string netIcon: ""

    text: netIcon
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    color: netType === "none" ? root.colRed : root.colText

    Process {
        id: netProc
        command: ["bash", "-c", "ip route get 8.8.8.8 2>/dev/null | awk '{print $5}' | head -1"]
        running: true
        stdout: SplitParser {
            onRead: function(line) {
                let iface = line.trim()
                if (iface.startsWith("w")) {
                    netText.netIcon = ""
                    netText.netType = "wifi"
                } else if (iface.startsWith("e")) {
                    netText.netIcon = "󰈀"
                    netText.netType = "ethernet"
                } else {
                    netText.netIcon = ""
                    netText.netType = "none"
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: netProc.running = true
    }
}
