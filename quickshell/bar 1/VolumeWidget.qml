// VolumeWidget.qml - Volume with slider like Waybar
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
  id: volumeWidget
  
  property bool expanded: false
  property var audio: Pipewire.defaultAudioSink
  
  implicitWidth: expanded ? volumeRow.width : volumeButton.width
  implicitHeight: 30
  
  Behavior on implicitWidth {
    NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
  }
  
  Row {
    id: volumeRow
    spacing: 4
    height: parent.height
    
    // Volume icon button
    MouseArea {
      id: volumeButton
      width: 40
      height: 30
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      
      onClicked: {
        volumeWidget.expanded = !volumeWidget.expanded
      }
      
      onWheel: function(event) {
        if (!volumeWidget.audio) return
        var delta = event.angleDelta.y > 0 ? 0.05 : -0.05
        volumeWidget.audio.volume = Math.max(0, Math.min(1, volumeWidget.audio.volume + delta))
      }
      
      Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#1e1e2e"
        
        Text {
          anchors.centerIn: parent
          text: {
            if (!volumeWidget.audio) return ""
            if (volumeWidget.audio.muted) return ""
            var vol = volumeWidget.audio.volume
            if (vol === 0) return ""
            if (vol < 0.5) return ""
            return ""
          }
          color: volumeWidget.audio?.muted ? "#f38ba8" : "#cdd6f4"
          font.pixelSize: 14
        }
      }
    }
    
    // Volume slider and percentage (visible when expanded)
    Row {
      spacing: 4
      height: parent.height
      visible: volumeWidget.expanded
      opacity: volumeWidget.expanded ? 1.0 : 0.0
      
      Behavior on opacity {
        NumberAnimation { duration: 200 }
      }
      
      // Actual volume control
      MouseArea {
        width: 40
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
          if (volumeWidget.audio) {
            volumeWidget.audio.muted = !volumeWidget.audio.muted
          }
        }
        
        Rectangle {
          anchors.fill: parent
          radius: 12
          color: parent.containsMouse ? "#74c7ec" : "#89b4fa"
          
          Text {
            anchors.centerIn: parent
            text: volumeWidget.audio?.muted ? "MUTE" : Math.round((volumeWidget.audio?.volume || 0) * 100) + "%"
            color: "#ffffff"
            font.pixelSize: 11
            font.bold: true
          }
        }
      }
      
      // Slider
      Rectangle {
        width: 100
        height: 30
        radius: 12
        color: "#89b4fa"
        
        Rectangle {
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter
          anchors.margins: 8
          width: parent.width - 16
          height: 4
          radius: 2
          color: "#313244"
          
          Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * (volumeWidget.audio?.volume || 0)
            height: parent.height
            radius: 2
            color: "#cdd6f4"
            
            Behavior on width {
              NumberAnimation { duration: 50 }
            }
          }
        }
        
        MouseArea {
          anchors.fill: parent
          
          function updateVolume(mouse) {
            if (!volumeWidget.audio) return
            var newVolume = Math.max(0, Math.min(1, (mouse.x - 8) / (parent.width - 16)))
            volumeWidget.audio.volume = newVolume
          }
          
          onPressed: function(mouse) {
            updateVolume(mouse)
          }
          
          onPositionChanged: function(mouse) {
            if (pressed) {
              updateVolume(mouse)
            }
          }
        }
      }
    }
  }
}