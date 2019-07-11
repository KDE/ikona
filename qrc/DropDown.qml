import QtQuick 2.0
import org.kde.kirigami 2.4 as Kirigami

Rectangle {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width * (9/10)
    height: pulledDown ? parent.height : Kirigami.Units.largeSpacing * 2
    border.color: Qt.darker(color)
    opacity: 0.9
    property bool pulledDown: false
    Behavior on height {
        NumberAnimation {
            easing.type: Easing.InOutQuad
            duration: Kirigami.Units.longDuration
        }
    }
}
