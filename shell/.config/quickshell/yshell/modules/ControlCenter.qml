import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Notifications
import QtQuick.LocalStorage 2.15 as LocalStorage

WlrLayershell {
    id: cc
    layer: WlrLayer.Overlay
    keyboardFocus: WlrKeyboardFocus.OnDemand
    anchors {
        top: true
        right: true
        bottom: true
    }
    exclusiveZone: 0
    color: "transparent"
    implicitWidth: 420
    visible: false

    property bool dnd: false
    property bool recording: false
    property bool showRecordOptions: false
    property bool showWifi: false
    property bool showBluetooth: false
    property var wifiNetworks: []
    property string connectedSsid: ""
    property string platformProfile: ""
    property string passwordSsid: ""
    property var savedConnections: []

    // Persistence properties
    property string recordType: "screen" // "screen" or "region"
    property string recordMonitor: ""
    property bool recordAudio: true

    function getDB() {
        return LocalStorage.LocalStorage.openDatabaseSync("ControlCenterDB", "1.0", "Settings", 100000);
    }

    function saveRecordSettings() {
        let db = getDB();
        db.transaction(function (tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT)");
            tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?, ?)", ["recordType", cc.recordType]);
            tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?, ?)", ["recordMonitor", cc.recordMonitor]);
            tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?, ?)", ["recordAudio", cc.recordAudio ? "true" : "false"]);
        });
    }

    function loadRecordSettings() {
        let db = getDB();
        db.transaction(function (tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT)");
            let rs = tx.executeSql("SELECT key, value FROM settings");
            for (let i = 0; i < rs.rows.length; i++) {
                let item = rs.rows.item(i);
                if (item.key === "recordType")
                    cc.recordType = item.value;
                else if (item.key === "recordMonitor")
                    cc.recordMonitor = item.value;
                else if (item.key === "recordAudio")
                    cc.recordAudio = (item.value === "true");
            }
        });

        // Default monitor if empty
        if (cc.recordMonitor === "" && Quickshell.screens.length > 0) {
            cc.recordMonitor = Quickshell.screens[0].name;
        }
    }

    Component.onCompleted: {
        loadRecordSettings();
    }

    IpcHandler {
        target: "controlcenter"
        function toggle(): void {
            cc.visible = !cc.visible;
            if (cc.visible) {
                savedConnectionsProc.running = true;
            }
        }
    }

    Process {
        id: savedConnectionsProc
        command: ["bash", "-c", "nmcli -t -f NAME connection show"]
        stdout: SplitParser {
            onRead: function (line) {
                cc.savedConnections.push(line.trim());
            }
        }
        onRunningChanged: {
            if (running)
                cc.savedConnections = [];
        }
    }

    // read platform profile
    Process {
        id: profileReadProc
        command: ["tlpctl", "get"]
        running: true
        stdout: SplitParser {
            onRead: function (line) {
                cc.platformProfile = line.trim();
            }
        }
    }

    // write platform profile
    Process {
        id: profileWriteProc
    }

    // wifi scan
    Process {
        id: wifiScanProc
        property var _tempNetworks: []
        command: ["bash", "-c", "nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE dev wifi list 2>/dev/null"]
        stdout: SplitParser {
            onRead: function (line) {
                if (!line.trim())
                    return;
                let parts = line.split(":");
                if (parts.length >= 4) {
                    let ssid = parts[0];
                    if (!ssid)
                        return;
                    let signal = parseInt(parts[1]) || 0;
                    let security = parts[2] || "";
                    let inUse = parts[3]?.trim() === "*";

                    let found = false;
                    for (let i = 0; i < wifiScanProc._tempNetworks.length; i++) {
                        if (wifiScanProc._tempNetworks[i].ssid === ssid) {
                            if (inUse || (!wifiScanProc._tempNetworks[i].connected && signal > wifiScanProc._tempNetworks[i].signal)) {
                                wifiScanProc._tempNetworks[i] = {
                                    ssid: ssid,
                                    signal: signal,
                                    security: security,
                                    connected: inUse
                                };
                            }
                            found = true;
                            break;
                        }
                    }

                    if (!found) {
                        wifiScanProc._tempNetworks.push({
                            ssid: ssid,
                            signal: signal,
                            security: security,
                            connected: inUse
                        });
                    }
                }
            }
        }
        onRunningChanged: {
            if (!running) {
                cc.wifiNetworks = wifiScanProc._tempNetworks;
                wifiScanProc._tempNetworks = [];

                // Update connected SSID
                let connected = cc.wifiNetworks.find(n => n.connected);
                cc.connectedSsid = connected ? connected.ssid : "";
            }
        }
    }

    Timer {
        interval: 15000
        running: cc.visible && cc.showWifi
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            wifiScanProc._tempNetworks = [];
            wifiScanProc.running = true;
            savedConnectionsProc.running = true;
        }
    }

    Process {
        id: wifiActionProc
        onRunningChanged: {
            if (!running) {
                wifiScanProc._tempNetworks = [];
                wifiScanProc.running = true;
                savedConnectionsProc.running = true;
            }
        }
    }

    Process {
        id: recordProc
        onRunningChanged: {
            if (!running) {
                console.log("Record process finished.");
                cc.recording = false;
            } else {
                console.log("Record process started with command: " + recordProc.command);
            }
        }
    }

    Process {
        id: slurpProc
        command: ["slurp", "-f", "%wx%h+%x+%y"]
        stdout: SplitParser {
            onRead: function (line) {
                let region = line.trim();
                console.log("Slurp region selected: " + region);
                if (region) {
                    cc.executeRecording(region);
                } else {
                    cc.recording = false;
                }
            }
        }
        onRunningChanged: {
            if (!running) {
                console.log("Slurp process finished.");
            } else {
                console.log("Slurp process started.");
            }
        }
    }

    Process {
        id: stopRecordProc
        command: ["bash", "-c", "pkill -INT gpu-screen-recorder || pkill -9 gpu-screen-recorder"]
        onRunningChanged: {
            if (!running) {
                console.log("Stop record process finished.");
                cc.recording = false;
            }
        }
    }

    function startRecording() {
        console.log("Starting recording... Type: " + cc.recordType);
        if (cc.recordType === "region") {
            cc.visible = false;
            slurpProc.running = false; // Reset if already running
            slurpProc.running = true;
        } else {
            cc.executeRecording(cc.recordMonitor);
        }
    }

    function executeRecording(target) {
        console.log("Executing recording for target: " + target);
        cc.recording = true;
        let ts = new Date().toISOString().replace(/[:.]/g, "-");
        let out = "/home/y2w8/Videos/Recordings/recording-" + ts + ".mp4";

        let cmd = "gpu-screen-recorder -o \"" + out + "\"";

        if (cc.recordType === "region") {
            cmd += " -w region -region " + target;
        } else {
            cmd += " -w \"" + target + "\"";
        }

        if (cc.recordAudio)
            cmd += " -a default_output";

        console.log("Command: " + cmd);
        recordProc.command = ["bash", "-c", cmd];
        recordProc.running = true;
    }

    function stopRecording() {
        console.log("Stopping recording...");
        stopRecordProc.running = true;
    }

    function cycleProfile() {
        let profiles = ["power-saver", "balanced", "performance"];
        let idx = profiles.indexOf(cc.platformProfile);
        if (idx === -1)
            idx = 1; // Default to balanced if unknown
        let next = profiles[(idx + 1) % profiles.length];
        profileWriteProc.command = ["tlpctl", "set", next];
        profileWriteProc.running = true;
        cc.platformProfile = next;
    }

    function profileIcon() {
        if (cc.platformProfile === "performance")
            return "󰓅";
        if (cc.platformProfile === "power-saver")
            return "󰌪";
        return "󰗑";
    }

    function profileLabel() {
        if (cc.platformProfile === "performance")
            return "Performance";
        if (cc.platformProfile === "power-saver")
            return "Power Saver";
        if (cc.platformProfile === "unsupported")
            return "TLP";
        return "Balanced";
    }

    MouseArea {
        anchors.fill: parent
        onClicked: cc.visible = false
    }

    Rectangle {
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        width: 420
        color: root.colBase
        border.color: root.colRosewater
        border.width: 2

        MouseArea {
            anchors.fill: parent
        }

        Flickable {
            anchors.fill: parent
            anchors.margins: 16
            contentHeight: mainCol.implicitHeight
            clip: true

            Column {
                id: mainCol
                width: parent.width
                spacing: 12

                // ── Quick Settings label ───────────────
                Text {
                    text: "Quick Settings"
                    font.family: root.fontFamily
                    font.pixelSize: 14
                    color: root.colText
                }

                // ── Toggle grid ───────────────────────
                Grid {
                    columns: 2
                    spacing: 8
                    width: parent.width

                    // WiFi
                    ToggleButton {
                        label: cc.connectedSsid !== "" ? cc.connectedSsid : "Wi-Fi"
                        icon: cc.connectedSsid !== "" ? "󰤨" : "󰤭"
                        active: cc.connectedSsid !== ""
                        hasArrow: true
                        arrowOpen: cc.showWifi
                        onToggled: {
                            let p = Qt.createQmlObject('import Quickshell.Io; Process {}', cc);
                            p.command = ["bash", "-c", cc.connectedSsid !== "" ? "nmcli radio wifi off" : "nmcli radio wifi on"];
                            p.running = true;
                        }
                        onArrowClicked: {
                            cc.showWifi = !cc.showWifi;
                            if (cc.showWifi) {
                                cc.wifiNetworks = [];
                                cc.connectedSsid = "";
                                wifiScanProc.running = true;
                                savedConnectionsProc.running = true;
                            }
                        }
                    }

                    // Bluetooth
                    ToggleButton {
                        label: "Bluetooth"
                        icon: {
                            let a = Bluetooth.adapters.values;
                            return a?.length > 0 && a[0].enabled ? "󰂯" : "󰂲";
                        }
                        active: {
                            let a = Bluetooth.adapters.values;
                            return a?.length > 0 && a[0].enabled;
                        }
                        hasArrow: true
                        arrowOpen: cc.showBluetooth
                        onToggled: {
                            let adapter = Bluetooth.adapters.values?.[0];
                            if (adapter)
                                adapter.enabled = !adapter.enabled;
                        }
                        onArrowClicked: cc.showBluetooth = !cc.showBluetooth
                    }

                    // DND
                    ToggleButton {
                        label: "Do Not Disturb"
                        icon: cc.dnd ? "󰂛" : "󰂚"
                        active: cc.dnd
                        onToggled: cc.dnd = !cc.dnd
                    }

                    // Power profile
                    ToggleButton {
                        label: cc.profileLabel()
                        icon: cc.profileIcon()
                        active: cc.platformProfile === "performance"
                        onToggled: cc.cycleProfile()
                    }
                    ToggleButton {
                        label: cc.recording ? "Stop" : "Record"
                        icon: cc.recording ? "󰻃" : "󰑋"
                        active: cc.recording
                        hasArrow: true
                        arrowOpen: cc.showRecordOptions
                        onToggled: {
                            if (cc.recording)
                                cc.stopRecording();
                            else
                                cc.startRecording();
                        }
                        onArrowClicked: cc.showRecordOptions = !cc.showRecordOptions
                    }
                }

                // ── WiFi list ─────────────────────────
                Column {
                    visible: cc.showWifi
                    width: parent.width
                    spacing: 4

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: root.colSurface0
                        opacity: 0.3
                    }

                    RowLayout {
                        width: parent.width

                        Text {
                            text: "Wi-Fi Networks"
                            font.family: root.fontFamily
                            font.pixelSize: 13
                            color: root.colText
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            id: scanBtn
                            width: 60
                            height: 24
                            color: root.colSurface0
                            border.color: root.colSurface0
                            border.width: 1
                            radius: 4

                            Text {
                                anchors.centerIn: parent
                                text: wifiScanProc.running ? "..." : "Scan"
                                font.family: root.fontFamily
                                font.pixelSize: 12
                                color: root.colText
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    cc.wifiNetworks = [];
                                    cc.connectedSsid = "";
                                    wifiScanProc.running = true;
                                }
                            }
                        }
                    }

                    Repeater {
                        model: cc.wifiNetworks

                        Rectangle {
                            width: parent.width
                            height: cc.passwordSsid === modelData.ssid ? 84 : 48
                            color: root.colSurface0
                            border.color: modelData.connected ? root.colRosewater : root.colSurface0
                            border.width: modelData.connected ? 2 : 1
                            radius: 6
                            clip: true

                            Column {
                                anchors.fill: parent
                                spacing: 0

                                Row {
                                    width: parent.width
                                    height: 48
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    spacing: 10

                                    // Margin hack
                                    Item {
                                        width: 1
                                        height: 1
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.signal >= 75 ? "󰤨" : modelData.signal >= 50 ? "󰤥" : modelData.signal >= 25 ? "󰤢" : "󰤟"
                                        font.family: root.fontFamily
                                        font.pixelSize: 18
                                        color: modelData.connected ? root.colRosewater : root.colText
                                    }

                                    Column {
                                        width: parent.width - 134
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 2

                                        Text {
                                            text: modelData.ssid
                                            font.family: root.fontFamily
                                            font.pixelSize: 13
                                            color: root.colText
                                            elide: Text.ElideRight
                                            width: parent.width
                                        }

                                        Text {
                                            text: modelData.signal + "% · " + (modelData.security || "Open")
                                            font.family: root.fontFamily
                                            font.pixelSize: 11
                                            color: root.colSurface0
                                        }
                                    }

                                    Rectangle {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 82
                                        height: 28
                                        color: modelData.connected ? root.colRed : root.colRosewater
                                        radius: 4

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.connected ? "Disconnect" : cc.passwordSsid === modelData.ssid ? "Cancel" : "Connect"
                                            font.family: root.fontFamily
                                            font.pixelSize: 11
                                            color: root.colBase
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (modelData.connected) {
                                                    wifiActionProc.command = ["nmcli", "dev", "disconnect", "wifi"];
                                                    wifiActionProc.running = true;
                                                } else {
                                                    if (cc.passwordSsid === modelData.ssid) {
                                                        cc.passwordSsid = "";
                                                    } else if (modelData.security && modelData.security !== "Open" && !cc.savedConnections.includes(modelData.ssid)) {
                                                        cc.passwordSsid = modelData.ssid;
                                                    } else {
                                                        wifiActionProc.command = ["nmcli", "dev", "wifi", "connect", modelData.ssid];
                                                        wifiActionProc.running = true;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    visible: cc.passwordSsid === modelData.ssid
                                    width: parent.width - 24
                                    height: 32
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: root.colBase
                                    radius: 4
                                    border.color: root.colRosewater
                                    border.width: 1

                                    TextInput {
                                        id: passInput
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 40
                                        verticalAlignment: TextInput.AlignVCenter
                                        echoMode: TextInput.Password
                                        font.family: root.fontFamily
                                        font.pixelSize: 12
                                        color: root.colText
                                        clip: true
                                        onAccepted: {
                                            wifiActionProc.command = ["nmcli", "dev", "wifi", "connect", modelData.ssid, "password", passInput.text];
                                            wifiActionProc.running = true;
                                            cc.passwordSsid = "";
                                        }
                                        onVisibleChanged: if (visible)
                                            forceActiveFocus()
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 8
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "󰄬"
                                        font.family: root.fontFamily
                                        font.pixelSize: 16
                                        color: root.colRosewater
                                        visible: passInput.text.length > 0

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                wifiActionProc.command = ["nmcli", "dev", "wifi", "connect", modelData.ssid, "password", passInput.text];
                                                wifiActionProc.running = true;
                                                cc.passwordSsid = "";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ── Bluetooth list ────────────────────
                Column {
                    visible: cc.showBluetooth
                    width: parent.width
                    spacing: 4

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: root.colSurface0
                        opacity: 0.3
                    }

                    Text {
                        text: "Bluetooth Devices"
                        font.family: root.fontFamily
                        font.pixelSize: 13
                        color: root.colText
                    }

                    Repeater {
                        model: Bluetooth.devices.values ?? []

                        Rectangle {
                            width: parent.width
                            height: 48
                            color: root.colSurface0
                            border.color: modelData.connected ? root.colRosewater : root.colSurface0
                            border.width: modelData.connected ? 2 : 1
                            radius: 6

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 10

                                IconImage {
                                    width: 24
                                    height: 24
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: Quickshell.iconPath(modelData.icon ?? "bluetooth-symbolic")
                                }

                                Column {
                                    width: parent.width - 110
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 2

                                    Text {
                                        text: modelData.name ?? modelData.address
                                        font.family: root.fontFamily
                                        font.pixelSize: 13
                                        color: root.colText
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }

                                    Text {
                                        text: modelData.connected ? "Connected" : modelData.paired ? "Paired" : "Available"
                                        font.family: root.fontFamily
                                        font.pixelSize: 11
                                        color: modelData.connected ? root.colRosewater : root.colSurface0
                                    }
                                }

                                Rectangle {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 82
                                    height: 28
                                    color: modelData.connected ? root.colRed : root.colRosewater
                                    radius: 4

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.connected ? "Disconnect" : "Connect"
                                        font.family: root.fontFamily
                                        font.pixelSize: 11
                                        color: root.colBase
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (modelData.connected)
                                                modelData.disconnectDevice();
                                            else
                                                modelData.connectDevice();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ── Record Settings ───────────────────
                Column {
                    visible: cc.showRecordOptions
                    width: parent.width
                    spacing: 8

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: root.colSurface0
                        opacity: 0.3
                    }

                    Text {
                        text: "Recording Settings"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: root.colText
                    }

                    Row {
                        spacing: 8
                        width: parent.width

                        Rectangle {
                            width: (parent.width - 8) / 2
                            height: 40
                            color: cc.recordType === "screen" ? root.colRosewater : root.colSurface0
                            radius: 4
                            Text {
                                anchors.centerIn: parent
                                text: "Screen"
                                color: cc.recordType === "screen" ? root.colBase : root.colText
                                font.family: root.fontFamily
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    cc.recordType = "screen";
                                    cc.saveRecordSettings();
                                }
                            }
                        }

                        Rectangle {
                            width: (parent.width - 8) / 2
                            height: 40
                            color: cc.recordType === "region" ? root.colRosewater : root.colSurface0
                            radius: 4
                            Text {
                                anchors.centerIn: parent
                                text: "Region"
                                color: cc.recordType === "region" ? root.colBase : root.colText
                                font.family: root.fontFamily
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    cc.recordType = "region";
                                    cc.saveRecordSettings();
                                }
                            }
                        }
                    }

                    Column {
                        visible: cc.recordType === "screen"
                        width: parent.width
                        spacing: 4

                        Repeater {
                            model: Quickshell.screens
                            delegate: Rectangle {
                                width: parent.width
                                height: 36
                                color: cc.recordMonitor === modelData.name ? root.colSurface1 : root.colSurface0
                                border.color: cc.recordMonitor === modelData.name ? root.colRosewater : "transparent"
                                border.width: 1
                                radius: 4

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.name + " (" + modelData.width + "x" + modelData.height + ")"
                                    color: root.colText
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        cc.recordMonitor = modelData.name;
                                        cc.saveRecordSettings();
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 40
                        color: cc.recordAudio ? root.colRosewater : root.colSurface0
                        radius: 4

                        Row {
                            anchors.centerIn: parent
                            spacing: 10
                            Text {
                                text: cc.recordAudio ? "󰓃" : "󰓄"
                                font.family: root.fontFamily
                                font.pixelSize: 18
                                color: cc.recordAudio ? root.colBase : root.colText
                            }
                            Text {
                                text: "Record Audio"
                                color: cc.recordAudio ? root.colBase : root.colText
                                font.family: root.fontFamily
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                cc.recordAudio = !cc.recordAudio;
                                cc.saveRecordSettings();
                            }
                        }
                    }
                }

                // ── Notifications ─────────────────────
                Rectangle {
                    width: parent.width
                    height: 1
                    color: root.colSurface0
                    opacity: 0.3
                }

                RowLayout {
                    width: parent.width

                    Text {
                        text: "Notifications"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        color: root.colText
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        id: clearAllBtn
                        width: 90
                        height: 30
                        color: root.colSurface0
                        border.color: root.colSurface0
                        border.width: 3

                        Text {
                            anchors.centerIn: parent
                            text: "Clear All"
                            font.family: root.fontFamily
                            font.pixelSize: 12
                            color: root.colText
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: notifStore.clearAll()
                        }
                    }
                }

                Repeater {
                    model: notifStore.apps

                    Column {
                        id: appGroup
                        width: parent.width
                        spacing: 4

                        property string appName: modelData.appName
                        property var notifs: modelData.notifs
                        property bool collapsed: false

                        Rectangle {
                            width: parent.width
                            height: 32
                            color: root.colSurface0
                            border.color: root.colSurface0
                            border.width: 3

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                spacing: 8

                                IconImage {
                                    width: 18
                                    height: 18
                                    Layout.alignment: Qt.AlignVCenter
                                    source: Quickshell.iconPath(appGroup.notifs[0]?.appIcon || "preferences-desktop-notification", "preferences-desktop-notification")
                                }

                                Text {
                                    text: appGroup.appName + " (" + appGroup.notifs.length + ")"
                                    font.family: root.fontFamily
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: root.colText
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: appGroup.collapsed ? "󰅂" : "󰅀"
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                    color: root.colSurface0
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: appGroup.collapsed = !appGroup.collapsed
                            }
                        }

                        Column {
                            visible: !appGroup.collapsed
                            width: parent.width
                            spacing: 4

                            Repeater {
                                model: appGroup.notifs

                                delegate: Rectangle {
                                    id: notifItem
                                    width: parent.width
                                    height: notifItemCol.implicitHeight + 20
                                    color: root.colBase
                                    border.color: root.colRosewater
                                    border.width: 1
                                    radius: 4

                                    property var nData: modelData

                                    Column {
                                        id: notifItemCol
                                        anchors {
                                            left: parent.left
                                            right: parent.right
                                            top: parent.top
                                            margins: 10
                                        }
                                        spacing: 3

                                        Text {
                                            text: notifItem.nData.summary || notifItem.nData.appName || "Notification"
                                            font.family: root.fontFamily
                                            font.pixelSize: 13
                                            font.bold: true
                                            color: root.colText
                                            width: parent.width - 20
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: notifItem.nData.body || ""
                                            font.family: root.fontFamily
                                            font.pixelSize: 12
                                            color: root.colSubtext0
                                            width: parent.width - 20
                                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                            maximumLineCount: 3
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Text {
                                        anchors.top: parent.top
                                        anchors.right: parent.right
                                        anchors.margins: 6
                                        text: "×"
                                        font.pixelSize: 16
                                        color: root.colRed

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: notifStore.remove(notifItem.nData)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    QtObject {
        id: notifStore
        property var apps: []

        function add(notif) {
            let existing = apps.findIndex(a => a.appName === notif.appName);
            let newApps = [...apps];

            if (existing >= 0) {
                let app = newApps[existing];
                newApps[existing] = {
                    appName: app.appName,
                    notifs: [notif, ...app.notifs]
                };
            } else {
                newApps.unshift({
                    appName: notif.appName,
                    notifs: [notif]
                });
            }
            apps = newApps;
        }

        function remove(notif) {
            let newApps = [];
            for (let i = 0; i < apps.length; i++) {
                let app = apps[i];
                let idx = app.notifs.indexOf(notif);
                if (idx >= 0) {
                    let newNotifs = [...app.notifs];
                    newNotifs.splice(idx, 1);
                    if (newNotifs.length > 0) {
                        newApps.push({
                            appName: app.appName,
                            notifs: newNotifs
                        });
                    }
                    try {
                        notif.dismiss();
                    } catch (e) {}
                } else {
                    newApps.push(app);
                }
            }
            apps = newApps;
        }

        function clearAll() {
            for (let app of apps)
                for (let n of app.notifs)
                    try {
                        n.dismiss();
                    } catch (e) {}
            apps = [];
        }
    }

    NotificationServer {
        actionsSupported: true
        bodySupported: true
        onNotification: function (notif) {
            notif.tracked = true;
            notifStore.add(notif);
        }
    }
}
