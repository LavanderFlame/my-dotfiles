// MenuDrawer.qml
import QtQuick
import Quickshell
import Quickshell.Io

FloatingWindow {
  id: drawer
  
  signal menuClosed()
  signal openWallpaperSelector()
  
  implicitWidth: 200
  implicitHeight: column.height
  
  mask: Region { item: background }
  
  Rectangle {
    id: background
    anchors.fill: parent
    color: "#1e1e2e"
    radius: 8
    border.color: "#313244"
    border.width: 1
    
    Column {
      id: column
      width: parent.width
      
      MenuItem {
        text: "🖼️ Wallpapers"
        onClicked: {
          openWallpaperSelector()
        }
      }
      
      Rectangle {
        width: parent.width
        height: 1
        color: "#313244"
      }
      
      MenuItem {
        text: "🔒 Lock Screen"
        onClicked: {
          lockProcess.running = true
          menuClosed()
        }
        
        Process {
          id: lockProcess
          command: ["loginctl", "lock-session"]
        }
      }
      
      Rectangle {
        width: parent.width
        height: 1
        color: "#313244"
      }
      
      MenuItem {
        text: "💻 Terminal"
        onClicked: {
          terminalProcess.running = true
          menuClosed()
        }
        
        Process {
          id: terminalProcess
          command: ["kitty"]
        }
      }
      
      Rectangle {
        width: parent.width
        height: 1
        color: "#313244"
      }
      
      MenuItem {
        text: "⏻ Shutdown"
        onClicked: {
          shutdownProcess.running = true
          menuClosed()
        }
        
        Process {
          id: shutdownProcess
          command: ["systemctl", "poweroff"]
        }
      }
    }
  }
}