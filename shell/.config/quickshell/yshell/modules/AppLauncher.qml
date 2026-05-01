import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick.LocalStorage 2.15 as LocalStorage

FloatingPanel {
    id: launcherWin
    ListModel {
        id: fuzzyModel
    }

    function getDatabase() {
        return LocalStorage.LocalStorage.openDatabaseSync("CaelestiaLauncherDB", "1.0", "App Frequency Storage", 100000);
    }

    function initDatabase() {
        let db = getDatabase();
        db.transaction(function (tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS app_stats (app_name TEXT PRIMARY KEY, open_count INTEGER)");
        });
    }

    function recordAppOpen(appName) {
        let db = getDatabase();
        db.transaction(function (tx) {
            // فحص هل التطبيق موجود مسبقاً؟
            let rs = tx.executeSql("SELECT open_count FROM app_stats WHERE app_name=?", [appName]);
            if (rs.rows.length > 0) {
                let newCount = rs.rows.item(0).open_count + 1;
                tx.executeSql("UPDATE app_stats SET open_count=? WHERE app_name=?", [newCount, appName]);
            } else {
                tx.executeSql("INSERT INTO app_stats VALUES(?, ?)", [appName, 1]);
            }
        });
    }

    function getAppFrequencies() {
        initDatabase();
        let db = getDatabase();
        let freqs = {};
        db.transaction(function (tx) {
            let rs = tx.executeSql("SELECT app_name, open_count FROM app_stats");
            for (let i = 0; i < rs.rows.length; i++) {
                let item = rs.rows.item(i);
                freqs[item.app_name] = item.open_count;
            }
        });
        return freqs;
    }

    function launchByName(name) {
        for (let entry of DesktopEntries.applications.values) {
            if (entry && entry.name === name) {
                recordAppOpen(name);
                entry.execute();
                launcherWin.visible = false;
                break;
            }
        }
    }

    function updateFilter() {
        fuzzyModel.clear();
        let query = searchField.text.trim().toLowerCase();
        let apps = DesktopEntries.applications.values;

        if (!apps)
            return;

        let appFreqs = getAppFrequencies();
        let filteredApps = [];

        for (let entry of apps) {
            if (!entry || !entry.name)
                continue;

            let name = entry.name;
            let icon = entry.icon ?? "image-missing";
            let lowerName = name.toLowerCase();

            let openCount = appFreqs[name] ?? 0;

            if (query === "") {
                filteredApps.push({
                    name: name,
                    icon: icon,
                    score: 0,
                    openCount: openCount
                });
                continue;
            }

            let score = 0;
            let queryIdx = 0;
            let lastMatchIdx = -1;
            let consecutiveMatches = 0;

            for (let i = 0; i < lowerName.length; i++) {
                if (lowerName[i] === query[queryIdx]) {
                    if (lastMatchIdx !== -1 && i === lastMatchIdx + 1) {
                        consecutiveMatches++;
                        score += (10 + consecutiveMatches * 5);
                    } else {
                        consecutiveMatches = 0;
                        score += 5;
                    }

                    if (queryIdx === 0 && i === 0) {
                        score += 50;
                    }

                    lastMatchIdx = i;
                    queryIdx++;

                    if (queryIdx === query.length)
                        break;
                }
            }

            if (queryIdx === query.length) {
                score -= (name.length - query.length);

                filteredApps.push({
                    name: name,
                    icon: icon,
                    score: score,
                    openCount: openCount
                });
            }
        }

        filteredApps.sort(function (a, b) {
            if (b.score !== a.score) {
                return b.score - a.score;
            }

            if (b.openCount !== a.openCount) {
                return b.openCount - a.openCount;
            }

            return a.name.localeCompare(b.name);
        });

        for (let app of filteredApps) {
            fuzzyModel.append({
                appName: app.name,
                appIcon: app.icon
            });
        }

        if (fuzzyModel.count > 0) {
            appList.currentIndex = 0;
        }
    }

    onVisibleChanged: {
        if (visible) {
            searchField.forceActiveFocus();
            searchField.text = "";
            updateFilter();
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            launcherWin.visible = !launcherWin.visible;
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#80000000"

        MouseArea {
            anchors.fill: parent
            onClicked: launcherWin.visible = false
        }

        Rectangle {
            width: 500
            height: 600
            color: root.colBase
            border.color: root.colRosewater
            border.width: 3
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                Rectangle {
                    width: parent.width
                    height: 45
                    color: root.colSurface0
                    border.color: searchField.activeFocus ? root.colRosewater : root.colSurface0
                    border.width: 3

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        spacing: 10

                        Text {
                            text: ""
                            color: root.colText
                            font.pixelSize: root.fontSize
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
                                let item = fuzzyModel.get(appList.currentIndex);
                                if (item)
                                    launchByName(item.appName);
                            }

                            Keys.onPressed: function (event) {
                                if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && event.modifiers & Qt.ControlModifier)) {
                                    if (appList.currentIndex < appList.count - 1)
                                        appList.currentIndex += 1;
                                    event.accepted = true;
                                } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && event.modifiers & Qt.ControlModifier)) {
                                    if (appList.currentIndex > 0)
                                        appList.currentIndex -= 1;
                                    event.accepted = true;
                                } else if (event.key === Qt.Key_Escape) {
                                    launcherWin.visible = false;
                                    event.accepted = true;
                                }
                            }
                        }
                    }
                }

                ListView {
                    id: appList
                    width: parent.width
                    height: parent.height - 60
                    model: fuzzyModel
                    spacing: 6
                    clip: true
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 0
                    highlightResizeDuration: 0

                    delegate: Item {
                        width: appList.width
                        height: 50

                        readonly property bool isCurrent: ListView.isCurrentItem

                        Rectangle {
                            anchors.fill: parent
                            color: isCurrent ? root.colSurface1 : "transparent"

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 15
                                spacing: 15

                                IconImage {
                                    width: 32
                                    height: 32
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: Quickshell.iconPath(model.appIcon, "question")
                                }

                                Text {
                                    text: model.appName
                                    font.family: root.fontFamily
                                    font.pixelSize: root.fontSize
                                    color: root.colText
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onContainsMouseChanged: {
                                    if (containsMouse)
                                        appList.currentIndex = index;
                                }
                                onClicked: launchByName(model.appName)
                            }
                        }
                    }
                }
            }
        }
    }
}
