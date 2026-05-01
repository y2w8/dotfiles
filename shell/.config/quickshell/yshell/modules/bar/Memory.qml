import QtQuick
import Quickshell

Text {
    text: "  " + root.systemInfo.memUsed + "/" + root.systemInfo.memTotal + " GB"
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    color: root.colRed
}
