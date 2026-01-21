// WidgetButton.qml - Styled like Waybar
import QtQuick

MouseArea {
  property string text: ""
  property string backgroundColor: PywalColors.background
  property string hoverColor: PywalColors.accentHover
  property string textColor: PywalColors.accent
  property int fontSize: 14
  
  implicitWidth: buttonRect.implicitWidth
  implicitHeight: 30
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor
  
  Rectangle {
    id: buttonRect
    anchors.fill: parent
    implicitWidth: buttonText.width + 28
    radius: 8
    color: parent.containsMouse ? hoverColor : backgroundColor
    
    Behavior on color {
      ColorAnimation { duration: 100 }
    }
    
    Behavior on opacity {
      NumberAnimation { duration: 100 }
    }
    
    Text {
      id: buttonText
      anchors.centerIn: parent
      text: parent.parent.text
      color: parent.parent.textColor
      font.pixelSize: parent.parent.fontSize
    }
  }
}