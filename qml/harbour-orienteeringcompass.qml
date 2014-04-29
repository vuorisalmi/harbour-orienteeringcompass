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

        // Jolla light sensor gives quite easily a zero level in low light...
        property real _nightThreshold: 0

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
