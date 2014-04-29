/*
  Copyright (C) 2014 Jussi Vuorisalmi <jussi.vuorisalmi@iki.fi>
  All rights reserved.

  This file is part of the harbour-orienteeringcompass package.

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property OrientCompassSensor compass
    property CompassSettings settings

    property real __calibrationValue: settings.calibrationTest ? (compass.direction / 360) : compass.calibration

    SilicaFlickable {
        anchors.fill: parent

        interactive: !compassCapsule.changingDirection  // Disable flickable when turning the compass ring
        contentHeight: Screen.height

        // Almost black background for the nightmode.
        // Needs to be here before and below the pulldownmenu so that the menu indicator
        // stays properly visible.
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.7
            visible: settings.nightmodeActive
        }

        SettingsPage {
            id: settingsPage
            settings: page.settings
        }

        CalibrationPage {
            id: calibrationPage
            calibration: __calibrationValue
        }

        PullDownMenu {
            MenuItem {
                text: "About Compass"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(settingsPage)
            }
            MenuItem {
                text: "Calibration"
                onClicked: pageStack.push(calibrationPage)
            }
        }

        // The main components of the compass page from page bottom to top

        CompassCapsule {
            id: compassCapsule
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 60

            azimuth: compass.azimuth

            settings: page.settings

            // TODO: remove
            compassScale: settings.compassScaleStr
            currentNightmodeStr: settings.currentNightmodeStr
        }

        Label {
            id: directionLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: compassCapsule.top
            anchors.bottomMargin: 4
            color: compassCapsule.changingDirection ? Theme.highlightColor :
                                                      (settings.nightmodeActive ? "black": Theme.secondaryHighlightColor)
            font.pixelSize: Theme.fontSizeMedium
            font.bold: compassCapsule.changingDirection
            text: compass.scaledDirection.toFixed(0)
        }

        Rectangle {
            id: directionLine
            width: 2
            height: 160
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: directionLabel.top
            anchors.bottomMargin: 10
            color: compass.rightDirection ? Theme.highlightColor : Theme.secondaryHighlightColor
            visible: !settings.nightmodeActive
        }

        Label {
            id: azimuthLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: directionLine.top
            anchors.bottomMargin: 0  // There seems to be enough space
            color: compass.rightDirection ? Theme.highlightColor : Theme.secondaryHighlightColor
            font.pixelSize: 100
            font.bold: false //compass.rightDirection
            text: compass.scaledAzimuth.toFixed(0)
        }

        GlassItem {
            id: azimuthHighlight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: directionLine.top
            anchors.bottomMargin: -46
            color: Theme.highlightColor
            visible: !settings.nightmodeActive && compass.rightDirection
        }
        GlassItem {
            id: directionHighlight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: directionLine.bottom
            anchors.bottomMargin: -46
            color: Theme.highlightColor
            visible: !settings.nightmodeActive && compassCapsule.changingDirection
        }

        MultiToggleButton {
            id: scaleButton
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: Theme.paddingLarge
            highlightHAlign: "left"
            highlightVAlign: "bottom"
            name: "scale"
            valueList: [ "360", "400", "6000" ]
            // NOTE: currentIndex set by page.onStatusChanged below
            onCurrentValueChanged: {
                // Change the setting only when the page is active i.e. the change is truly
                // trigged by the finger of the user. This filters out one extra change event
                // in the very beginning that would othervise mess up the setting value.
                if (page.status === PageStatus.Active) {
                    //console.log("scaleButton: valueChanged: " + currentValue);
                    settings.compassScaleStr = currentValue
                }
            }
        }

        MultiToggleButton {
            id: nightmodeButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: Theme.paddingLarge
            highlightHAlign: "right"
            highlightVAlign: "bottom"
            name: "nightmode"
            valueList: [ "auto", "day", "night" ]
            // NOTE: currentIndex set by page.onStatusChanged below
            onCurrentValueChanged: {
                // Change the setting only when the page is active i.e. the change is truly
                // trigged by the finger of the user. This filters out one extra change event
                // in the very beginning that would othervise mess up the setting value.
                if (page.status === PageStatus.Active) {
                    //console.log("nightmodeButton: valueChanged: " + currentValue);
                    settings.nightmodeSetting = currentValue
                }
            }
        }

        // Calibration indicator, shown only when calibration is needed
        MouseArea {
            id: calibrationIndicator
            width: 200
            height: 64
            anchors.horizontalCenter: compassCapsule.horizontalCenter
            anchors.bottom: compassCapsule.bottom
            anchors.bottomMargin: 150
            visible: !settings.nightmodeActive && __calibrationValue < 0.98

            onClicked: {
                pageStack.push(calibrationPage);
            }

            Label {
                id: labelShadow
                anchors.centerIn: parent
                text: qsTr("Calibration needed")
                color: "black"
                font.bold: true
            }
            Label {
                text: labelShadow.text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: labelShadow.top
                anchors.topMargin: 2
                color: Theme.secondaryHighlightColor
                font.bold: true
            }
        }

    } // SilicaFlickable


    Component.onCompleted: {
        compass.direction = Qt.binding(function() { return compassCapsule.direction; })
        compass.compassScaleVal = Qt.binding(function() { return settings.compassScaleVal; })
    }

    // TODO: investigating the behavior of the page.status property
    onStatusChanged: {
        var statusText = "";
        if (page.status === PageStatus.Inactive) { statusText = "Inactive"; }
        else if (page.status === PageStatus.Activating) {
            statusText = "Activating";
            scaleButton.currentIndex = settings.compassScaleIndex
            nightmodeButton.currentIndex = settings.nightmodeIndex
        }
        else if (page.status === PageStatus.Active) { statusText = "Active"; }
        else if (page.status === PageStatus.Deactivating) { statusText = "Deactivating"; }
        console.log("CompassPage status: " + statusText + "(" + page.status + ")");
    }
}


