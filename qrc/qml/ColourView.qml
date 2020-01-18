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
            source: AppIcon.icon48path
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
                source: AppIcon["icon"+modelData+"path"]
                showLabel: true
            }
        }
    }
}
