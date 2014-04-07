/*
  Copyright (c) 2014, Jussi Vuorisalmi <jussi.vuorisalmi@iki.fi>
  All rights reserved.

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

Item {
    id: rgbIcon
    width: 86      // Replace with your favorite default value
    height: width

    // Main interface:
    property color color: "#ffffff"  // default to white
    property string source   // filename should contain one "?"

    // Debug properties
    property bool _redFilterVisible: iconR.visible
    property bool _greenFilterVisible: iconG.visible
    property bool _blueFilterVisible: iconB.visible
    property bool _rgFilterVisible: iconRG.visible
    property bool _rbFilterVisible: iconRB.visible
    property bool _gbFilterVisible: iconGB.visible

    // IDs ("enums") of the pure color components
    property int __colorBlack: 0
    property int __colorR:     1
    property int __colorG:     2
    property int __colorB:     4
    property int __colorRG:    3
    property int __colorRB:    5
    property int __colorGB:    6
    property int __colorWhite: 7
    // Current base color
    property int __baseColor:  ((color.r > 0) * __colorR) + ((color.g > 0) * __colorG) + ((color.b > 0) * __colorB)
    // How many color components are there in the current base color?
    property bool __base1Color: __baseColor === __colorR || __baseColor === __colorG || __baseColor === __colorB
    property bool __base2Color: __baseColor === __colorRG || __baseColor === __colorRB || __baseColor === __colorGB
    property bool __base3Color: __baseColor === __colorWhite

    // The "middle" color component, in intensity (not max, not min)
    property real __midColor: (color.r + color.g + color.b) - Math.max(color.r, color.g, color.b) - Math.min(color.r, color.g, color.b)

    property variant __iconName: ["black", "red", "green", "red+green", "blue", "red+blue", "green+blue", "white"]
    //property variant __iconSourceFile: ["", "", "", "", "", "", "", ""]  // array of file names in the same order

    // TODO: refactor to an array
    // File names of the icon color variants
    property string __sourceBlack
    property string __sourceWhite
    property string __sourceR
    property string __sourceG
    property string __sourceB
    property string __sourceRG
    property string __sourceRB
    property string __sourceGB

    onSourceChanged: {
//        for (var i = 0; i < 8; i++) {
//            rgbIcon.__iconSourceFile[i] = source.replace("?", rgbIcon.__iconName[i]);
//            console.log(i, rgbIcon.__iconName[i],  rgbIcon.__iconSourceFile[i]);
//        }
        __sourceBlack = source.replace("?", "black")
        __sourceWhite = source.replace("?", "white")
        __sourceR = source.replace("?", "red")
        __sourceG = source.replace("?", "green")
        __sourceB = source.replace("?", "blue")
        __sourceRG = source.replace("?", "red+green")
        __sourceRB = source.replace("?", "red+blue")
        __sourceGB = source.replace("?", "green+blue")
    }

    function baseIconSource (color) {
        if (color.r + color.g + color.b === 0) {
            return __sourceBlack;
        } else if (color.g === 0 && color.b === 0) {
            return __sourceR;
        } else if (color.r === 0 && color.b === 0) {
            return __sourceG;
        } else if (color.r === 0 && color.g === 0) {
            return __sourceB;
        } else if (color.b === 0) {
            return __sourceRG;
        } else if (color.g === 0) {
            return __sourceRB;
        } else if (color.r === 0) {
            return __sourceGB;
        } else {
            return __sourceWhite;
        }
    }
    function baseOpacity (color) {
        if (__base1Color) {
            return Math.max(color.r, color.g, color.b);
        } else if (__base2Color) {
            // Average of the two components (one is always zero)
            return (color.r + color.g + color.b) / 2;
        } else {
            // Three or zero (black) base color
            // TODO: not quite perfect if max < 1.0, not pretty close already...
            // TODO: gives a little bit too bright color for darker colors
            return Math.max(color.r, color.g, color.b);
        }
    }

    // Returns the opacity of the colorComp filter. Generic function for any color filter.
    function filterOpacity (colorComp, color) {
        if (__base2Color) {
            // If colorComp is the bigger component of two non-zero ones...
            return (colorComp === Math.max(color.r, color.g, color.b)) ?
                        (colorComp - (color.r + color.g + color.b - colorComp)) : 0.0;
        } else if (__base3Color && colorComp === Math.max(color.r, color.g, color.b) && colorComp > __midColor) {
            return colorComp - __midColor;
        } else {
            // No filter needed if color is pure black, there is only one color component
            // or if colorComp is the smallest of the three
            return 0.0;
        }
    }

    // Returns opacity for filter of colors 1+2, component 3 is the one that is not present
    function filter2ColorOpacity(colorComp1, colorComp2, colorComp3) {
        if (__base3Color && colorComp3 < Math.max(colorComp1, colorComp2, colorComp3) && colorComp3 < __midColor) {
            return __midColor - colorComp3;
        } else {
            return 0.0;
        }
    }

    Image {
        // Black image is always shown, fully opaque, in order not to add extra
        // transparency even if the shades were very dark
        source: __sourceBlack
        anchors.fill: parent
    }
    Image {
        id: iconBase
        source: baseIconSource(color)
        anchors.fill: parent
        opacity: baseOpacity(color)
    }

    // 2-color filters -- only one if these will be visible at a time
    Image {
        id: iconRG
        source: __sourceRG
        anchors.fill: parent
        visible: (__base3Color && color.b < Math.max(color.r, color.g, color.b) && color.b < __midColor)
        opacity: filter2ColorOpacity(color.r, color.g, color.b)
    }
    Image {
        id: iconRB
        source: __sourceRB
        anchors.fill: parent
        visible: (__base3Color && color.g < Math.max(color.r, color.g, color.b) && color.g < __midColor)
        opacity: filter2ColorOpacity(color.r, color.b, color.g)
    }
    Image {
        id: iconGB
        source: __sourceGB
        anchors.fill: parent
        visible: (__base3Color && color.r < Math.max(color.r, color.g, color.b) && color.r < __midColor)
        opacity: filter2ColorOpacity(color.g, color.b, color.r)
    }

    // 1-color filters -- only one if these will be visible at a time
    Image {
        id: iconR
        source: __sourceR
        anchors.fill: parent
        // Only needed to be visible when there is more red color than some other and when it is not pure red
        visible: ((rgbIcon.color.r > rgbIcon.color.g || rgbIcon.color.r > rgbIcon.color.b) && (rgbIcon.color.g > 0 || rgbIcon.color.b > 0))
        opacity: filterOpacity(color.r, color)
    }
    Image {
        id: iconG
        source: __sourceG
        anchors.fill: parent
        visible: ((rgbIcon.color.g > rgbIcon.color.r || rgbIcon.color.g > rgbIcon.color.b) && (rgbIcon.color.r > 0 || rgbIcon.color.b > 0))
        opacity: filterOpacity(color.g, color)
    }
    Image {
        id: iconB
        source: __sourceB
        anchors.fill: parent
        visible: ((rgbIcon.color.b > rgbIcon.color.r || rgbIcon.color.b > rgbIcon.color.g) && (rgbIcon.color.r > 0 || rgbIcon.color.g > 0))
        opacity: filterOpacity(color.b, color)
    }

}
