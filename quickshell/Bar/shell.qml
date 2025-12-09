import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Layouts

Variants {
    model: Quickshell.screens

    function getWorkspaceById(id) {
        for (let i = 0; i < Hyprland.workspaces.length; i++) {
            if (Hyprland.workspaces[i].id === id)
                return Hyprland.workspaces[i];
        }
        return null;
    }

    delegate: Component {
        Item {
            required property var modelData
            id: root
            property color colMuted: "#444a57"

            PanelWindow {
                screen: modelData
                implicitHeight: 30
                visible: true
                anchors {
                    top: true
                    left: true
                    right: true
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#3b4252"

                    ClockWidget {
                        anchors.centerIn: parent
                        color: "white"
                        font.bold: true
                    }

                    Idk{
                       anchors.right: parent.right  
                    }

                    // Workspaces
                    Row {
                        id: workspaceBar
                        spacing: 6
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 6

                        Repeater {
                            model: 9

                            Rectangle {
                                width: 26
                                height: 26
                                radius: 6

                                property var ws: root.getWorkspaceById(index + 1)

                                color: ws
                                    ? (ws.focused ? "#0db9d7" :
                                       ws.active  ? "#7aa2f7" :
                                                     "#3b4252")
                                    : "#2e3440"

                                Text {
                                    anchors.centerIn: parent
                                    text: index + 1
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 14
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                                }
                            }
                        }
                    }
                }

                Connections {
                    target: Hyprland
                    function onWorkspacesChanged() {
                        console.log("Workspaces:", Hyprland.workspaces.length)
                    }
                }

                Component.onCompleted: Hyprland.refreshWorkspaces()
            }

            // divider
            Rectangle { width: 1; height: 16; color: root.colMuted }

            // --- BAR 2 ---
            PanelWindow {
                screen: modelData
                implicitWidth: 30
                implicitHeight: 1006
                visible: true
                anchors {
                    left: true
                }

                Rectangle{
                    anchors.fill: parent
                    color: "#3b4252"
                }

                     Process {
    id: activeWindow
    command: ["sh", "-c",
        "hyprctl activewindow | grep 'title:' | cut -d':' -f2-"
    ]
    running: false
    property string title: ""

    stdout: StdioCollector {
        onStreamFinished: activeWindow.title = this.text.trim()
    }
}

Timer {
    interval: 200
    running: true
    repeat: true
    onTriggered: {
        activeWindow.running = true
    }
}

Text {
    text: activeWindow.title === "" ? "No window active" :  activeWindow.title.toLowerCase().includes("~") ? "🐱" :
          activeWindow.title 
    anchors.verticalCenter: parent.verticalCenter
    anchors.centerIn: parent
    rotation: -90
    color:"white"

}
            }
        }
    }
}

          
        