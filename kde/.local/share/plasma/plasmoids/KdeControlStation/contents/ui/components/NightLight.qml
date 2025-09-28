import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.0

import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami 

import "../lib" as Lib

import org.kde.plasma.private.brightnesscontrolplugin


Lib.CardButton {
    id: nightLight

    Layout.fillHeight: true
    Layout.fillWidth: true

    visible: root.showNightLight
    title: i18n("Night Light")
    shouldStickIconSize: true

    property var control: nightLightPage.control

    Kirigami.Icon {
        anchors.fill: parent
        source: {
            if (!control.enabled) {
                return "redshift-status-on"; // not configured: show generic night light icon rather "manually turned off" icon
            } else if (!control.running) {
                return "redshift-status-off";
            } else if (control.daylight && control.targetTemperature != 6500) { // show daylight icon only when temperature during the day is actually modified
                return "redshift-status-day";
            } else {
                return "redshift-status-on";
            }
        }
    }

    onClicked: {
        var pageHeight =  nightLightPage.contentItemHeight + nightLightPage.headerHeight;
        fullRep.togglePage(fullRep.defaultInitialWidth, pageHeight, nightLightPage);
    }
}
