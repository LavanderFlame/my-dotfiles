// Bar.qml
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Scope {
    id: root
    property bool wallpaperSelectorOpen: false
    
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 40
            color: "transparent"
            
            Item {
                anchors.fill: parent
                anchors.margins: 6
                
                // LEFT SECTION
                Row {
                    id: leftSection
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4
                    height: parent.height
                    
                    WidgetButton {
                        text: "󰣇"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            launcherProcess.running = true
                        }
                        Process {
                            id: launcherProcess
                            command: ["/home/lavander/.config/rofi/type-7/quickapps.sh"]
                        }
                    }
                }
                
                // CENTER SECTION
                Row {
                    anchors.centerIn: parent
                    spacing: 4
                    
                    ClockWidget {
                        id: clockWidget
                        anchors.verticalCenter: parent.verticalCenter
                        }
                    

                          SettingsMenuWidget {
                            anchors.verticalCenter: parent.verticalCenter
          }
                }
                
                // RIGHT SECTION
                Row {
                    id: rightSection
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4
                    height: parent.height
                    
                    WidgetButton {
                        text: "󰐥"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            powerMenuProcess.running = true
                        }
                        Process {
                            id: powerMenuProcess
                            command: ["/home/lavander/.config/rofi/type-7/powermenu.sh"]
                        }
                    }
                }
            }
        }
    }

      // Wallpaper selector
  WallpaperSelector {
    visible: root.wallpaperSelectorOpen
    onSelectorClosed: root.wallpaperSelectorOpen = false
  }
}