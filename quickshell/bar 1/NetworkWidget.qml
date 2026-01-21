// NetworkWidget.qml
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Io

MouseArea {
  id: networkWidget
  
  property bool isConnected: false
  property string connectionType: "unknown"
  property int signalStrength: 0
  property string backgroundColor: PywalColors.background
  property string hoverColor: PywalColors.accentHover
  property string textColor: PywalColors.accent
  
  implicitWidth: 40
  implicitHeight: 30
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor
  
  onClicked: {
    nmProcess.running = true
  }
  
  Component.onCompleted: {
    checkConnection.running = true
  }
  
  // Check network status
  Process {
    id: checkConnection
    command: ["bash", "-c", "nmcli -t -f TYPE,STATE device | grep -E 'wifi|ethernet' | grep connected"]
    running: false
    
    stdout: StdioCollector {
      onStreamFinished: {
        if (text.trim().length > 0) {
          networkWidget.isConnected = true
          networkWidget.connectionType = text.indexOf("wifi") >= 0 ? "wifi" : "ethernet"
        } else {
          networkWidget.isConnected = false
        }
      }
    }
  }
  
  // Get WiFi signal strength
  Process {
    id: signalCheck
    command: ["bash", "-c", "nmcli -t -f IN-USE,SIGNAL device wifi | grep '^\\*' | cut -d: -f2"]
    running: networkWidget.connectionType === "wifi"
    
    stdout: StdioCollector {
      onStreamFinished: {
        var strength = parseInt(text.trim())
        if (!isNaN(strength)) {
          networkWidget.signalStrength = strength
        }
      }
    }
  }
  
  // Update periodically
  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: {
      checkConnection.running = true
      if (networkWidget.connectionType === "wifi") {
        signalCheck.running = true
      }
    }
  }
  
  Process {
    id: nmProcess
    command: ["nm-connection-editor"]
  }
  
  Rectangle {
    anchors.fill: parent
    radius: 12
    color: PywalColors.background
    
    Text {
      anchors.centerIn: parent
      text: {
        if (!networkWidget.isConnected) return ""
        if (networkWidget.connectionType === "ethernet") return "󰈀"
        // WiFi icons based on signal strength
        if (networkWidget.signalStrength > 75) return "󱚽"
        if (networkWidget.signalStrength > 50) return "󰖩"
        if (networkWidget.signalStrength > 25) return "󱚵"
        return "󱚼"
      }
      color: networkWidget.isConnected ? PywalColors.accent : PywalColors.color1
      font.pixelSize: 14
    }
  }
  
  // Tooltip
  Rectangle {
    anchors.top: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 8
    width: tooltipText.width + 16
    height: tooltipText.height + 12
    radius: 8
    color: PywalColors.background
    border.color: PywalColors.accent
    border.width: 1
    visible: parent.containsMouse
    z: 1000
    
    Text {
      id: tooltipText
      anchors.centerIn: parent
      text: {
        if (!networkWidget.isConnected) return "Disconnected"
        if (networkWidget.connectionType === "ethernet") return "Ethernet Connected"
        return "WiFi: " + networkWidget.signalStrength + "% signal"
      }
      color: "#660000ff"
      font.pixelSize: 11
    }
  }
}