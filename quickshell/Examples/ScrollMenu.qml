import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: "Overlay with Scroll Menu"

    property bool overlayVisible: false

    Rectangle {
        anchors.fill: parent
        color: "#2e3440"
    }

    // Button to show overlay
    Button {
        text: "Show Overlay Menu"
        anchors.centerIn: parent
        onClicked: overlayVisible = true
    }

    // Overlay
    Rectangle {
        visible: overlayVisible
        anchors.fill: parent
        color: "#00000080"
        z: 10

        Column {
            anchors.centerIn: parent
            spacing: 10
            width: 250
            height: 300

            Flickable {
                anchors.fill: parent
                contentHeight: menuColumn.height
                clip: true

                Column {
                    id: menuColumn
                    width: parent.width
                    spacing: 10

                    Repeater {
                        model: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]

                        Rectangle {
                            id: menuItem
                            width: parent.width
                            height: 50
                            radius: 6
                            color: "#4c566a"

                            // Highlight on hover
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: menuItem.color = "#81a1c1"
                                onExited: menuItem.color = "#4c566a"
                                onClicked: {
                                    console.log("Clicked:", modelData)
                                    overlayVisible = false
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: "white"
                                font.pixelSize: 18
                            }
                        }
                    }
                }
            }
        }

        // Click outside to close overlay
        MouseArea {
            anchors.fill: parent
            onClicked: overlayVisible = false
        }
    }
}
