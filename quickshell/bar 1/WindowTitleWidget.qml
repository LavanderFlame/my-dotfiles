// WindowTitleWidget.qml - Simplified hyprctl approach
import QtQuick
import Quickshell.Io

Rectangle {
  id: windowWidget
  implicitWidth: Math.max(200, titleText.width + 28)
  implicitHeight: 30
  radius: 12
  color: PywalColors.background
  
  property string currentTitle: "  Hyprland"
  
  Component.onCompleted: {
    updateTitle()
  }
  
  function updateTitle() {
    titleProcess.running = true
  }
  
  Process {
    id: titleProcess
    command: ["hyprctl", "activewindow", "-j"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          var json = JSON.parse(text)
          var title = json.title || ""
          
          if (title === "" || title === "null") {
            windowWidget.currentTitle = "  Hyprland"
          } else if (title.length > 50) {
            windowWidget.currentTitle = title.substring(0, 47) + "..."
          } else {
            windowWidget.currentTitle = title
          }
        } catch (e) {
          console.log("Failed to parse window title:", e)
          windowWidget.currentTitle = "  Hyprland"
        }
      }
    }
    
    stderr: StdioCollector {
      onStreamFinished: {
        if (text.trim().length > 0) {
          console.log("hyprctl error:", text)
        }
      }
    }
  }
  
  // Update every second
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: windowWidget.updateTitle()
  }
  
  Text {
    id: titleText
    anchors.centerIn: parent
    text: windowWidget.currentTitle
    color: PywalColors.accent
    font.pixelSize: 13
    elide: Text.ElideRight
  }
}