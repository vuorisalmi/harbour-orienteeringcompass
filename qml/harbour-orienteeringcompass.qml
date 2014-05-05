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

    CoverPage {
        id: coverPage
        compass: sharedCompass

        // Currently, this function is only used for debugging purposes.
        onStatusChanged: {
            var statusText = "";
            if (status === Cover.Inactive) { statusText = "Inactive"; }
            else if (status === Cover.Activating) { statusText = "Activating"; }
            else if (status === Cover.Active) { statusText = "Active"; }
            else if (status === Cover.Deactivating) { statusText = "Deactivating"; }
            console.log("Cover status: " + statusText + "(" + status + ")");
        }
    }

    initialPage: Component { CompassPage { compass: sharedCompass; settings: sharedSettings } }
    cover: coverPage

    OrientCompassSensor {
        id: sharedCompass
        active: appWindow.screenOn &&
                (appWindow.applicationActive || (coverPage.status === Cover.Active && coverPage.coverCompassActive))
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

    // Currently, this function is only used for debugging purposes.
    onApplicationActiveChanged: {
        console.log("*Application: " + (applicationActive ? "ACTIVE" : "Inactive"));
    }

    ContextProperty {
        id: screenBlanked
        key: "Screen.Blanked"
        value: 0

        onValueChanged: {
            console.log("*Screen: " + ((value) ? "Off (" : "On (") + value + ")");
            if (value > 0) {
                appWindow.screenOn = false;
            } else {
                appWindow.screenOn = true;
            }
        }
    }
}
