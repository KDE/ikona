/*
    Copyright (C) 2020  Carson Black

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

import org.kde.kirigami 2.7 as Kirigami

import org.kde.Ikona 1.0

Item {
    property alias buttonIcon: rb.icon.name
    property int buttonTargetIndex: 0
    PlasmaMaterial {
        anchors.centerIn: parent
        width: 450
        height: width
        RoundButton {
            id: rb
            anchors.bottom: parent.bottom
            anchors.left: buttonTargetIndex == 0 ? parent.left : undefined
            anchors.right: buttonTargetIndex == 1 ? parent.right : undefined
            anchors.margins: Kirigami.Units.largeSpacing
            icon.name: "arrow-left"
            visible: columnRoot.width <= 1000
            onClicked: {
                columnRoot.currentIndex = buttonTargetIndex
            }
        }
    }
    Grid {
        id: rightGrid
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
        anchors.horizontalCenter: rightGrid.horizontalCenter
        anchors.top: rightGrid.bottom
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