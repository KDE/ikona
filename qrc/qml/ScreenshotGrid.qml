import QtQuick 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.5 as QQC2

import org.kde.kirigami 2.8 as Kirigami

import org.kde.Ikona 1.0

GridLayout {
    anchors.centerIn: parent
    columns: [16, 22, 32, 48, 64].length
    rows: 2
    Repeater {
        model: [16, 22, 32, 48, 64]
        delegate: Kirigami.Icon {
            Layout.alignment: Qt.AlignBottom
            source: AppIcon["icon"+modelData+"path"]
            width: modelData
            height: modelData
        }
    }
    Repeater {
        model: [16, 22, 32, 48, 64]
        delegate: QQC2.Label {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            text: modelData
        }
    }
}