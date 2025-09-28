import QtQuick

Item {
    id: main

    signal modelUpdated

    property var defaultCellHeight: null

    property var maximumWidgetColumns: {
        "avatar": 2,
        "battery": 2,
        "network": 2,
        "dnd": 2,
        "battery": 2,
        "bluetooth": 2,
        "schemes": 2,
        "nightlight": 2,
        "kdeconnect": 2,
        "cmd": 2,
        "screenshot": 2,
        "media": 4,
        "volume": 4,
        "brightness": 4
    }
    property var minimumWidgetColumns: {
        "avatar": 1,
        "battery": 1,
        "network": 1,
        "dnd": 1,
        "battery": 1,
        "bluetooth": 1,
        "schemes": 1,
        "nightlight": 1,
        "kdeconnect": 1,
        "cmd": 1,
        "screenshot": 1,
        "media": 2,
        "volume": 2,
        "brightness": 2
    }


    function move(from, to) {
        [widgetsModel[from], widgetsModel[to]] = [widgetsModel[to], widgetsModel[from]];
        main.modelUpdated()
    }

    function remove(index) {
        widgetsModel.splice(index, 1);
        main.modelUpdated();
    }

    function insert(index, targetIxdex) {

        const widget = widgetsModel[index];

        remove(index);
        widgetsModel.splice(targetIxdex,0, widget);
        main.modelUpdated();
    }

    function add(item) {
        widgetsModel.push(item);
        main.modelUpdated();
    }


    function changeProperty(itemIndex, property, valueType, from, to, actionIndex, queued = false) {

        let target = widgetsModel[itemIndex];

        if(valueType == "size") {
            var isAlreadyLong = target.props["isLongButton"] == true;
            if(!isAlreadyLong){
                target.colSpan = maximumWidgetColumns[target.name];
                target.props.isLongButton = true;
                target.actions[actionIndex].value = true;

                if(target.name === "media") {
                    //back media to normal cellHeight
                    target["height"] = defaultCellHeight;
                    target["rowSpan"] = 1;
                }
            } else {
                target.colSpan = minimumWidgetColumns[target.name];
                target.props.isLongButton = false;
                target.actions[actionIndex].value = false;
                if(target.name === "media") {
                    //Increase media height
                    target["height"] = defaultCellHeight * 2;
                    target["rowSpan"] = 2;
                }
            }
        } else {
            target.props[property] = to;
            target.actions[actionIndex].value = to;
        }

        if (!queued) { main.modelUpdated() }
    }


    property var widgetsModel: [
        {
            name: "avatar",
            displayName: "User Avatar",
            colSpan: 2,
            componentUrl: "../components/UserAvatar.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: true
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: true,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "battery",
            displayName: "Battery",
            colSpan: 1,
            componentUrl: "../components/Battery.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "system",
            displayName: "Session Actions",
            colSpan: 1,
            //height: 55,
            componentUrl: "../components/SystemActions.qml",
            props: {
                flat: false,
                roundedWidget: false
            },

            actions: [

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                }
            ]
 
        },
        {
            name: "network",
            displayName: "Network",
            colSpan: 1,
            componentUrl: "../components/NetworkBtn.qml",
            
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "bluetooth",
            displayName: "Bluetooth",
            colSpan: 1,
            componentUrl: "../components/BluetoothBtn.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "brightness",
            displayName: "Brightness",
            colSpan: 2,
            componentUrl: "../components/BrightnessSlider.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "dnd",
            displayName: "Do not disturb",
            colSpan: 1,
            componentUrl: "../components/DndButton.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "kdeconnect",
            displayName: "KDE Connect",
            colSpan: 1,
            componentUrl: "../components/KDEConnect.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "nightlight",
            displayName: "Night Light",
            colSpan: 1,
            componentUrl: "../components/NightLight.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "schemes",
            displayName: "Color Scheme Switcher",
            colSpan: 1,
            componentUrl: "../components/ColorSchemeSwitcher.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "volume",
            displayName: "Volume",
            colSpan: 4,
            componentUrl: "../components/Volume.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: true
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: true,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "media",
            displayName: "Media Player",
            colSpan: 4,
            componentUrl: "../components/MediaPlayer.qml",
            props: {
                flat: false,
                roundedWidget: false,
                isLongButton: true
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: true,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                }

            ]
        },
        {
            name: "cmd",
            displayName: "Command Run",
            colSpan: 1,
            componentUrl: "../components/CommandRun.qml",
            props: {
                flat: false,
                roundedWidget: false,
                isLongButton: false,
                command: "xdg-open 'https://bit.ly/3yCFTip'",
                title: "cmd",
                showTitle: true,
                icon: "system-run-symbolic"
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                },
                {
                    valueType: "separator"
                },
                {
                    name: "title",
                    checkable: false,
                    value: "cmd",
                    changes: "title",
                    valueType: "entry"
                },
                {
                    name: "Command",
                    checkable: false,
                    value: "spectacle",
                    changes: "command",
                    valueType: "entry"
                },
                {
                    name: "Icon",
                    checkable: false,
                    value: "system-run-symbolic",
                    changes: "icon",
                    valueType: "icon"
                },
                {
                    valueType: "separator"
                },
                {
                    name: "Save",
                    checkable: false,
                    valueType: "save_action"
                }
            ]
        },

        {
            name: "screenshot",
            displayName: "Screenshot",
            colSpan: 1,
            componentUrl: "../components/ScreenshotBtn.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false,
                visible: true
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },

    ]

    property var availableWidgetsModel: [
        {
            name: "avatar",
            displayName: "User Avatar",
            colSpan: 2,
            componentUrl: "../components/UserAvatar.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: true
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: true,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "battery",
            displayName: "Battery",
            colSpan: 1,
            //height: 55,
            componentUrl: "../components/Battery.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "system",
            displayName: "Session Actions",
            colSpan: 1,
            //height: 55,
            componentUrl: "../components/SystemActions.qml",
            props: {
                flat: false,
                roundedWidget: false
            },

            actions: [

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                }
            ]
 
        },
        {
            name: "network",
            displayName: "Network",
            colSpan: 1,
            componentUrl: "../components/NetworkBtn.qml",
            
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "bluetooth",
            displayName: "Bluetooth",
            colSpan: 1,
            componentUrl: "../components/BluetoothBtn.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "brightness",
            displayName: "Brightness",
            colSpan: 2,
            componentUrl: "../components/BrightnessSlider.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "dnd",
            displayName: "Do not disturb",
            colSpan: 1,
            componentUrl: "../components/DndButton.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "kdeconnect",
            displayName: "KDE Connect",
            colSpan: 1,
            componentUrl: "../components/KDEConnect.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "nightlight",
            displayName: "Night Light",
            colSpan: 1,
            componentUrl: "../components/NightLight.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "schemes",
            displayName: "Color Scheme Switcher",
            colSpan: 1,
            componentUrl: "../components/ColorSchemeSwitcher.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "volume",
            displayName: "Volume",
            colSpan: 4,
            componentUrl: "../components/Volume.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: true
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: true,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }


            ]
        },
        {
            name: "media",
            displayName: "Media Player",
            colSpan: 4,
            componentUrl: "../components/MediaPlayer.qml",
            props: {
                flat: false,
                roundedWidget: false,
                isLongButton: true
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: true,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                }

            ]
        },
        {
            name: "cmd",
            displayName: "Command Run",
            colSpan: 1,
            componentUrl: "../components/CommandRun.qml",
            props: {
                flat: false,
                roundedWidget: false,
                isLongButton: false,
                command: "xdg-open 'https://bit.ly/3yCFTip'",
                title: "cmd",
                showTitle: true,
                icon: "system-run-symbolic"
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },

                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                },
                {
                    valueType: "separator"
                },
                {
                    name: "title",
                    checkable: false,
                    value: "cmd",
                    changes: "title",
                    valueType: "entry"
                },
                {
                    name: "Command",
                    checkable: false,
                    value: "spectacle",
                    changes: "command",
                    valueType: "entry"
                },
                {
                    name: "Icon",
                    checkable: false,
                    value: "system-run-symbolic",
                    changes: "icon",
                    valueType: "icon"
                },
                {
                    valueType: "separator"
                },
                {
                    name: "Save",
                    checkable: false,
                    valueType: "save_action"
                }
            ]
        },

        {
            name: "screenshot",
            displayName: "Screenshot",
            colSpan: 1,
            componentUrl: "../components/ScreenshotBtn.qml",
            props: {
                flat: false,
                roundedWidget: false,
                showTitle: true,
                isLongButton: false,
                visible: true
            },

            actions: [

                {
                    name: "Long button",
                    checkable: true,
                    value: false,
                    changes: "isLongButton",
                    valueType: "size"
                },
                {
                    name: "Flat",
                    checkable: true,
                    value: false,
                    changes: "flat",
                    valueType: "bool"
                },
                {
                    name: "Round widget",
                    checkable: true,
                    value: false,
                    changes: "roundedWidget",
                    valueType: "bool"
                },
                {
                    name: "Show title",
                    checkable: true,
                    value: true,
                    changes: "showTitle",
                    valueType: "bool"
                }

            ]
        },

    ]
}