import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import org.kde.kirigami 2.5 as Kirigami

ColumnLayout {
    id: iconRoot

    property alias source: icon.source
    property int size: 48
    property bool showLabel: false
    property alias labelColor: label.color

    Kirigami.Icon {
        Layout.alignment: Qt.AlignHCenter
        id: icon
        width: iconRoot.size
        height: iconRoot.size
    }
    Label {
        id: label
        Layout.alignment: Qt.AlignHCenter
        visible: showLabel
        text: iconRoot.size
    }
}
