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
import QtSensors 5.0
import org.freedesktop.contextkit 1.0
import "pages"

ApplicationWindow
{
    id: appWindow

    // Updated by the context property below (using contextkit)
    property bool screenOn: true

    initialPage: Component { CompassPage { compass: sharedCompass; settings: sharedSettings } }
    cover: Component { CoverPage { compass: sharedCompass } }

    OrientCompassSensor {
        id: sharedCompass
        active: true
    }

    CompassSettings {
        id: sharedSettings
    }

    LightSensor {
        id: lightSensor

        // Currently, light sensor is not needed by cover page when app is in the background
        active: appWindow.screenOn && appWindow.applicationActive && sharedSettings.nightmodeSetting === "auto"

        property real _nightThreshold: 1
        onReadingChanged: {
            console.log("***Light reading: " + reading.illuminance);
            sharedSettings.sensorNigth = (reading.illuminance <= _nightThreshold) && active;
        }
        onActiveChanged: {
            console.log("***Light sensor: " + (active ? "START" : "STOP"));
            if (!active) {
                sharedSettings.sensorNigth = false; // Default to "day" when sensor is off
            }
        }
    }

    // Main logic for the compass sensor on/off "state machine" is here:
    // decided by application being active (=foreground, full-screen) and
    // display being on/off.
    // In addition, the cover provides means to manually switch compass on/off.
    onApplicationActiveChanged: {
        console.log("*Application: " + (applicationActive ? "ACTIVE" : "Inactive"));
        if (applicationActive) {
            sharedCompass.active = true;
        }
    }

    ContextProperty {
        id: screenBlanked
        key: "Screen.Blanked"
        value: 0

        onValueChanged: {
            console.log("*Screen: " + ((value) ? "Off (" : "On (") + value + ")");
            if (value > 0) {
                // Screen is OFF --> compass always off
                sharedCompass.active = false;
                appWindow.screenOn = false;
            } else {
                if (applicationActive) {
                    // Screen is ON --> turn compass on if app is active, otherwise just leave it to the Cover to decide
                    sharedCompass.active = true;
                }
                appWindow.screenOn = true;
            }
        }
    }
}


