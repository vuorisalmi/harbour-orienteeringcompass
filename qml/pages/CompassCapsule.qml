import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: compassCapsule
    width: 500
    height: 500

    // Normalizing the angle is a bit unnecessary here...
    property real direction: normalize360(- compassRing.rotation)  // In degrees, 0-359
    property real azimuth: 0.0     // In degrees, set (bind) from outside, the compass needle follows this
    property string compassScale   // Current scale as a string, e.g. "360"
    property string currentNightmodeStr  // Curretly active nightmode as string, "night" or "day"

    property bool changingDirection: false
    property real previousAngle: 0

    function normalize360(angle) {
        var semiNormalized = angle % 360
        return semiNormalized >= 0 ? semiNormalized : semiNormalized + 360
    }

    // Non-rotating stationary image on the background
    Image {
        id: basePicture
        source: "../images/compass_ring_base.png"
        anchors.centerIn: parent
    }

    // The turnable ring (or "housing") of the compass
    Item {
        id: compassRing
        anchors.centerIn: parent
        width: compassCapsule.width
        height: compassCapsule.height

        RGBIcon {
            source: "../images/compass_ring_lines_day_?.png"
            color: changingDirection ? Theme.highlightColor : Theme.secondaryHighlightColor
            anchors.centerIn: parent
            width: 300; height: 354  // !!! Update whenever you regenerate the images !!!
            Behavior on rotation { RotationAnimation { duration: 0; direction: RotationAnimation.Shortest } }
        }
        Image {
            id: ringImage
            source: "../images/compass_ring_" + compassScale + "_day.png"
            anchors.centerIn: parent
            Behavior on rotation { RotationAnimation { duration: 0; direction: RotationAnimation.Shortest } }
        }
    }


    // The needle of the compass
    Image {
        source: "../images/compass_needle_day_S.png"
        anchors.centerIn: parent
        visible: (currentNightmodeStr === "day")
        rotation: - compassCapsule.azimuth
        Behavior on rotation { RotationAnimation { duration: 200; direction: RotationAnimation.Shortest } }
    }
//    Image {
//        source: "../images/compass_needle_day_N_red.png"
//        anchors.centerIn: parent
//        rotation: - compassCapsule.azimuth
//        Behavior on rotation { RotationAnimation { duration: 200; direction: RotationAnimation.Shortest } }
//    }
    RGBIcon {
        source: "../images/compass_needle_" + currentNightmodeStr +  "_N_?.png"
        color: Theme.highlightColor
        anchors.centerIn: parent
        rotation: - compassCapsule.azimuth
        width: 40; height: 384
        Behavior on rotation { RotationAnimation { duration: 200; direction: RotationAnimation.Shortest } }
    }

    MouseArea {
        anchors.centerIn: parent
        width: compassCapsule.width
        height: compassCapsule.height
        property int __radius: width/2
        property int __ringWidth: 45       // approx
        property int __ringTouchExtra: 20  // +- 20 pix

        function isTouchOnRing(touchX, touchY) {
            var fixedX = touchX - __radius
            var fixedY = touchY - __radius
            var distance = Math.sqrt(fixedX*fixedX + fixedY*fixedY)
            return distance > (__radius - __ringWidth - __ringTouchExtra) && distance < (__radius + __ringTouchExtra)
        }
        function xyToAngle(touchX, touchY) {
            return Math.atan2(touchY - __radius, touchX - __radius) * 180/Math.PI
        }

        onPressed: {
            if (isTouchOnRing(mouseX, mouseY)) {
                compassCapsule.changingDirection = true
                compassCapsule.previousAngle = xyToAngle(mouseX, mouseY)
                //console.log("Starting direction change at:", mouseX, mouseY, " angle ", compassCapsule.previousAngle)
            }
        }
        onReleased: {
            compassCapsule.changingDirection = false
            //console.log("Ended direction change: ", compass.direction.toFixed(1))
        }
        onPositionChanged: {
            if (compassCapsule.changingDirection) {
                compassRing.rotation += xyToAngle(mouseX, mouseY) - compassCapsule.previousAngle
                compassCapsule.previousAngle = xyToAngle(mouseX, mouseY)
            }
        }
    }


}
