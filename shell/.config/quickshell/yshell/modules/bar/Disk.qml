import QtQuick
import Quickshell
import Quickshell.Io

Text {
    id: diskText
    property int diskUsed: 0

    text: diskUsed + "% "
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    color: diskUsed > 90 ? root.colRed : diskUsed > 70 ? root.colYellow : root.colText

    Process {
        id: diskProc
        command: ["bash", "-c", "df / | awk 'NR==2{print $5}' | tr -d '%'"]
        running: true
        stdout: SplitParser {
            onRead: function(line) { diskText.diskUsed = parseInt(line.trim()) }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: diskProc.running = true
    }
}
