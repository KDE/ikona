import QtQuick 2.0
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import QtGraphicalEffects 1.12

Item {
    id: root
    property int size: 48
    height: root.size
    width: root.size
    property alias source: icon.source
    property alias overlayWhite: icon.overlayWhite
    Rectangle {
        y: Math.round((parent.height/2) - (width/2))
        x: Math.round((parent.width/2) - (height/2))
        width: Math.round(parent.width + (Kirigami.Units.largeSpacing * 2))
        height: Math.round(parent.width + (Kirigami.Units.largeSpacing * 2))
        border.color: PlasmaCore.ColorScope.highlightColor
        border.width: 1
        color: Qt.rgba(PlasmaCore.ColorScope.highlightColor.r,PlasmaCore.ColorScope.highlightColor.g,PlasmaCore.ColorScope.highlightColor.b,0.3)
        opacity: maus.containsMouse ? 1 : 0
        radius: 2
        MouseArea {
            id: maus
            anchors.fill: parent
            hoverEnabled: true
        }
        Behavior on opacity {
            NumberAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutQuad
            }
        }
    }
    Kirigami.Icon {
        id: icon
        Kirigami.Theme.inherit: false
        Kirigami.Theme.textColor: "#eff0f1"
        Kirigami.Theme.backgroundColor: "#31363b"
        Kirigami.Theme.highlightColor: "#3daee9"
        Kirigami.Theme.highlightedTextColor: "#eff0f1"
        Kirigami.Theme.positiveTextColor: "#27ae60"
        Kirigami.Theme.neutralTextColor: "#f67400"
        Kirigami.Theme.negativeTextColor: "#da4453"
        property bool overlayWhite: false
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: "#ffffffff"
            opacity: parent.overlayWhite ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
        }
        y: Math.round((parent.height/2) - (width/2))
        x: Math.round((parent.width/2) - (height/2))
        height: root.size
        width: root.size
    }
}

