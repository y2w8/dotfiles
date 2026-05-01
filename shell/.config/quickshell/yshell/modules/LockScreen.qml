import QtQuick
import QtQuick.Effects // تأثيرات برمجية آمنة داخل التطبيق نفسه بدون تدخل الكومبوزيتر
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

WlSessionLock {
    id: sessionLock
    locked: false

    WlSessionLockSurface {
        id: lockSurface
        color: root.colBase

        AnimatedImage {
            id: bgImage
            anchors.fill: parent
            source: ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            visible: false
        }

        MultiEffect {
            id: blurEffect
            anchors.fill: parent
            source: bgImage

            blurEnabled: true
            blur: 0.7

            brightness: -0.1
        }

        readonly property string configPath: "/home/y2w8/.cache/quickshell_wallpaper"

        Component.onCompleted: {
            readWallOnInit.running = true;
            passField.forceActiveFocus();
        }

        Process {
            id: readWallOnInit
            command: ["cat", lockSurface.configPath]
            stdout: SplitParser {
                onRead: function (line) {
                    let path = line.trim();
                    if (path !== "") {
                        bgImage.source = path;
                    }
                    watchWallProc.running = true;
                }
            }
        }

        Process {
            id: watchWallProc
            command: ["inotifywait", "-m", "-e", "close_write", lockSurface.configPath]
            stdout: SplitParser {
                onRead: function (line) {
                    readCurrentWallProc.running = true;
                }
            }
        }

        Process {
            id: readCurrentWallProc
            command: ["cat", lockSurface.configPath]
            stdout: SplitParser {
                onRead: function (line) {
                    let path = line.trim();
                    if (path !== "" && bgImage.source != path) {
                        bgImage.source = path;
                    }
                }
            }
        }
        property bool isLocked: sessionLock.locked

        PamContext {
            id: pam
            config: "login"

            property string actualErrorReason: "Authentication failed"

            onPamMessage: {
                console.log("PAM Event -> responseRequired:", pam.responseRequired, "messageIsError:", pam.messageIsError, "message:", pam.message);

                if (pam.messageIsError) {
                    if (pam.message && pam.message.trim() !== "") {
                        pam.actualErrorReason = pam.message.trim();
                    }
                } else if (pam.responseRequired) {
                    console.log("PAM is waiting for input. Sending password from passField...");
                    pam.respond(passField.text);
                }
            }

            onCompleted: function (result) {
                console.log("PAM Completed -> Result Enum:", result);

                if (result === PamResult.Success) {
                    sessionLock.locked = false;
                    passField.text = "";
                    errorText.visible = false;
                    pam.actualErrorReason = "Authentication failed";
                } else {
                    passField.text = "";

                    errorText.text = pam.actualErrorReason;
                    errorText.visible = true;

                    shakeAnimation.start();
                    passField.forceActiveFocus();
                }
            }
        }

        // طبقة واجهة القفل الفوقية 🎨
        Rectangle {
            anchors.fill: parent
            color: "transparent"

            Rectangle {
                width: 400
                height: 320
                anchors.centerIn: parent
                color: root.colBase
                border.color: root.colRosewater
                border.width: 3

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    // Clock Component
                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 4

                        Text {
                            id: timeText
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontFamily
                            font.pixelSize: 52
                            color: root.colText
                            font.bold: true
                        }

                        Text {
                            id: dateText
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontFamily
                            font.pixelSize: 16
                            color: root.colOverlay2
                        }

                        Timer {
                            interval: 1000
                            running: sessionLock.locked
                            repeat: true
                            triggeredOnStart: true
                            onTriggered: {
                                let now = new Date();
                                let h = now.getHours().toString().padStart(2, "0");
                                let m = now.getMinutes().toString().padStart(2, "0");
                                let s = now.getSeconds().toString().padStart(2, "0");
                                timeText.text = h + ":" + m + ":" + s;
                                dateText.text = now.toLocaleDateString(Qt.locale(), "dddd, MMMM d yyyy");
                            }
                        }
                    }

                    // Decorative Separator
                    Rectangle {
                        width: 340
                        height: 1
                        color: root.colSurface1
                        opacity: 0.4
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // Credentials Entry Anchor
                    Column {
                        id: passColumn
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 8

                        Rectangle {
                            width: 340
                            height: 45
                            color: root.colSurface0
                            border.color: root.colRosewater
                            border.width: passField.activeFocus ? 3 : 0

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 15
                                anchors.rightMargin: 15
                                spacing: 10

                                Text {
                                    text: ""
                                    font.family: root.fontFamily
                                    font.pixelSize: 18
                                    color: root.colOverlay2
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                TextInput {
                                    id: passField
                                    width: parent.width - 40
                                    height: parent.height
                                    verticalAlignment: TextInput.AlignVCenter
                                    font.family: root.fontFamily
                                    font.pixelSize: root.fontSize - 6
                                    color: root.colText
                                    echoMode: TextInput.Password
                                    passwordCharacter: "*"
                                    clip: true
                                    // focus: sessionLock.locked
                                    focus: true

                                    onAccepted: {
                                        errorText.visible = false;
                                        pam.start();
                                    }

                                    Keys.onEscapePressed: {
                                        passField.text = "";
                                        errorText.visible = false;
                                    }
                                }
                            }
                        }

                        Text {
                            id: errorText
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Wrong password"
                            font.family: root.fontFamily
                            font.pixelSize: 13
                            color: root.colRed
                            visible: false
                        }
                    }
                }
            }

            SequentialAnimation {
                id: shakeAnimation
                NumberAnimation {
                    target: passColumn
                    property: "x"
                    to: passColumn.x + 10
                    duration: 50
                }
                NumberAnimation {
                    target: passColumn
                    property: "x"
                    to: passColumn.x - 10
                    duration: 50
                }
                NumberAnimation {
                    target: passColumn
                    property: "x"
                    to: passColumn.x + 8
                    duration: 50
                }
                NumberAnimation {
                    target: passColumn
                    property: "x"
                    to: passColumn.x - 8
                    duration: 50
                }
                NumberAnimation {
                    target: passColumn
                    property: "x"
                    to: 0
                    duration: 50
                }
            }
        }
    }
}
