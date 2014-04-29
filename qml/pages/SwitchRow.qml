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

// A row of icon switches.
// Currently only supports three (3) icons in a row.
Row {
    id: switchRow

    property string name: ""  // used to find the icon image
    property string currentValue: valueList[currentIndex]  // read-only
    property variant valueList: []  // needs to be a list, see QTBUG-10822
    property variant labelList: []
    property int currentIndex: 0 // read-write externally
    property int contentWidth

    property int __columnWidth: (pageColumn.width - (2 * Theme.paddingSmall)) / 3
    spacing: Theme.paddingSmall

    Column {
        width: __columnWidth
        Switch {
            id: switch0
            width: __columnWidth
            icon.source: "../images/icon_" + name + "_" + valueList[0] + "_white.png"
            checked: currentIndex === 0
            automaticCheck: false
            onClicked: {
                currentIndex = 0
            }
        }
        Label {
            text: labelList[0]
            width: __columnWidth
            horizontalAlignment: Text.AlignHCenter
            font.bold: switch0.checked
            //color: switch0.checked ? Theme.highlightColor : Theme.primaryColor
        }
    }
    Column {
        width: __columnWidth
        Switch {
            id: switch1
            width: __columnWidth
            icon.source: "../images/icon_" + name + "_" + valueList[1] + "_white.png"
            checked: currentIndex === 1
            automaticCheck: false
            onClicked: {
                currentIndex = 1
            }
        }
        Label {
            text: labelList[1]
            width: __columnWidth
            horizontalAlignment: Text.AlignHCenter
            font.bold: switch1.checked
            //color: switch1.checked ? Theme.highlightColor : Theme.primaryColor
        }
    }
    Column {
        width: __columnWidth
        Switch {
            id: switch2
            width: pageColumn.column3width
            icon.source: "../images/icon_" + name + "_" + valueList[2] + "_white.png"
            checked: currentIndex === 2
            automaticCheck: false
            onClicked: {
                currentIndex = 2
            }
        }
        Label {
            text: labelList[2]
            width: __columnWidth
            horizontalAlignment: Text.AlignHCenter
            font.bold: switch2.checked
            //color: switch2.checked ? Theme.highlightColor : Theme.primaryColor
        }
    }


}
