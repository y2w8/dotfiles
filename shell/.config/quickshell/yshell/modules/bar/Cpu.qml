import QtQuick
import Quickshell

Text {
    text: " " + root.systemInfo.cpuUsage + "%"
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    color: root.systemInfo.cpuUsage > 80 ? root.colRed : root.systemInfo.cpuUsage > 30 ? root.colYellow : root.colBlue
}
