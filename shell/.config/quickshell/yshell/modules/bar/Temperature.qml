import QtQuick
import Quickshell
import Quickshell.Io

Text {
    id: tempText
    property int temp: 0
    property string tempIcon: temp >= 80 ? "" : temp >= 70 ? "" : ""

    text: tempIcon + " " + root.systemInfo.temp + "°C"
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    color: temp >= 80 ? root.colRed : root.colYellow

    Behavior on color {
        ColorAnimation {
            duration: root.colorAnimation
        }
    }
}
