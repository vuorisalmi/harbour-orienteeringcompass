/*
  Copyright (c) 2014 Jussi Vuorisalmi <jussi.vuorisalmi@iki.fi>

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

    property alias calibration: calibrationBar.value

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator { flickable: flickable }

        Column {
            id: column

            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - (2 * Theme.paddingLarge)
            spacing: Theme.paddingLarge

            PageHeader {
                title: "Calibration"
            }
            Label {
                text: qsTr('The compass is calibrated by rotating the device around all of its axes, e.g. by drawing an "8" into the air. Calibration is performed automatically any time you rotate your compass.')
                color: Theme.primaryColor
                wrapMode: TextEdit.WordWrap
                width: parent.width

            }
            Image {
                source: "../images/calibration_curve.png"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SectionHeader {
                text: "Current calibration"
            }

            ProgressBar {
                id: calibrationBar
                minimumValue: 0.0
                maximumValue: 1.0
                width: parent.width
                label: "Calibration level " + (value * 100).toFixed(0) + "%"
            }

        } // Column
    }
}
