import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
// TODO: set this as wl layer shell

PanelWindow {
    id: wallWin

    WlrLayershell.layer: WlrLayershell.Background
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    property var modelData
    screen: modelData

    property string currentWall: ""
    property string oldWall: ""

    readonly property string configPath: "/home/y2w8/.cache/quickshell_wallpaper"

    Component.onCompleted: {
        createConfigProc.running = true;
    }

    function changeWallpaper(newPath) {
        if (newPath === currentWall || newPath === "")
            return;

        oldWall = currentWall;
        bgOld.opacity = 1.0;

        currentWall = newPath;
        bgCurrent.opacity = 0.0;

        fadeAnimation.restart();

        writeWallProc.command = ["bash", "-c", "echo '" + newPath + "' > '" + configPath + "'"];
        writeWallProc.running = true;
    }

    Process {
        id: createConfigProc
        command: ["bash", "-c", "touch '" + wallWin.configPath + "' && cat '" + wallWin.configPath + "'"]
        stdout: SplitParser {
            onRead: function (line) {
                let path = line.trim();
                if (path !== "") {
                    wallWin.changeWallpaper(path);
                }
                watchWallProc.running = true;
            }
        }
    }

    Process {
        id: watchWallProc
        command: ["inotifywait", "-m", "-e", "close_write", wallWin.configPath]
        stdout: SplitParser {
            onRead: function (line) {
                readCurrentWallProc.running = true;
            }
        }
    }

    Process {
        id: readCurrentWallProc
        command: ["cat", wallWin.configPath]
        stdout: SplitParser {
            onRead: function (line) {
                let path = line.trim();
                if (path !== "" && path !== wallWin.currentWall) {
                    wallWin.changeWallpaper(path);
                }
            }
        }
    }

    Process {
        id: writeWallProc
    }

    ParallelAnimation {
        id: fadeAnimation
        NumberAnimation {
            target: bgCurrent
            property: "opacity"
            to: 1.0
            duration: 400
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: bgOld
            property: "opacity"
            to: 0.0
            duration: 400
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors.fill: parent
        color: root.colBase

        AnimatedImage {
            id: bgOld
            anchors.fill: parent
            source: wallWin.oldWall
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: false
            playing: visible && opacity > 0
        }

        AnimatedImage {
            id: bgCurrent
            anchors.fill: parent
            source: wallWin.currentWall
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            playing: visible && opacity > 0
        }
    }
}
