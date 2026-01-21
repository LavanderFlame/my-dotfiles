// Bar.qml - Full Featured Bar
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
      
      implicitHeight: 42
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
          
          // Launcher
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
          
          // Workspaces
          WorkspacesWidget {
            anchors.verticalCenter: parent.verticalCenter
          }
          
          // Window title
          WindowTitleWidget {
            anchors.verticalCenter: parent.verticalCenter
          }
        }
        
        // CENTER SECTION
        Row {
          anchors.centerIn: parent
          spacing: 4
          
          // Clock
          ClockWidget {
            anchors.verticalCenter: parent.verticalCenter
          }
          
          // Settings menu
          SettingsMenuWidget {
            anchors.verticalCenter: parent.verticalCenter
            onWallpaperClicked: root.wallpaperSelectorOpen = true
          }
        }
        
        // RIGHT SECTION
        Row {
          id: rightSection
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          spacing: 4
          height: parent.height
          
          // Media controls
          MediaWidget {
            anchors.verticalCenter: parent.verticalCenter
          }
          
          // Volume
          VolumeWidget {
            anchors.verticalCenter: parent.verticalCenter
          }
          
          // Network
          NetworkWidget {
            anchors.verticalCenter: parent.verticalCenter
          }
          
          // Bluetooth
          BluetoothWidget {
            anchors.verticalCenter: parent.verticalCenter
          }
          
          // Power menu
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