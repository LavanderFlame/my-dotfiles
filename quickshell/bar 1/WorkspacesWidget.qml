// WorkspacesWidget.qml - With Pywal colors
import QtQuick
import Quickshell
import Quickshell.Hyprland

Rectangle {
  implicitWidth: workspaceRow.width + 24
  implicitHeight: 30
  radius: 12
  color: PywalColors.background
  opacity: 0.8
  
  Row {
    id: workspaceRow
    anchors.centerIn: parent
    spacing: 6
    
    Repeater {
      model: 5
      
      MouseArea {
        width: wsRect.width
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        property int wsIndex: index + 1
        property bool isActive: {
          var monitor = Hyprland.focusedMonitor
          if (!monitor) return false
          var workspace = monitor.activeWorkspace
          if (!workspace) return false
          return workspace.id === wsIndex
        }
        
        onClicked: {
          Hyprland.dispatch("workspace " + wsIndex)
        }
        
        Rectangle {
          id: wsRect
          anchors.centerIn: parent
          width: parent.isActive ? 40 : 20
          height: 20
          radius: 5
          color: parent.isActive ? PywalColors.accent : PywalColors.color8
          opacity: parent.isActive ? 1.0 : (parent.containsMouse ? 0.8 : 0.5)
          
          Behavior on width {
            NumberAnimation { duration: 100 }
          }
          
          Behavior on color {
            ColorAnimation { duration: 100 }
          }
          
          Behavior on opacity {
            NumberAnimation { duration: 100 }
          }
          
          Text {
            anchors.centerIn: parent
            text: parent.parent.wsIndex
            color: PywalColors.foreground
            font.pixelSize: 12
            visible: parent.parent.isActive
          }
        }
      }
    }
  }
}