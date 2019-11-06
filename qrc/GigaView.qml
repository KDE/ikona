import QtQuick 2.12
import org.kde.kirigami 2.5 as Kirigami

Row {
    spacing: 0
    Rectangle {
        height: parent.height
        width: parent.width / 2
        color: root.leftColor
        LightIcon {
            anchors.centerIn: parent
            size: parent.width - (Kirigami.Units.largeSpacing * 2)
            source: root.imageSource
        }
    }
    Rectangle {
        height: parent.height
        width: parent.width / 2
        color: root.rightColor
        DarkIcon {
            anchors.centerIn: parent
            size: parent.width - (Kirigami.Units.largeSpacing * 2)
            source: root.imageSource
        }
    }
}