import QtQuick 2.0
//import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import QtGraphicalEffects 1.12

PlasmaCore.IconItem {
//    Kirigami.Theme.inherit: false
//    Kirigami.Theme.textColor: "#eff0f1"
//    Kirigami.Theme.backgroundColor: "#31363b"
//    Kirigami.Theme.highlightColor: "#3daee9"
//    Kirigami.Theme.highlightedTextColor: "#eff0f1"
//    Kirigami.Theme.positiveTextColor: "#27ae60"
//    Kirigami.Theme.neutralTextColor: "#f67400"
//    Kirigami.Theme.negativeTextColor: "#da4453"
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
}

