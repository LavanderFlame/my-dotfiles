import QtQuick

MouseArea {
    id: root

    property bool showFullDate: false
    property string backgroundColor: PywalColors.background
    property string hoverColor: PywalColors.accentHover
    property string textColor: PywalColors.foreground
    property int fontSize: 14

    implicitHeight: timeContainer.implicitHeight
    implicitWidth: timeContainer.implicitWidth

    cursorShape: Qt.PointingHandCursor

    onClicked: {
        showFullDate = !showFullDate
    }

    // The clock display
    Rectangle {
        id: timeContainer
        implicitWidth: timeText.width + 20
        implicitHeight: 30
        radius: 8
        color: root.containsMouse ? hoverColor : backgroundColor

        Text {
            id: timeText
            anchors.centerIn: parent
            color: root.textColor
            font.pixelSize: root.fontSize

            text: root.showFullDate
                ? Qt.formatDateTime(new Date(), "dddd, MM-dd, yyyy")
                : Qt.formatDateTime(new Date(), "hh:mm AP")

            // Update every second
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: timeText.text = root.showFullDate
                    ? Qt.formatDateTime(new Date(), "dddd, MM-dd, yyyy")
                    : Qt.formatDateTime(new Date(), "hh:mm AP")
            }
        }
    }

}

