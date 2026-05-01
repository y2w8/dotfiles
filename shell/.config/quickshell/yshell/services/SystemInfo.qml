pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

QtObject {
    id: root

    // --- Pipewire ---
    property var _tracker: PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }
    function increase_vol(){
          Pipewire.defaultAudioSink.audio.volume = Pipewire.defaultAudioSink.audio.volume + 0.05
    }
    function decrease_vol(){
          Pipewire.defaultAudioSink.audio.volume = Pipewire.defaultAudioSink.audio.volume - 0.05
    }
    function mute_vol(){
          Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
    }

    // Output volume — read directly from Pipewire
    property real volOut: Pipewire.defaultAudioSink?.audio.volume ?? 0
    property bool volOutMuted: Pipewire.defaultAudioSink?.audio.muted ?? false

    // Input volume
    property real volIn: Pipewire.defaultAudioSource?.audio.volume ?? 0
    property bool volInMuted: Pipewire.defaultAudioSource?.audio.muted ?? false

    // CPU
    property int cpuUsage: 0
    property var _lastIdle: 0
    property var _lastTotal: 0

    // Memory
    property real memUsed: 0
    property real memTotal: 0

    // Disk
    property int diskUsed: 0

    // Temperature
    property int temp: 0

    // Network
    property string netIcon: ""
    property string netType: ""

    // Music
    property string musicTitle: ""

    // --- CPU ---
    property var _cpuProc: Process {
        command: ["bash", "-c", "head -1 /proc/stat"]
        running: true
        stdout: SplitParser {
            onRead: function(line) {
                let parts = line.trim().split(/\s+/)
                let idle = parseInt(parts[4])
                let total = parts.slice(1).reduce((a, b) => a + parseInt(b), 0)
                let diffIdle = idle - root._lastIdle
                let diffTotal = total - root._lastTotal
                if (diffTotal > 0)
                    root.cpuUsage = Math.round((1 - diffIdle / diffTotal) * 100)
                root._lastIdle = idle
                root._lastTotal = total
            }
        }
    }
    property var _cpuTimer: Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: root._cpuProc.running = true
    }

    // --- Memory ---
    property var _memProc: Process {
        command: ["bash", "-c", "free -b | awk '/^Mem:/{print $3, $2}'"]
        running: true
        stdout: SplitParser {
            onRead: function(line) {
                let parts = line.trim().split(" ")
                root.memUsed = (parseFloat(parts[0]) / 1073741824).toFixed(1)
                root.memTotal = (parseFloat(parts[1]) / 1073741824).toFixed(1)
            }
        }
    }
    property var _memTimer: Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: root._memProc.running = true
    }

    // --- Disk ---
    property var _diskProc: Process {
        command: ["bash", "-c", "df / | awk 'NR==2{print $5}' | tr -d '%'"]
        running: true
        stdout: SplitParser {
            onRead: function(line) { root.diskUsed = parseInt(line.trim()) }
        }
    }
    property var _diskTimer: Timer {
        interval: 30000; running: true; repeat: true
        onTriggered: root._diskProc.running = true
    }

    // --- Temperature ---
    property var _tempProc: Process {
        command: ["bash", "-c", "cat /sys/class/thermal/thermal_zone4/temp"]
        running: true
        stdout: SplitParser {
            onRead: function(line) { root.temp = Math.round(parseInt(line.trim()) / 1000) }
        }
    }
    property var _tempTimer: Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: root._tempProc.running = true
    }

    // --- Network ---
    property var _netProc: Process {
        command: ["bash", "-c", "ip route get 8.8.8.8 2>/dev/null | awk '{print $5}' | head -1"]
        running: true
        stdout: SplitParser {
            onRead: function(line) {
                let iface = line.trim()
                if (iface.startsWith("w")) { root.netIcon = ""; root.netType = "wifi" }
                else if (iface.startsWith("e")) { root.netIcon = "󰈀"; root.netType = "ethernet" }
                else { root.netIcon = ""; root.netType = "none" }
            }
        }
    }
    property var _netTimer: Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: root._netProc.running = true
    }

    // --- Music ---
    property var _musicProc: Process {
        command: ["bash", "-c", "playerctl metadata --format='{{ title }}' 2>/dev/null | cut -c1-40"]
        running: true
        stdout: SplitParser {
            onRead: function(line) { root.musicTitle = line.trim() }
        }
    }
    property var _musicTimer: Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: root._musicProc.running = true
    }
}
