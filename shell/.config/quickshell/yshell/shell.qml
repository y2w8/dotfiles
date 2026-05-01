//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Niri 0.1
import "./modules/bar/"
import "./modules/"
import "./services"

ShellRoot {
    id: root
    readonly property var systemInfo: SystemInfo

    // Theme colors
    readonly property color colRosewater: "#f5e0dc"
    readonly property color colFlamingo: "#f2cdcd"
    readonly property color colPink: "#f5c2e7"
    readonly property color colMauve: "#cba6f7"
    readonly property color colRed: "#f38ba8"
    readonly property color colMaroon: "#eba0a0"
    readonly property color colPeach: "#fab387"
    readonly property color colYellow: "#f9e2af"
    readonly property color colGreen: "#a6e3a1"
    readonly property color colTeal: "#94e2d5"
    readonly property color colSky: "#89dceb"
    readonly property color colSapphire: "#74c7ec"
    readonly property color colBlue: "#89b4fa"
    readonly property color colLavender: "#b4befe"

    // Text & Foregrounds
    readonly property color colText: "#cdd6f4"
    readonly property color colSubtext1: "#bac2de"
    readonly property color colSubtext0: "#a6adc8"
    readonly property color colOverlay2: "#9399b2"
    readonly property color colOverlay1: "#7f849c"
    readonly property color colOverlay0: "#6c7086"

    // UI & Backgrounds
    readonly property color colSurface2: "#585b70"
    readonly property color colSurface1: "#45475a"
    readonly property color colSurface0: "#313244"
    readonly property color colBase: "#1e1e2e"
    readonly property color colMantle: "#181825"
    readonly property color colCrust: "#11111b"

    // Font
    property string fontFamily: "BigBlueTerm437 Nerd Font"
    property int fontSize: 18

    // Animation
    property int colorAnimation: 150

    // System info properties
    property string kernelVersion: "Linux"
    property int cpuUsage: 0
    property int memUsage: 0
    property int diskUsage: 0
    property int volumeLevel: 0

    // CPU tracking
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.info("Connected to niri")
        onErrorOccurred: function (error) {
            console.error("Niri error:", error);
        }
    }
    LockScreen {}
    Notification {}
    ControlCenter {}
    AppLauncher {}
    Clipboard {}
    WallpaperSwitcher {}

    // Root-level IPC handler so it is ALWAYS visible to 'qs -c yshell ipc show'
    IpcHandler {
        target: "sessionlock"
        function lock(): void {
            console.log("IPC Signal Received: Locking session...");
            if (!lockScreen.locked) {
                lockScreen.locked = true;
            }
        }
    }

    Variants {
        model: Quickshell.screens
        Wallpaper {}
    }
    Variants {
        model: Quickshell.screens
        Bar {}
    }

    Variants {
        model: Quickshell.screens
        Osd {}
    }
}
