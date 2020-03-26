/*
    Copyright (C) 2019  Carson Black

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import org.kde.kirigami 2.5 as Kirigami

Kirigami.OverlayDrawer {
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
                text: i18nc("Opens the view displaying colourful icons", "Colour Icon View")
                onClicked: {
                    drawerRoot.close()
                }
            }
            Button {
                text: i18nc("Opens the view displaying colourful icons", "Icon Theme Browser")
                onClicked: {
                    IconThemeBrowser.visible = true
                }
            }
            Button {
                text: i18nc("Opens the view allowing users to process icons", "Icon Processor")
                onClicked: {
                    Processor.visible = true
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
