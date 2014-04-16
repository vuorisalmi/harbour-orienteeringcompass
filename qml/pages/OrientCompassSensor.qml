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
import QtSensors 5.0


// This is a non-visual item, a wrapper around the Qt Compass sensor element.
// It provides some additional logic for comparing the current azimuth vs.
// direction set by the user (to orienteer!) and provides the compass reading
// value in different formats according to current settings.
Item {
    id: compass

    property alias active: compassSensor.active
    property real calibration: 1.0 // Default to 100%
    property real azimuth: 0.0     // current azimuth in degrees
    property real direction: 0.0   // the orienteering direction set by user, 0-359.99 degrees
    property bool rightDirection: false // (Math.abs(azimuth - direction) < 2.0 || Math.abs(azimuth - direction) > 358.0)

    property real __normalDirection: normalize360(direction)  // 0-359.99 degrees for sure
    property real scaledDirection: scaleAngle(direction)
    property real scaledAzimuth: scaleAngle(azimuth)
    property real compassScaleVal: 360  // default, bound to settings later from outside

    function normalize360(angle) {
        var semiNormalized = angle % 360
        return semiNormalized >= 0 ? semiNormalized : semiNormalized + 360
    }
    function scaleAngle(angle360) {
        return angle360 / 360 * compassScaleVal
    }

    Compass {
        id: compassSensor

        onReadingChanged: {
            // TODO: normalize azimuth to 0-360??
            azimuth = reading.azimuth;
            rightDirection = (Math.abs(azimuth - __normalDirection) < 2.0 || Math.abs(azimuth - __normalDirection) > 358.0)
            calibration = reading.calibrationLevel
            //console.log("Compass reading: " + reading.azimuth + " direction: " + compass.__normalDirection)
            //console.log("Compass calibration: " + reading.calibrationLevel)
        }
        onActiveChanged: {
            // Debug purposes only
            console.log("***Compass sensor: " + (active ? "START" : "STOP"));
        }
    }
}
