import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.workspace.components as WorkspaceComponents
import "components" as Components

Item {
  id: row

  property string totalActive: "0"
  property string total: "0"
  property bool isActive: false
  property bool onRefresh: false

  property string iconDocker: "logo-docker.svg"
  property string iconRefresh: "refresh.svg"

  property bool separateResult: plasmoid.configuration.separateResult
  property string separator: plasmoid.configuration.separator

  property bool mainDot: plasmoid.configuration.mainDot
  property bool mainDotUseCustomColor: plasmoid.configuration.mainDotUseCustomColor
  property string mainDotColor: plasmoid.configuration.mainDotColor
  property int mainDotPosition: parseInt(plasmoid.configuration.mainDotPosition, 10)

  property bool isPanelVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
  readonly property bool inTray: parent.objectName === "org.kde.desktop-CompactApplet"

  property real itemSize: Math.min(row.height, row.width)

  // updates the icon according to the refresh status
  function updateUi(refresh: bool) {
    onRefresh = refresh
    if (refresh) {
      icon.source=iconRefresh
    } else {
      icon.source=iconDocker
    }
  }

  // event handler for the middle click on MouseArea
  function onMClick() {
    if (!onRefresh) {
      onRefresh = true
      main.checkIsActive() // from main.qml
    }
  }

  // return true if the widget area is vertical
  function isBarVertical() {
    return row.width < row.height;
  }

  // generate the text for the count result
  function generateResult() {
    if (onRefresh) return " ↻ "
    if (separateResult) {
      return ` ${parseInt(totalActive, 10)}${separator}${parseInt(total, 10)} `
    }
    return ` ${parseInt(totalActive, 10)} `
  }

  Connections {
    target: cmdSource
    function onSigIsUpdating(status) {
      updateUi(status)
    }
    function onSigIsActive(active) {
      row.isActive = active
    }
    function onSigCountAll(count) {
      row.total = count
    }
    function onSigCountActive(count) {
      row.totalActive = count
    }
  }

  Item {
    id: container
    height: row.itemSize
    width: height

    anchors.centerIn: parent

    Components.PlasmoidIcon {
      id: icon
      height: container.height
      width: height
      source: iconDocker
    }

    // MAIN BR
    Rectangle {
      visible: totalActive > 0 && mainDotPosition === 2
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: mainDotUseCustomColor ? mainDotColor : PlasmaCore.Theme.textColor
      anchors {
        right: container.right
        bottom: container.bottom
      }
    }

    // MAIN BL
    Rectangle {
      visible: totalActive > 0 && mainDotPosition === 3
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: mainDotUseCustomColor ? mainDotColor : PlasmaCore.Theme.textColor
      anchors {
        left: container.left
        bottom: container.bottom
      }
    }

    // MAIN TR
    Rectangle {
      visible: totalActive > 0 && mainDotPosition === 0
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: mainDotUseCustomColor ? mainDotColor : PlasmaCore.Theme.textColor
      anchors {
        right: container.right
        top: container.top
      }
    }

    // MAIN TL
    Rectangle {
      visible: totalActive > 0 && mainDotPosition === 1
      height: container.height / 2.5
      width: height
      radius: height / 2
      color: mainDotUseCustomColor ? mainDotColor : PlasmaCore.Theme.textColor
      anchors {
        left: container.left
        top: container.top
      }
    }

    WorkspaceComponents.BadgeOverlay { // for the horizontal bar
      anchors {
        bottom: container.bottom
        right: container.right
      }
      text: generateResult()
      visible: !isPanelVertical && !mainDot
      icon: icon
    }

    WorkspaceComponents.BadgeOverlay { // for the vertical bar
      anchors {
        verticalCenter: container.bottom
        right: container.right
      }
      text: generateResult()
      visible: isPanelVertical && !mainDot
      icon: icon
    }

    MouseArea {
      anchors.fill: container // cover all the zone
      cursorShape: Qt.PointingHandCursor // give user feedback
      acceptedButtons: Qt.LeftButton | Qt.MiddleButton
      onClicked: (mouse) => {
        if (mouse.button == Qt.LeftButton) main.expanded = !main.expanded
        if (mouse.button == Qt.MiddleButton) onMClick()
      }
    }
  }
}
