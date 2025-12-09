import QtQuick
import Quickshell
import Quickshell.Io

Variants {
    model: Quickshell.screens

    delegate: Component {
        // ONE delegate = one screen
        Item {
            required property var modelData

            // --- BAR 1 ---
            PanelWindow {
                screen: modelData
                implicitWidth: 400
                implicitHeight: 30
                visible: true
                anchors {
                    top: true
                    left: true
                    right: true
                }
                ClockWidget {
                    anchors.centerIn: parent
                }
            }

            // --- BAR 2 ---
            PanelWindow {
                screen: modelData
                implicitWidth: 30
                implicitHeight: 1050
                visible: true
                anchors {
                    top: false     // bottom bar
                    left: true
                    right: false
                }

                Text {
                    anchors.centerIn: parent
                    rotation: 90
                    text: "Yippie second bar!!"
                }
            }
        }
    }
}
