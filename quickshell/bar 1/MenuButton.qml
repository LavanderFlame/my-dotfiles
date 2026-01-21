// MenuButton.qml
import QtQuick

MouseArea {
  id: menuButton
  
  width: 40
  height: 30
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor
  
  Rectangle {
    anchors.fill: parent
    radius: 6
    color: parent.containsMouse ? "#89b4fa" : "#45475a"
    border.color: "#cdd6f4"
    border.width: 1
    
    // Smooth color transitions
    Behavior on color {
      ColorAnimation { duration: 150 }
    }
    
    Column {
      anchors.centerIn: parent
      spacing: 4
      
      Repeater {
        model: 3
        Rectangle {
          width: 20
          height: 2
          radius: 1
          color: "#cdd6f4"
        }
      }
    }
  }
}