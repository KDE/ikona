import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import org.kde.kirigami 2.5 as Kirigami

import org.kde.Ikona 1.0

Image {
    id: colourRoot

    source: darkBtn.checked ? "dark.jpg" : "light.jpg"

    PlasmaMaterial {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
    }

    Grid {
        id: grid
        columns: 3
        rows: 3

        anchors.centerIn: parent
        spacing: Kirigami.Units.largeSpacing * 3

        Repeater {
            model: 4
            DisplayIcon {
                source: root.appExamples[index]
            }
        }

        DisplayIcon {
            source: root.normalPath
        }

        Repeater {
            model: 4
            DisplayIcon {
                source: root.appExamples[index+4]
            }
        }
    }
    RowLayout {
        anchors.horizontalCenter: grid.horizontalCenter
        anchors.top: grid.bottom
        anchors.topMargin: Kirigami.Units.largeSpacing * 3
        spacing: Kirigami.Units.largeSpacing * 3
        Repeater {
            model: [16, 22, 32, 48, 64]
            DisplayIcon {
                Layout.alignment: Qt.AlignBottom
                size: modelData
                source: root.normalPath
                showLabel: true
            }
        }
    }
}
