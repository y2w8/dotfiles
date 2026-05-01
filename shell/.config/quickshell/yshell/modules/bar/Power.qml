import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Text {
    property var power: Number(UPower.displayDevice.percentage * 100).toFixed(0)
    text: (power > 80 ? " " : power > 60 ? " " : power > 40 ? " " : power > 20 ? " " : " ") + power + "%"
    color: power > 60 ? root.colGreen : power > 20 ? root.colYellow : root.colRed
    font.family: root.fontFamily
    font.pixelSize: root.fontSize

    Behavior on color {
        ColorAnimation {
            duration: root.colorAnimation
        }
    }
}
