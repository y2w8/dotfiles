import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Io

FloatingPanel {
    id: clipWin

    ListModel {
        id: clipModel
    }
    property var clipHistory: []
    property string previewText: ""
    property string previewImage: ""
    property bool previewIsImage: false

    // Store the pending raw line to decode once the timer fires
    property string pendingRawLine: ""

    // Debounce Timer to prevent spamming shell processes while scrolling fast
    Timer {
        id: previewDebounceTimer
        interval: 180 // Time in milliseconds to wait before triggering preview
        repeat: false
        onTriggered: {
            if (clipWin.pendingRawLine !== "") {
                clipWin.executeActualPreview(clipWin.pendingRawLine);
            }
        }
    }

    function updateFilter() {
        clipModel.clear();
        let query = searchField.text.trim();
        let regex = null;

        if (query !== "") {
            try {
                regex = new RegExp(query.split("").join(".*"), "i");
            } catch (e) {}
        }

        for (let entry of clipWin.clipHistory) {
            if (!entry)
                continue;
            if (query === "" || (regex && regex.test(entry))) {
                clipModel.append({
                    clipText: entry
                });
            }
        }

        if (clipModel.count > 0) {
            clipList.currentIndex = 0;
            updatePreview(clipModel.get(0).clipText);
        }
    }

    function pasteItem(rawLine) {
        previewDebounceTimer.stop(); // Stop any pending preview requests
        let id = rawLine.split("\t")[0].trim();
        pasteProc.command = ["bash", "-c", "cliphist decode " + id + " | wl-copy"];
        pasteProc.running = true;
        clipWin.visible = false;
    }

    // Intermediary function that caches the selection and restarts the debounce timer
    function updatePreview(rawLine) {
        clipWin.pendingRawLine = rawLine;
        previewDebounceTimer.restart();
    }

    // The actual heavy lifting process execution, now strictly protected by the debounce timer
    function executeActualPreview(rawLine) {
        decodeProc.running = false;
        decodeTextProc.running = false;
        clipWin.previewText = "";
        clipWin.previewImage = "";

        let parts = rawLine.split("\t");
        let id = parts[0].trim();
        let content = parts.slice(1).join("\t").trim();

        if (content.startsWith("[[ binary data") && content.includes("png")) {
            previewIsImage = true;
            decodeProc.command = ["bash", "-c", "cliphist decode " + id + " > /tmp/qs_clip_preview.png"];
            decodeProc.running = true;
        } else {
            previewIsImage = false;
            decodeTextProc.command = ["bash", "-c", "cliphist decode " + id];
            decodeTextProc.running = true;
        }
    }

    Process {
        id: clipProc
        command: ["cliphist", "list"]
        stdout: SplitParser {
            onRead: function (line) {
                if (line.trim() !== "")
                    clipWin.clipHistory.push(line);
            }
        }
        onRunningChanged: {
            if (!running) {
                clipWin.clipHistoryChanged();
                Qt.callLater(updateFilter);
            }
        }
    }

    Process {
        id: pasteProc
    }

    Process {
        id: decodeProc
        onRunningChanged: {
            if (!running && clipWin.previewIsImage) {
                clipWin.previewImage = "file:///tmp/qs_clip_preview.png?" + Date.now();
            }
        }
    }

    Process {
        id: decodeTextProc
        stdout: SplitParser {
            onRead: function (line) {
                clipWin.previewText += line + "\n";
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            previewDebounceTimer.stop();
            clipWin.pendingRawLine = "";
            clipWin.clipHistory = [];
            clipWin.previewText = "";
            clipWin.previewImage = "";
            clipWin.previewIsImage = false;
            searchField.forceActiveFocus();
            searchField.text = "";
            clipProc.running = true;
        } else {
            previewDebounceTimer.stop();
        }
    }

    IpcHandler {
        target: "clipboard"
        function toggle(): void {
            clipWin.visible = !clipWin.visible;
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#80000000"

        MouseArea {
            anchors.fill: parent
            onClicked: clipWin.visible = false
        }

        Rectangle {
            width: 1000
            height: 600
            color: root.colBase
            border.color: root.colRosewater
            border.width: 3
            anchors.centerIn: parent

            Row {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                // ---- LEFT: list ----
                Column {
                    width: 340
                    height: parent.height
                    spacing: 15

                    Rectangle {
                        width: parent.width
                        height: 45
                        color: root.colSurface0
                        border.color: root.colRosewater
                        border.width: 3

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15
                            spacing: 10

                            Text {
                                text: "󰅍"
                                font.family: root.fontFamily
                                font.pixelSize: 18
                                color: root.colText
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            TextInput {
                                id: searchField
                                width: parent.width - 40
                                height: parent.height
                                verticalAlignment: TextInput.AlignVCenter
                                font.family: root.fontFamily
                                font.pixelSize: root.fontSize
                                color: root.colText
                                clip: true
                                onTextChanged: updateFilter()
                                onAccepted: {
                                    let item = clipModel.get(clipList.currentIndex);
                                    if (item)
                                        pasteItem(item.clipText);
                                }
                                Keys.onPressed: function (event) {
                                    if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && event.modifiers & Qt.ControlModifier)) {
                                        if (clipList.currentIndex < clipList.count - 1)
                                            clipList.currentIndex += 1;
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && event.modifiers & Qt.ControlModifier)) {
                                        if (clipList.currentIndex > 0)
                                            clipList.currentIndex -= 1;
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Escape) {
                                        clipWin.visible = false;
                                        event.accepted = true;
                                    }
                                }
                            }
                        }
                    }

                    ListView {
                        id: clipList
                        width: parent.width
                        height: parent.height - 60
                        model: clipModel
                        spacing: 6
                        clip: true
                        highlightFollowsCurrentItem: true
                        highlightMoveDuration: 0
                        highlightResizeDuration: 0

                        onCurrentIndexChanged: {
                            let item = clipModel.get(currentIndex);
                            if (item)
                                updatePreview(item.clipText);
                        }

                        delegate: Item {
                            width: clipList.width
                            height: itemRect.height
                            readonly property bool isCurrent: ListView.isCurrentItem

                            Rectangle {
                                id: itemRect
                                width: parent.width
                                height: itemText.height + 20
                                color: isCurrent ? root.colSurface1 : "transparent"

                                Text {
                                    id: itemText
                                    anchors {
                                        left: parent.left
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                        leftMargin: 15
                                        rightMargin: 15
                                    }
                                    text: {
                                        let parts = model.clipText.split("\t");
                                        return parts.length > 1 ? parts.slice(1).join("\t") : model.clipText;
                                    }
                                    font.family: root.fontFamily
                                    font.pixelSize: 16
                                    color: root.colText
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    maximumLineCount: 3
                                    elide: Text.ElideRight
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: clipList.currentIndex = index
                                    onClicked: pasteItem(model.clipText)
                                }
                            }
                        }
                    }
                }

                // ---- DIVIDER ----
                Rectangle {
                    width: 1
                    height: parent.height
                    color: root.colSurface1
                    opacity: 0.4
                }

                // ---- RIGHT: preview ----
                Rectangle {
                    width: parent.width - 340 - 15 - 1
                    height: parent.height
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        anchors.margins: 10
                        visible: clipWin.previewIsImage && clipWin.previewImage !== ""
                        source: clipWin.previewImage
                        fillMode: Image.PreserveAspectFit
                        cache: false
                    }

                    Flickable {
                        anchors.fill: parent
                        anchors.margins: 10
                        visible: !clipWin.previewIsImage && clipWin.previewText !== ""
                        contentHeight: previewLabel.height
                        clip: true

                        Text {
                            id: previewLabel
                            width: parent.width
                            text: clipWin.previewText
                            font.family: root.fontFamily
                            font.pixelSize: root.fontSize
                            color: root.colText
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: clipWin.previewText === "" && clipWin.previewImage === ""
                        text: "No preview"
                        font.family: root.fontFamily
                        font.pixelSize: root.fontSize
                        color: root.colOverlay2
                        opacity: 0.5
                    }
                }
            }
        }
    }
}
