import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import Quickshell.Io


Rectangle {
    visible: true
    width: 200
    height: 200
    color: "transparent"

    Process {
        id: skipPrevious
        command: ["playerctl", "--player=%any,app.zen_browser.zen", "previous"]
        running: false
    }

        Process {
        id: skipNext
        command: ["playerctl", "--player=%any,app.zen_browser.zen", "next"]
        running: false
    }

    Process{
        id: playCommand
        command: ["playerctl", "--player=%any,app.zen_browser.zen", "play"]
        running: false
    }

      Process{
        id: pauseCommand
        command: ["playerctl", "--all-players", "pause"]
        running: false
    }

    property bool overlayVisible: false

    Rectangle {
        implicitHeight: 30
        implicitWidth: 30
        radius: 5
        color: "white"

        Text {
            text: "󰲸"
            font.pixelSize: 20
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: overlayVisible = true
        }
    }

    // Overlay
    Rectangle {
        visible: overlayVisible
        anchors.fill: parent
        color: "#00000080" // semi-transparent
        z: 10

        MouseArea {
            anchors.fill: parent
            onClicked: overlayVisible = false
        }

       Row {
    spacing: 8
    width: 100
    height: 30
    x: 39

    Rectangle {
        id: previous
        implicitHeight: 30
        implicitWidth: 30
        radius: 5
        color: "black"
        x: overlayVisible ? 0 : -60

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        Text {
            text: "󰒮"
            font.pixelSize: 20
            anchors.centerIn: parent
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: skipPrevious.running = true
        }
    }

    Rectangle {
        id: playpause
        implicitHeight: 30
        implicitWidth: 30
        radius: 5
        color: "black"
        x: overlayVisible ? 40 : -90

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        Text {
            text: "󰐎"
            font.pixelSize: 20
            anchors.centerIn: parent
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {
                if (mouse.button === Qt.RightButton) {
                    playCommand.running = true
                } else if (mouse.button === Qt.LeftButton) {
                    pauseCommand.running = true
                }
            }
        }
    }

    Rectangle {
        id: next
        implicitHeight: 30
        implicitWidth: 30
        radius: 5
        color: "black"
        x: overlayVisible ? 80 : -90

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        Text {
            text: "󰒭"
            font.pixelSize: 20
            anchors.centerIn: parent
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: skipNext.running = true
        }
    }
}
    }
}
