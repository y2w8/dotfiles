/*****************************************************************************
 *   Copyright (C) 2022 by Friedrich Schriewer <friedrich.schriewer@gmx.net> *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 ****************************************************************************/

import QtQuick 2.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.plasma.private.kicker 0.1 as Kicker

import QtQuick.Window 2.2
import org.kde.plasma.components 3.0 as PlasmaComponents
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.kirigami as Kirigami

ScrollView {
  id: appLIstView

  property alias listView: listView
  property alias model: listView.model
  property alias count: listView.count

  // This helps to prevent list focus back to cursor position when search changes
  property var interceptedPosition: null
  property bool blockingHoverFocus: false

// ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
// ScrollBar.vertical.policy: ScrollBar.AsNeeded

  ListView {
    id: listView

    anchors.fill: parent

    property real availableWidth:  listView.width - Kirigami.Units.gridUnit

    // This helps to prevent focus getting back to cursor position when navigating through the list
    property bool movedWithKeyboard: false
    property bool movedWithWheel: false

    Accessible.role: Accessible.List

    focus: true
    clip: true
    currentIndex: count > 0 ? 0 : -1
    interactive: height < contentHeight
    boundsBehavior: Flickable.StopAtBounds
    // default keyboard navigation doesn't allow focus reasons to be used
    // and eats up/down key events when at the beginning or end of the list.
    keyNavigationEnabled: false
    keyNavigationWraps: false
    // This is actually needed. The highlight will animate from thin to wide otherwise.
    highlightResizeDuration: 0
    highlightMoveDuration: 50
    highlight:  Rectangle {
      id: rectFill
      color: main.contrastBgColor
      radius: 10
      z: -20
    }
    delegate: AppLIstViewDelegate {
      triggerModel: listView.model
      width: listView.availableWidth
    }

    move: normalTransition
    moveDisplaced: normalTransition

    Transition {
      id: normalTransition
      NumberAnimation {
        duration: Kirigami.Units.shortDuration
        properties: "x, y"
        easing.type: Easing.OutCubic
      }
    }

    section {
      property: "group"
      criteria: ViewSection.FullString
      delegate: PlasmaExtras.ListSectionHeader {
        required property string section
        width: listView.availableWidth
        text: section
      }
    }

    Kirigami.WheelHandler {
      target: listView
      filterMouseEvents: true
      // `20 * Qt.styleHints.wheelScrollLines` is the default speed.
      horizontalStepSize: 20 * Qt.styleHints.wheelScrollLines
      verticalStepSize: 20 * Qt.styleHints.wheelScrollLines

      onWheel: wheel => {
          listView.movedWithWheel = true
          listView.movedWithKeyboard = false
          movedWithWheelTimer.restart()
      }
    }

    // Used to block hover events temporarily after using keyboard navigation.
    // If you have one hand on the touch pad or mouse and another hand on the keyboard,
    // it's easy to accidentally reset the highlight/focus position to the mouse position.
    Timer {
      id: movedWithKeyboardTimer
      interval: 200
      onTriggered: listView.movedWithKeyboard = false
    }

    Timer {
      id: movedWithWheelTimer
      interval: 200
      onTriggered: listView.movedWithWheel = false
    }

    function focusCurrentItem(event, focusReason) {
      currentItem.forceActiveFocus(focusReason)
      event.accepted = true
    }

    Keys.onPressed: event => {
      const targetX = currentItem ? currentItem.x : contentX
      let targetY = currentItem ? currentItem.y : contentY
      let targetIndex = currentIndex
      const atFirst = currentIndex === 0
      const atLast = currentIndex === count - 1
      if (count >= 1) {
        switch (event.key) {
          case Qt.Key_Up: if (!atFirst) {
              decrementCurrentIndex()

              if (currentItem.isSeparator) {
                  decrementCurrentIndex()
              }

              focusCurrentItem(event, Qt.BacktabFocusReason)
          } break
          case Qt.Key_K: if (!atFirst && event.modifiers & Qt.ControlModifier) {
              decrementCurrentIndex()
              focusCurrentItem(event, Qt.BacktabFocusReason)
          } break
          case Qt.Key_Down: if (!atLast) {
              incrementCurrentIndex()

              if (currentItem.isSeparator) {
                  incrementCurrentIndex()
              }

              focusCurrentItem(event, Qt.TabFocusReason)
          } break
          case Qt.Key_J: if (!atLast && event.modifiers & Qt.ControlModifier) {
              incrementCurrentIndex()
              focusCurrentItem(event, Qt.TabFocusReason)
          } break
          case Qt.Key_Home: if (!atFirst) {
              currentIndex = 0
              focusCurrentItem(event, Qt.BacktabFocusReason)
          } break
          case Qt.Key_End: if (!atLast) {
              currentIndex = count - 1
              focusCurrentItem(event, Qt.TabFocusReason)
          } break
          case Qt.Key_PageUp: if (!atFirst) {
              targetY = targetY - height + 1
              targetIndex = indexAt(targetX, targetY)
              // TODO: Find a more efficient, but accurate way to do this
              while (targetIndex === -1) {
                  targetY += 1
                  targetIndex = indexAt(targetX, targetY)
              }
              currentIndex = Math.max(targetIndex, 0)
              focusCurrentItem(event, Qt.BacktabFocusReason)
          } break
          case Qt.Key_PageDown: if (!atLast) {
              targetY = targetY + height - 1
              targetIndex = indexAt(targetX, targetY)
              // TODO: Find a more efficient, but accurate way to do this
              while (targetIndex === -1) {
                  targetY -= 1
                  targetIndex = indexAt(targetX, targetY)
              }
              currentIndex = Math.min(targetIndex, count - 1)
              focusCurrentItem(event, Qt.TabFocusReason)
          } break
          case Qt.Key_Return:
              /* Fall through*/
          case Qt.Key_Enter:
              listView.currentItem.trigger();
              listView.currentItem.forceActiveFocus(Qt.ShortcutFocusReason);
              event.accepted = true;
              break;
        }
      }
      movedWithKeyboard = event.accepted
      if (movedWithKeyboard) {
          movedWithKeyboardTimer.restart()
      }
    }
  }

  Connections {
    target: blockHoverFocusHandler
    enabled: blockHoverFocusHandler.enabled && !appLIstView.interceptedPosition
    function onPointChanged() {
      appLIstView.interceptedPosition = blockHoverFocusHandler.point.position
    }
  }

  Connections {
    target: blockHoverFocusHandler
    enabled: blockHoverFocusHandler.enabled && appLIstView.interceptedPosition && appLIstView.blockingHoverFocus
    function onPointChanged() {
      if (blockHoverFocusHandler.point.position === appLIstView.interceptedPosition) {
          return;
      }
      appLIstView.blockingHoverFocus = false
    }
  }

  HoverHandler {
    id: blockHoverFocusHandler
    enabled: (!appLIstView.interceptedPosition || appLIstView.blockingHoverFocus)
  }
}
