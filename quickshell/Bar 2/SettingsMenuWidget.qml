// SettingsMenuWidget.qml - Drawer menu like Waybar groups
import QtQuick
import Quickshell.Io

Item {
  id: settingsMenu
  
  signal wallpaperClicked()
  signal keybindsClicked()
  signal updatesClicked()
  
  property bool expanded: false
  property string text: ""
  property string backgroundColor: PywalColors.background
  property string hoverColor: PywalColors.accentHover
  property string textColor: PywalColors.accent
  
  implicitWidth: expanded ? row.width : mainButton.width
  implicitHeight: 30
  
  Behavior on implicitWidth {
    NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
  }
  
  Row {
    id: row
    spacing: 4
    height: parent.height
    
    // Main settings button
    MouseArea {
      id: mainButton
      width: 40
      height: 30
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      
      onClicked: settingsMenu.expanded = !settingsMenu.expanded
      
      Rectangle {
        anchors.fill: parent
        radius: 12
        color: PywalColors.background
        
        Text {
          anchors.centerIn: parent
          text: ""
          color: PywalColors.accent
          font.pixelSize: 14
        }
      }
    }
    
    // Drawer items (visible when expanded)
    Row {
      spacing: 4
      height: parent.height
      visible: settingsMenu.expanded
      opacity: settingsMenu.expanded ? 1.0 : 0.0
      
      Behavior on opacity {
        NumberAnimation { duration: 200 }
      }
      
      // Wallpaper
      MouseArea {
        width: 40
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
          settingsMenu.wallpaperClicked()
          settingsMenu.expanded = false
        }
        
        Rectangle {
          anchors.fill: parent
          radius: 12
          color: parent.containsMouse ? PywalColors.color2 : PywalColors.accent
          
          Behavior on color {
            ColorAnimation { duration: 100 }
          }
          
          Text {
            anchors.centerIn: parent
            text: "󰸉"
            color: PywalColors.foreground
            font.pixelSize: 14
          }
        }
      }
      
     // Drawer items (visible when expanded)
    Row {
      spacing: 4
      height: parent.height
      visible: settingsMenu.expanded
      opacity: settingsMenu.expanded ? 1.0 : 0.0
      
      Behavior on opacity {
        NumberAnimation { duration: 200 }
      }
      
      // Keybinds
      MouseArea {
        width: 40
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
          keybindsProcess.running = true
          settingsMenu.expanded = false
        }
        
        Rectangle {
          anchors.fill: parent
          radius: 12
          color: parent.containsMouse ? PywalColors.color2 : PywalColors.accent
          
          Behavior on color {
            ColorAnimation { duration: 100 }
          }
          
          Text {
            anchors.centerIn: parent
            text: ""
            color: PywalColors.foreground
            font.pixelSize: 14
          }
        }
        
        Process {
          id: keybindsProcess
          command: ["/home/lavander/.config/rofi/type-7/keybinds.sh"]
        }
      }
    }
      
      // Screen recorder
      MouseArea {
        width: 40
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
          recorderProcess.running = true
          settingsMenu.expanded = false
        }
        
        Rectangle {
          anchors.fill: parent
          radius: 12
          color: parent.containsMouse ? PywalColors.color2 : PywalColors.accent
          
          Behavior on color {
            ColorAnimation { duration: 100 }
          }
          
          Text {
            anchors.centerIn: parent
            text: ""
            color: PywalColors.foreground
            font.pixelSize: 14
          }
        }
        
        Process {
          id: recorderProcess
          command: ["notify-send", "Recorder", "Screen recording placeholder"]
        }
      }
      
      // Updates
      MouseArea {
        width: 40
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
          updatesProcess.running = true
          settingsMenu.expanded = false
        }
        
      Rectangle {
          anchors.fill: parent
          radius: 12
          color: parent.containsMouse ? PywalColors.color2 : PywalColors.accent
          
          Behavior on color {
            ColorAnimation { duration: 100 }
          }
          
          Text {
            anchors.centerIn: parent
            text: "󰚰"
            color: PywalColors.foreground
            font.pixelSize: 14
          }
        }
        Process {
          id: updatesProcess
          command: ["/home/lavander/.config/waybar/scripts/update_system.sh"]
        }
      }
    }
  }
}