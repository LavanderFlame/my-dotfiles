// BluetoothWidget.qml
import QtQuick
import Quickshell.Io

MouseArea {
  id: btWidget
  
  property bool isEnabled: false
  property int connectedDevices: 0
  
  implicitWidth: 40
  implicitHeight: 30
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor
  
  onClicked: {
    bluetoothManager.running = true
  }
  
  Component.onCompleted: {
    checkBluetooth.running = true
  }
  
  // Check Bluetooth status
  Process {
    id: checkBluetooth
    command: ["bash", "-c", "bluetoothctl show | grep 'Powered: yes' && echo 'on' || echo 'off'"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        btWidget.isEnabled = text.trim() === "on"
        if (btWidget.isEnabled) {
          checkConnected.running = true
        }
      }
    }
  }
  
  // Check connected devices
  Process {
    id: checkConnected
    command: ["bash", "-c", "bluetoothctl devices Connected | wc -l"]
    
    stdout: StdioCollector {
      onStreamFinished: {
        var count = parseInt(text.trim())
        btWidget.connectedDevices = isNaN(count) ? 0 : count
      }
    }
  }
  
  // Update periodically
  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: checkBluetooth.running = true
  }
  
  Process {
    id: bluetoothManager
    command: ["blueman-manager"]
  }
  
  Rectangle {
    anchors.fill: parent
    radius: 12
    color: PywalColors.background
    
    Text {
      anchors.centerIn: parent
      text: btWidget.isEnabled ? "󰂲" : "󰂯"
      color: btWidget.isEnabled ? PywalColors.accent : PywalColors.color1
      font.pixelSize: 14
    }
    
    // Connected indicator
    Rectangle {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.margins: 4
      width: 8
      height: 8
      radius: 4
      color: "#a6e3a1"
      visible: btWidget.connectedDevices > 0
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
        if (!btWidget.isEnabled) return "Bluetooth Off"
        if (btWidget.connectedDevices === 0) return "No devices connected"
        return btWidget.connectedDevices + " device(s) connected"
      }
      color: PywalColors.foreground
      font.pixelSize: 11
    }
  }
}