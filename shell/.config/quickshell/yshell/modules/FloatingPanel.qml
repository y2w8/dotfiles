import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: floatingPanel
    focusable: true

    BackgroundEffect.blurRegion: Region {
        width: 2400
        height: 1350
    }

    exclusiveZone: 0
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    visible: false
  }
