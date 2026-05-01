import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

RowLayout {
    id: privacyRoot
    spacing: 8

    PwObjectTracker {
        objects: Pipewire.ready && Pipewire.nodes?.values ? Pipewire.nodes.values.filter(node => !node.isStream) : []
    }

    property bool micInUse: {
        if (!Pipewire.ready || !Pipewire.nodes?.values)
            return false;

        let vals = Pipewire.nodes.values;
        for (let i = 0; i < vals.length; i++) {
            let node = vals[i];
            if (!node)
                continue;

            if ((node.type & PwNodeType.AudioInStream) === PwNodeType.AudioInStream) {
                if (!looksLikeSystemVirtualMic(node)) {
                    if (node.audio && node.audio.muted) {
                        return false;
                    }
                    return true;
                }
            }
        }
        return false;
    }

    property bool camInUse: {
        if (!Pipewire.ready || !Pipewire.nodes?.values) {
            return false;
        }

        for (let i = 0; i < Pipewire.nodes.values.length; i++) {
            const node = Pipewire.nodes.values[i];
            if (!node || !node.ready) {
                continue;
            }

            if (node.properties && node.properties["media.class"] === "Stream/Input/Video") {
                if (node.properties["stream.is-live"] === "true") {
                    return true;
                }
            }
        }
        return false;
    }

    property bool screenInUse: {
        if (!Pipewire.ready || !Pipewire.nodes?.values)
            return false;

        let vals = Pipewire.nodes.values;
        for (let i = 0; i < vals.length; i++) {
            let node = vals[i];
            if (!node || !node.ready)
                continue;

            if ((node.type & PwNodeType.VideoSource) === PwNodeType.VideoSource) {
                if (looksLikeScreencast(node))
                    return true;
            }

            if (node.properties && node.properties["media.class"] === "Stream/Output/Video") {
                if (looksLikeScreencast(node))
                    return true;
            }

            if (node.properties && node.properties["media.class"] === "Stream/Input/Audio") {
                let mediaName = (node.properties["media.name"] || "").toLowerCase();
                let appName = (node.properties["application.name"] || "").toLowerCase();

                if (mediaName.includes("desktop") || appName.includes("screen") || appName === "obs") {
                    if (node.properties["stream.is-live"] === "true") {
                        if (node.audio && node.audio.muted) {
                            return false;
                        }
                        return true;
                    }
                }
            }
        }
        return false;
    }

    function looksLikeSystemVirtualMic(node) {
        if (!node)
            return false;
        let name = (node.name || "").toLowerCase();
        let mediaName = (node.properties && node.properties["media.name"] || "").toLowerCase();
        let appName = (node.properties && node.properties["application.name"] || "").toLowerCase();
        let combined = name + " " + mediaName + " " + appName;
        return /cava|monitor|system/.test(combined);
    }

    function looksLikeScreencast(node) {
        if (!node)
            return false;
        let appName = (node.properties && node.properties["application.name"] || "").toLowerCase();
        let nodeName = (node.name || "").toLowerCase();
        let mediaName = (node.properties && node.properties["media.name"] || "").toLowerCase();
        let combined = appName + " " + nodeName + " " + mediaName;
        return /xdg-desktop-portal|xdpw|screencast|screen-cast|screen|gnome shell|kwin|obs|niri/.test(combined);
    }

    component PrivacyIcon: Text {
        id: iconTemplate
        property bool active: false

        visible: active || opacity > 0.01

        opacity: active ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }

        scale: active ? 1.0 : 0.5
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack
            }
        }

        Layout.preferredWidth: active ? implicitWidth : 0
        Behavior on Layout.preferredWidth {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }

        font.family: root.fontFamily
        font.pixelSize: 18
        color: root.colRed

        clip: true
    }

    PrivacyIcon {
        active: privacyRoot.micInUse
        text: "󰍬"
    }

    PrivacyIcon {
        active: privacyRoot.camInUse
        text: "󰄀"
    }

    PrivacyIcon {
        active: privacyRoot.screenInUse
        text: "󰻃"
    }
}
