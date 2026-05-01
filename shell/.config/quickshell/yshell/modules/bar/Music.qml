import QtQuick
import Quickshell
import Quickshell.Io

Text {
    id: musicText
    property string title: ""

    visible: title !== ""
    text: "  " + title
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    color: root.colSapphire

    Process {
        id: musicProc
        command: ["bash", "-c", "playerctl metadata --format='{{ title }}' 2>/dev/null | cut -c1-40"]
        running: true
        stdout: SplitParser {
            onRead: function(line) { musicText.title = line.trim() }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: musicProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            let p = Qt.createQmlObject('import Quickshell.Io; Process {}', musicText)
            p.command = ["playerctl", "play-pause"]
            p.running = true
        }
    }
}
