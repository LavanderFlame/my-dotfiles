// MenuItem.qml
import QtQuick

MouseArea {
  property string text: ""
  
  width: parent.width
  height: 40
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor
  
  Rectangle {
    anchors.fill: parent
    color: parent.containsMouse ? "#313244" : "transparent"
    
    Text {
      anchors.centerIn: parent
      text: parent.parent.text
      color: "#cdd6f4"
      font.pixelSize: 14
    }
  }
}