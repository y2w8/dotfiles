import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io

PanelWindow {
    id: osd
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay

    required property var modelData
    screen: modelData

    anchors {
        bottom: true
        left: false
        right: false
    }

    implicitWidth: 320
    implicitHeight: 80
    margins {
        bottom: 40
    }
    visible: false

    readonly property string iconCaps: "keyboard-caps-disabled"
    readonly property string iconCapsFill: "keyboard-caps-enabled"
    readonly property string iconNum: "keyboard-caps-disabled"
    readonly property string iconNumFill: "keyboard-caps-enabled"
    readonly property string iconVolMute: "audio-volume-muted"
    readonly property string iconVolLow: "audio-volume-low"
    readonly property string iconVolMedium: "audio-volume-medium"
    readonly property string iconVolHigh: "audio-volume-high"

    property string iconName: ""
    property string label: ""
    property int value: 0
    property color barColor: root.colRosewater

    property int lastCapsState: 0
    property int lastNumState: 0

    function show(i, l, v, c) {
        iconName = i;
        label = l;
        value = v;
        barColor = c ?? root.colRosewater;
        osd.visible = true;
        osdTimer.restart();
    }

    Timer {
        id: osdTimer
        interval: 2000
        onTriggered: osd.visible = false
    }

    // Volume via SystemInfo (Pipewire)
    Connections {
        target: root.systemInfo
        function onVolOutChanged() {
            let vol = Math.round(root.systemInfo.volOut * 100);
            let muted = root.systemInfo.volOutMuted;
            let icon = muted ? iconVolMute : vol >= 70 ? iconVolHigh : vol >= 40 ? iconVolMedium : iconVolLow;
            osd.show(icon, "Output " + (muted ? "Muted" : vol + "%"), muted ? 0 : vol, muted ? root.colSurface2 : root.colRosewater);
        }
        function onVolOutMutedChanged() {
            let vol = Math.round(root.systemInfo.volOut * 100);
            let muted = root.systemInfo.volOutMuted;
            let icon = muted ? iconVolMute : vol >= 70 ? iconVolHigh : vol >= 40 ? iconVolMedium : iconVolLow;
            osd.show(icon, "Output " + (muted ? "Muted" : vol + "%"), muted ? 0 : vol, muted ? root.colSurface2 : root.colRosewater);
        }
    }

    // CapsLock
    Process {
        id: capsProc
        command: ["bash", "-c", "while true; do cat /sys/class/leds/input*::capslock/brightness; sleep 0.1; done"]
        running: true
        stdout: SplitParser {
            onRead: function (line) {
                let currentState = parseInt(line.trim());
                if (currentState === osd.lastCapsState)
                    return;
                osd.lastCapsState = currentState;
                let on = (currentState === 1);
                osd.show(on ? iconCapsFill : iconCaps, "Caps Lock " + (on ? "On" : "Off"), -1);
            }
        }
    }

    // NumLock
    Process {
        id: numProc
        command: ["bash", "-c", "while true; do cat /sys/class/leds/input*::numlock/brightness; sleep 0.1; done"]
        running: true
        stdout: SplitParser {
            onRead: function (line) {
                let currentState = parseInt(line.trim());
                if (currentState === osd.lastNumState)
                    return;
                osd.lastNumState = currentState;
                let on = (currentState === 1);
                osd.show(on ? iconNumFill : iconNum, "Num Lock " + (on ? "On" : "Off"), -1);
            }
        }
    }

    // ================= UI =================
    Rectangle {
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        color: root.colBase
        border.color: root.colRosewater
        border.width: 3

        Row {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 20
            }
            spacing: 14

            IconImage {
                source: Quickshell.iconPath(osd.iconName)
                width: 36
                height: 36
                anchors.verticalCenter: parent.verticalCenter
                // fillMode: Image.PreserveAspectFit
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Text {
                    text: osd.label
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    color: root.colText
                }

                Rectangle {
                    visible: osd.value >= 0
                    width: 220
                    height: 6
                    radius: 3
                    color: root.colOverlay1

                    Rectangle {
                        width: parent.width * (osd.value / 100) >= 220 ? 220 : parent.width * (osd.value / 100)
                        height: parent.height
                        radius: parent.radius
                        color: osd.barColor
                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                            }
                        }
                    }
                }
            }
        }
    }
}
