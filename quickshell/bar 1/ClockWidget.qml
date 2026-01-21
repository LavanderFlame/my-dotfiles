// ClockWidget.qml - Pywal style
import QtQuick

MouseArea {
  property bool showFullDate: false
  property string backgroundColor: PywalColors.background
  property string hoverColor: PywalColors.accentHover
  property string textColor: PywalColors.foreground
  
  implicitWidth: timeContainer.width
  implicitHeight: timeContainer.height
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor
  
  onClicked: {
    showFullDate = !showFullDate
  }
  
  Rectangle {
    id: timeContainer
    implicitWidth: timeText.width + 28
    implicitHeight: 30
    radius: 12
    color: PywalColors.background
    
    Text {
      id: timeText
      anchors.centerIn: parent
      text: parent.parent.showFullDate 
        ? Qt.formatDateTime(new Date(), "dddd, MM-dd, yyyy")
        : Qt.formatDateTime(new Date(), "hh:mm AP")
      color: PywalColors.foreground
      font.pixelSize: 14
      
      Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: parent.text = parent.text
      }
    }
  }
}