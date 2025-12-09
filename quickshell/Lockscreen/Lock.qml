import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Controls


     PanelWindow {
                implicitHeight: 800
                implicitWidth: 1080
                visible: true
                anchors {
                    top: false
                    left: false
                    right: false
                    bottom: false
                }

                Process{
                    id: reboot
                    command:["sudo reboot"]
                }


    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            console.log("ESC detected in Quickshell!")
            event.accepted = true

           dialogue.visible = false
        }
    }

    Process {
    id: usernameProc
    // Use 'whoami' to get the current username
    command: ["whoami"]
    running: true
    property string username: ""

    stdout: StdioCollector {
        onStreamFinished: {
            // Save the username in a property for later use
            usernameProc.username = this.text.trim()
        }
    }
}

    // Optional: refresh periodically if needed
Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: usernameProc.running = true
}

Process{
    id: hyprctlDis
    command: ["hyprctl", "dispatch", "exit"]
    running: false
}



    Row {
    spacing: 40                  // space between items
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 400

    Item { width: 30 }           // small left spacer

    Rectangle {
        id: shutdown
        width: 200
        height: 200
        color: "black"

        Text{
            text: ""
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 140
        }

        MouseArea {
    anchors.fill: parent
    onClicked: {
        dialogue.visible = true
        
    }
}
    }

    Rectangle {
        id: restart
        width: 200
        height: 200
        color: "black"

         Text{
            text: ""
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 140
        }

       MouseArea{
        anchors.fill: parent
        onClicked:{
            dialogue.visible = true
        }
       }
    }

    Rectangle {
        id: logout
        width: 200
        height: 200
        color: "black"

           Text{
            text: "󰗽"
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 140
        }

        MouseArea {
    anchors.fill: parent
    onClicked: {
        dialogue.visible = true
    }
}

    }

    AnimatedImage{
        id: gif
        width: 200
        height: 200
        source: "/home/lavander/.config/quickshell/assets/Funny Doodles of Silly Cats.gif"
    }
    }

    // Greeting at top
    Rectangle {
        id: greeting
        width: 900
        height: 300
        color: "black"

        x: (1080 - width)/2
        y: 50

        Text {
            text: "Hello there, " + (usernameProc.username.charAt(0).toUpperCase() + usernameProc.username.slice(1))
            font.bold: true
            font.pixelSize: 60
            color: "white"

            x: (greeting.width - width)/2
            y: (greeting.height - height)/2
        }
    }
 
 PanelWindow {
    id: dialogue
    visible: false
    implicitHeight: 300
    implicitWidth: 1080

Row {
        spacing: 40                   // space between items
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20      // optional padding from bottom

        Button {
            id: yes
            width: 200
            height: 100
            onClicked:

            Text {
                text: "Yes"
                color: "black"
                font.pixelSize: 50
                anchors.centerIn: parent
            }

        }

        Button {
            id: no
            width: 200
            height: 100
            onClicked: dialogue.visible = false

            Text {
                text: "No"
                color: "black"
                font.pixelSize: 50
                anchors.centerIn: parent
            }

            }
        }

     Rectangle {
        id: confirmation
        z: -1
        width: 900
        height: 150

        x: (1080 - width)/2

        Text {
            text: "Are you sure you want to do this?"
            font.pixelSize: 40
            color: "black"
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter

            x: (greeting.width - width)/2
            y: (greeting.height - height)/2
        }
    }
}

 }


 

