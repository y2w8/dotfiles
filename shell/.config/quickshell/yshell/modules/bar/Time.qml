import QtQuick
import QtQuick.Layouts
import Quickshell

Text {
    id: timeBlock
    property string timeFormat: "dd MMM, yyyy - h:mm A"
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
    text: Qt.formatDateTime(clock.date, timeFormat)
    color: root.colBlue
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          if (timeFormat == "dd MMM, yyyy - h:mm A") {
            timeFormat = "yyyy/MM/dd - hh:mm"
          } else {
            timeFormat = "dd MMM, yyyy - h:mm A"
          }
        }
    }
}
