// MediaWidget.qml - Media controls like Waybar MPRIS
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Item {
  id: mediaWidget
  
  property bool expanded: false
  property var player: Mpris.players[0] || null
  
  implicitWidth: expanded ? mediaRow.width : mediaInfoButton.width
  implicitHeight: 30
  
  Behavior on implicitWidth {
    NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
  }
  
  Row {
    id: mediaRow
    spacing: 4
    height: parent.height
    
    // Media info button (shows song/artist)
    MouseArea {
      id: mediaInfoButton
      width: mediaText.visible ? Math.max(150, mediaText.width + 28) : 0
      height: 30
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      visible: mediaWidget.player !== null
      
      onClicked: mediaWidget.expanded = !mediaWidget.expanded
      
      Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#1e1e2e"
        
        Text {
          id: mediaText
          anchors.centerIn: parent
          text: {
            if (!mediaWidget.player) return ""
            var title = mediaWidget.player.title || "Unknown"
            var artist = mediaWidget.player.artist || "Unknown Artist"
            var display = title + " - " + artist
            return display.length > 30 ? display.substring(0, 27) + "..." : display
          }
          color: mediaWidget.player?.playbackState === MprisPlayer.Playing ? "#89b4fa" : "#6c7086"
          font.pixelSize: 12
          visible: mediaWidget.player !== null
          
          // Blinking animation when playing
          SequentialAnimation on color {
            running: mediaWidget.player?.playbackState === MprisPlayer.Playing
            loops: Animation.Infinite
            
            ColorAnimation {
              from: "#89b4fa"
              to: "#cdd6f4"
              duration: 1500
            }
            ColorAnimation {
              from: "#cdd6f4"
              to: "#89b4fa"
              duration: 1500
            }
          }
        }
      }
    }
    
    // Control buttons (visible when expanded)
    Row {
      spacing: 4
      height: parent.height
      visible: mediaWidget.expanded && mediaWidget.player !== null
      opacity: mediaWidget.expanded ? 1.0 : 0.0
      
      Behavior on opacity {
        NumberAnimation { duration: 200 }
      }
      
      // Previous
      MouseArea {
        width: 40
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        enabled: mediaWidget.player?.canGoPrevious || false
        
        onClicked: {
          if (mediaWidget.player) mediaWidget.player.previous()
        }
        
        Rectangle {
          anchors.fill: parent
          radius: 12
          color: parent.containsMouse ? "#74c7ec" : "#89b4fa"
          opacity: parent.enabled ? 1.0 : 0.5
          
          Text {
            anchors.centerIn: parent
            text: "󰒮"
            color: "#ffffff"
            font.pixelSize: 14
          }
        }
      }
      
      // Play/Pause
      MouseArea {
        width: 40
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        enabled: mediaWidget.player?.canPause || false
        
        onClicked: {
          if (mediaWidget.player) mediaWidget.player.togglePlayPause()
        }
        
        Rectangle {
          anchors.fill: parent
          radius: 12
          color: parent.containsMouse ? "#74c7ec" : "#89b4fa"
          opacity: parent.enabled ? 1.0 : 0.5
          
          Text {
            anchors.centerIn: parent
            text: mediaWidget.player?.playbackState === MprisPlayer.Playing ? "󰏤" : "󰐎"
            color: "#ffffff"
            font.pixelSize: 14
          }
        }
      }
      
      // Next
      MouseArea {
        width: 40
        height: 30
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        enabled: mediaWidget.player?.canGoNext || false
        
        onClicked: {
          if (mediaWidget.player) mediaWidget.player.next()
        }
        
        Rectangle {
          anchors.fill: parent
          radius: 12
          color: parent.containsMouse ? "#74c7ec" : "#89b4fa"
          opacity: parent.enabled ? 1.0 : 0.5
          
          Text {
            anchors.centerIn: parent
            text: "󰒭"
            color: "#ffffff"
            font.pixelSize: 14
          }
        }
      }
    }
  }
}