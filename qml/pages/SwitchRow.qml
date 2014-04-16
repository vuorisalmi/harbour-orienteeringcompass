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
            color: switch0.checked ? Theme.highlightColor : Theme.primaryColor
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
            color: switch1.checked ? Theme.highlightColor : Theme.primaryColor
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
            color: switch2.checked ? Theme.highlightColor : Theme.primaryColor
        }
    }


}
