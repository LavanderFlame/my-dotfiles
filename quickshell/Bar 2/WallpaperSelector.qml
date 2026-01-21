// WallpaperSelector.qml
import QtQuick
import Quickshell

FloatingWindow {
  id: wallpaperWindow
  
  signal selectorClosed()
  
  implicitWidth: 800
  implicitHeight: 600
  
  mask: Region { item: background }
  
  Rectangle {
    id: background
    anchors.fill: parent
    color: "#1e1e2e"
    radius: 12
    border.color: "#313244"
    border.width: 2
    
    Column {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12
      
      // Header
      Row {
        width: parent.width
        spacing: 12
        
        Text {
          text: "🖼️ Select Wallpaper"
          color: "#cdd6f4"
          font.pixelSize: 18
          font.bold: true
          anchors.verticalCenter: parent.verticalCenter
        }
        
        Item { width: parent.width - 250; height: 1 }
        
        // Random button
        MouseArea {
          width: 100
          height: 30
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          
          onClicked: {
            Wallpapers.randomWallpaper()
            wallpaperWindow.selectorClosed()
          }
          
          Rectangle {
            anchors.fill: parent
            color: parent.containsMouse ? "#313244" : "#45475a"
            radius: 6
            
            Text {
              anchors.centerIn: parent
              text: "🎲 Random"
              color: "#cdd6f4"
              font.pixelSize: 12
            }
          }
        }
        
        // Close button
        MouseArea {
          width: 30
          height: 30
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          
          onClicked: wallpaperWindow.selectorClosed()
          
          Rectangle {
            anchors.fill: parent
            color: parent.containsMouse ? "#f38ba8" : "#313244"
            radius: 6
            
            Text {
              anchors.centerIn: parent
              text: "✕"
              color: "#cdd6f4"
              font.pixelSize: 16
            }
          }
        }
      }
      
      // Scrollable grid
      Rectangle {
        width: parent.width
        height: parent.height - 60
        color: "#181825"
        radius: 8
        clip: true
        
        Flickable {
          anchors.fill: parent
          anchors.margins: 12
          contentHeight: wallpaperGrid.height
          
          Grid {
            id: wallpaperGrid
            width: parent.width
            columns: 3
            spacing: 12
            
            Repeater {
              model: Wallpapers.wallpapers
              
              MouseArea {
                width: (parent.width - 24) / 3
                height: width * 0.6  // 16:10 aspect ratio
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                property string wallpaperPath: modelData
                property bool isActive: Wallpapers.currentWallpaper === wallpaperPath
                
                onClicked: {
                  Wallpapers.setWallpaper(wallpaperPath)
                  wallpaperWindow.selectorClosed()
                }
                
                Rectangle {
                  anchors.fill: parent
                  color: "#313244"
                  radius: 8
                  border.color: parent.isActive ? "#a6e3a1" : (parent.containsMouse ? "#cdd6f4" : "#45475a")
                  border.width: parent.isActive ? 3 : 1
                  clip: true
                  
                  // Image thumbnail
                  Image {
                    anchors.fill: parent
                    anchors.margins: parent.border.width
                    source: "file://" + parent.parent.wallpaperPath
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: false
                    
                    // Loading indicator
                    Rectangle {
                      anchors.centerIn: parent
                      width: 40
                      height: 40
                      color: "#1e1e2e"
                      radius: 20
                      visible: parent.status === Image.Loading
                      
                      Text {
                        anchors.centerIn: parent
                        text: "..."
                        color: "#cdd6f4"
                      }
                    }
                    
                    // Error indicator
                    Rectangle {
                      anchors.fill: parent
                      color: "#1e1e2e"
                      visible: parent.status === Image.Error
                      
                      Text {
                        anchors.centerIn: parent
                        text: "❌"
                        font.pixelSize: 32
                      }
                    }
                  }
                  
                  // Hover overlay
                  Rectangle {
                    anchors.fill: parent
                    color: "#00000066"
                    visible: parent.parent.containsMouse
                    radius: parent.radius
                    
                    Text {
                      anchors.centerIn: parent
                      text: "👁️ Preview"
                      color: "#ffffff"
                      font.pixelSize: 16
                      font.bold: true
                    }
                  }
                  
                  // Active checkmark
                  Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 8
                    width: 30
                    height: 30
                    color: "#a6e3a1"
                    radius: 15
                    visible: parent.parent.isActive
                    
                    Text {
                      anchors.centerIn: parent
                      text: "✓"
                      color: "#1e1e2e"
                      font.pixelSize: 18
                      font.bold: true
                    }
                  }
                  
                  // Filename at bottom
                  Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 30
                    color: "#1e1e2ecc"
                    radius: parent.radius
                    
                    Text {
                      anchors.centerIn: parent
                      text: Wallpapers.getFilename(parent.parent.parent.wallpaperPath)
                      color: "#cdd6f4"
                      font.pixelSize: 11
                      elide: Text.ElideMiddle
                      width: parent.width - 12
                      horizontalAlignment: Text.AlignHCenter
                    }
                  }
                }
              }
            }
          }
        }
        
        // Show message if no wallpapers
        Text {
          anchors.centerIn: parent
          visible: Wallpapers.wallpapers.length === 0
          text: "No wallpapers found\n\nCheck:\n- Directory path in Wallpapers.qml\n- Console for errors"
          color: "#6c7086"
          font.pixelSize: 14
          horizontalAlignment: Text.AlignHCenter
        }
      }
      
      // Footer
      Text {
        text: Wallpapers.wallpapers.length + " wallpapers found"
        color: "#6c7086"
        font.pixelSize: 12
      }
    }
  }
}