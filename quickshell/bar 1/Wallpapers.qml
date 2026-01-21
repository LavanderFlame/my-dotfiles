// Wallpapers.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  
  property var wallpapers: []
  property string wallpaperDir: "/home/lavander/Documents/Wallpapers"
  property string currentWallpaper: ""
  
  Component.onCompleted: {
    console.log("Wallpapers singleton loaded!")
    console.log("Searching for wallpapers in:", wallpaperDir)
    findWallpapers.running = true
  }
  
  Process {
    id: findWallpapers
    
    command: [
      "bash", "-c",
      "find " + root.wallpaperDir + " -maxdepth 1 -type f \\( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.webp' -o -name '*.gif' \\) | sort"
    ]
    
    stdout: StdioCollector {
      onStreamFinished: {
        console.log("Raw output:", text)
        var paths = text.trim().split('\n').filter(function(path) { 
          return path.length > 0 
        })
        root.wallpapers = paths
        console.log("Found", paths.length, "wallpapers:")
        for (var i = 0; i < paths.length; i++) {
          console.log("  -", paths[i])
        }
      }
    }
    
    stderr: StdioCollector {
      onStreamFinished: {
        if (text.trim().length > 0) {
          console.log("Error finding wallpapers:", text)
        }
      }
    }
  }
  
  function setWallpaper(path) {
    root.currentWallpaper = path
    console.log("Setting wallpaper to:", path)
    
    wallpaperProcess.command = ["swww", "img", path, "--transition-type", "fade"]
    wallpaperProcess.running = true
    
    // Generate pywal colors from wallpaper
    pywalProcess.command = ["wal", "-i", path, "-n"]
    pywalProcess.running = true
  }
  
  Process {
    id: wallpaperProcess
    
    onExited: {
      console.log("Wallpaper set!")
    }
  }
  
  Process {
    id: pywalProcess
    
    onExited: {
      console.log("Pywal colors generated, reloading...")
      // Reload colors after a short delay
      reloadTimer.start()
    }
  }
  
  Timer {
    id: reloadTimer
    interval: 500
    onTriggered: {
      PywalColors.reload()
    }
  }
  
  function randomWallpaper() {
    if (wallpapers.length > 0) {
      var index = Math.floor(Math.random() * wallpapers.length)
      setWallpaper(wallpapers[index])
    }
  }
  
  function getFilename(path) {
    if (!path || typeof path !== 'string') {
      return ""
    }
    var parts = path.split('/')
    return parts[parts.length - 1]
  }
}