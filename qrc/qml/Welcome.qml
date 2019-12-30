import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import org.kde.kirigami 2.5 as Kirigami

Kirigami.GlobalDrawer {
    id: drawerRoot

    height: 500
    width: 500

    interactive: false

    background: Rectangle {
        Kirigami.Theme.colorGroup: Kirigami.Theme.Window
        color: Kirigami.Theme.backgroundColor
    }

    Component.onCompleted: {
        drawerRoot.open()
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Kirigami.Units.largeSpacing * 4

        Kirigami.Icon {
            source: "org.kde.Ikona"

            height: 128
            width: 128

            Layout.alignment: Qt.AlignHCenter
        }
        Kirigami.Heading {
            text: i18n("Welcome to Ikona")

            Layout.alignment: Qt.AlignHCenter
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Button {
                text: i18nc("Open the colour view", "Colour Icon View")
                onClicked: {
                    swipe.setCurrentIndex(0)
                    drawerRoot.close()
                }
            }
            Button {
                text: i18nc("Open the monochrome view", "Monochrome Icon View")
                onClicked: {
                    swipe.setCurrentIndex(1)
                    drawerRoot.close()
                }
            }

            Layout.fillWidth: true
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Button {
                text: i18nc("Open a window titled Colour Palette with a colour palette", "Open Colour Palette")
                onClicked: {
                    colPal.show()
                }
            }
        }
    }
    ColourPalette { id: colPal }
}
