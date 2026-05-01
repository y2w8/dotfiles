import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Io

FloatingPanel {
    id: wallSwitchWin

    ListModel {
        id: wallModel
    }

    // Configuration properties
    readonly property string wallpaperDir: "/home/y2w8/Pictures/Wallpapers"
    readonly property string configPath: "/home/y2w8/.cache/quickshell_wallpaper"

    property var wallHistory: []
    property string previewImage: ""
    property string pendingRawPath: ""

    // Debounce Timer to prevent heavy file I/O operations while scrolling fast
    Timer {
        id: previewDebounceTimer
        interval: 150
        repeat: false
        onTriggered: {
            if (wallSwitchWin.pendingRawPath !== "") {
                wallSwitchWin.previewImage = "file://" + wallSwitchWin.pendingRawPath;
            }
        }
    }

    // Fuzzy matching and filtering logic (Case-Insensitive)
    function updateFilter() {
        wallModel.clear();
        let query = searchField.text.trim();
        let regex = null;

        if (query !== "") {
            try {
                regex = new RegExp(query.split("").join(".*"), "i");
            } catch (e) {}
        }

        for (let path of wallSwitchWin.wallHistory) {
            if (!path)
                continue;
            // Extract filename from full path for clean regex matching
            let filename = path.substring(path.lastIndexOf('/') + 1);
            if (query === "" || (regex && regex.test(filename))) {
                wallModel.append({
                    fullPath: path,
                    fileName: filename
                });
            }
        }

        if (wallModel.count > 0) {
            wallList.currentIndex = 0;
            updatePreview(wallModel.get(0).fullPath);
        } else {
            wallSwitchWin.previewImage = "";
        }
    }

    // Writes the selected wallpaper path to the shared config file trigger
    function applyWallpaper(path) {
        previewDebounceTimer.stop();
        writeWallProc.command = ["bash", "-c", "echo '" + path + "' > '" + configPath + "'"];
        writeWallProc.running = true;
        wallSwitchWin.visible = false;
    }

    // Intermediary function that caches the selection and restarts the debounce timer
    function updatePreview(path) {
        wallSwitchWin.pendingRawPath = path;
        previewDebounceTimer.restart();
    }

    // Process to scan and index all image files within the targeted folder
    Process {
        id: scanWallsProc
        command: ["find", wallSwitchWin.wallpaperDir, "-type", "f", "-regextype", "posix-extended", "-regex", ".*\\.(png|jpg|jpeg|gif|webp)"]
        stdout: SplitParser {
            onRead: function (line) {
                if (line.trim() !== "")
                    wallSwitchWin.wallHistory.push(line.trim());
            }
        }
        onRunningChanged: {
            if (!running) {
                wallSwitchWin.wallHistoryChanged();
                Qt.callLater(updateFilter);
            }
        }
    }

    // Process to write changes asynchronously to the shared cache
    Process {
        id: writeWallProc
    }

    onVisibleChanged: {
        if (visible) {
            previewDebounceTimer.stop();
            wallSwitchWin.pendingRawPath = "";
            wallSwitchWin.wallHistory = [];
            wallSwitchWin.previewImage = "";
            searchField.forceActiveFocus();
            searchField.text = "";
            scanWallsProc.running = true;
        } else {
            previewDebounceTimer.stop();
        }
    }

    IpcHandler {
        target: "wallpaperswitcher"
        function toggle(): void {
            wallSwitchWin.visible = !wallSwitchWin.visible;
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#80000000"

        MouseArea {
            anchors.fill: parent
            onClicked: wallSwitchWin.visible = false
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

                // ---- LEFT: Wallpaper List Layout ----
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
                                text: " "
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
                                    let item = wallModel.get(wallList.currentIndex);
                                    if (item)
                                        applyWallpaper(item.fullPath);
                                }
                                Keys.onPressed: function (event) {
                                    if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && event.modifiers & Qt.ControlModifier)) {
                                        if (wallList.currentIndex < wallList.count - 1)
                                            wallList.currentIndex += 1;
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && event.modifiers & Qt.ControlModifier)) {
                                        if (wallList.currentIndex > 0)
                                            wallList.currentIndex -= 1;
                                        event.accepted = true;
                                    } else if (event.key === Qt.Key_Escape) {
                                        wallSwitchWin.visible = false;
                                        event.accepted = true;
                                    }
                                }
                            }
                        }
                    }

                    ListView {
                        id: wallList
                        width: parent.width
                        height: parent.height - 60
                        model: wallModel
                        spacing: 6
                        clip: true
                        highlightFollowsCurrentItem: true

                        // Instant transition snappiness optimizations
                        highlightMoveDuration: 0
                        highlightResizeDuration: 0

                        onCurrentIndexChanged: {
                            let item = wallModel.get(currentIndex);
                            if (item)
                                updatePreview(item.fullPath);
                        }

                        delegate: Item {
                            width: wallList.width
                            height: 50
                            readonly property bool isCurrent: ListView.isCurrentItem

                            Rectangle {
                                anchors.fill: parent
                                color: isCurrent ? root.colSurface1 : "transparent"

                                Text {
                                    anchors {
                                        left: parent.left
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                        leftMargin: 15
                                        rightMargin: 15
                                    }
                                    text: model.fileName
                                    font.family: root.fontFamily
                                    font.pixelSize: root.fontSize
                                    color: root.colText
                                    elide: Text.ElideRight
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: wallList.currentIndex = index
                                    onClicked: applyWallpaper(model.fullPath)
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

                // ---- RIGHT: Live Preview Viewport ----
                Rectangle {
                    width: parent.width - 340 - 15 - 1
                    height: parent.height
                    color: "transparent"

                    AnimatedImage {
                        id: previewViewport
                        anchors.fill: parent
                        anchors.margins: 10
                        visible: wallSwitchWin.previewImage !== ""
                        source: wallSwitchWin.previewImage
                        fillMode: Image.PreserveAspectFit

                        // Enforce caching for the preview layer to allow sequential GIF frame cycles
                        cache: false

                        // ⚡ Robust playing state tethered directly to the source ready status ⚡
                        playing: wallSwitchWin.visible && (status === AnimatedImage.Ready)

                        // Force clear the frame buffer on source alteration to prevent frozen frames
                        onSourceChanged: {
                            if (source == "") {
                                previewViewport.currentFrame = 0;
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: wallSwitchWin.previewImage === ""
                        text: "No wallpaper preview available"
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
