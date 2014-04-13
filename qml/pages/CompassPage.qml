/*
  Copyright (c) 2011-2014, Jussi Vuorisalmi <jussi.vuorisalmi@iki.fi>
  All rights reserved.

  This file is part of the harbour-orienteeringcompass package.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
      * Neither the name of the <organization> nor the
        names of its contributors may be used to endorse or promote products
        derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDER BE LIABLE FOR ANY
  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property OrientCompassSensor compass
    property CompassSettings settings

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        interactive: !compassCapsule.changingDirection  // Disable flickable when turning the compass ring

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: "About Compass"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }

        contentHeight: Screen.height // pageContent.height

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.7
            visible: settings.nightmodeActive
        }

        // The main components of the compass page from page bottom to top

        CompassCapsule {
            id: compassCapsule
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 60

            azimuth: compass.azimuth
            compassScale: settings.compassScaleStr
        }

        Label {
            id: directionLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: compassCapsule.top
            anchors.bottomMargin: 4
            color: compassCapsule.changingDirection ? Theme.highlightColor : Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeMedium
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
        }

        Label {
            id: azimuthLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: directionLine.top
            anchors.bottomMargin: 0  // There seems to be enough space
            color: compass.rightDirection ? Theme.highlightColor : Theme.secondaryHighlightColor
            font.pixelSize: 100
            text: compass.scaledAzimuth.toFixed(0)
        }

    }

    MultiToggleButton {
        id: scaleButton
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: Theme.paddingLarge
        name: "scale"
        valueList: [ "360", "400", "6000" ]
        onCurrentValueChanged: {
            settings.compassScaleStr = currentValue
        }
    }

    MultiToggleButton {
        id: nightmodeButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: Theme.paddingLarge
        name: "nightmode"
        valueList: [ "auto", "day", "night" ]
        onCurrentValueChanged: {
            settings.nightmodeSetting = currentValue
        }
    }


    // TEST
//    Image {
//        source: "../images/icon_scale_360_white.png"
//        anchors.bottom: parent.bottom
//        anchors.left: parent.left
//        anchors.margins: Theme.paddingLarge
//        width: 56; height: 56
//    }
//    Image {
//        source: "../images/icon_scale_400_white.png"
//        anchors.bottom: parent.bottom
//        anchors.right: parent.right
//        anchors.margins: Theme.paddingLarge
//        width: 56; height: 56
//    }
//    Image {
//        source: "../images/icon_scale_6000_white.png"
//        anchors.top: parent.top
//        anchors.left: parent.left
//        anchors.margins: Theme.paddingLarge
//        width: 56; height: 56
//    }

    Component.onCompleted: {
        compass.direction = Qt.binding(function() { return compassCapsule.direction; })
        compass.compassScaleVal = Qt.binding(function() { return settings.compassScaleVal; })
    }

    // TODO: investigating the behavior of the page.status property
    onStatusChanged: {
        var statusText = "";
        if (page.status === PageStatus.Inactive) { statusText = "Inactive"; }
        else if (page.status === PageStatus.Activating) { statusText = "Activating"; }
        else if (page.status === PageStatus.Active) { statusText = "Active"; }
        else if (page.status === PageStatus.Deactivating) { statusText = "Deactivating"; }
        console.log("CompassPage status: " + statusText + "(" + page.status + ")");
    }
}


