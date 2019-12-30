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
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.13

import org.kde.Ikona 1.0

Rectangle {
    id: recty
    width: 40
    height: 40
    Rectangle {
        id: scrim
        color: Qt.rgba(0,0,0,0.5)
        anchors.fill: parent
        opacity: mausArea.containsMouse ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: Kirigami.Units.longDuration * 2
                easing.type: Easing.InOutCubic
            }
        }
        SwipeView {
            anchors.fill: parent
            id: swip
            clip: true
            interactive: false

            Item {
                DarkIcon {
                    anchors.centerIn: parent
                    source: "edit-copy"
                    size: 16
                }
            }
            Item {
                DarkIcon {
                    anchors.centerIn: parent
                    source: "checkmark"
                    size: 16
                }
            }
        }
    }

    MouseArea {
        id: mausArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            swip.currentIndex = 1
            ColourScheme.copy(recty.color)
        }
        onExited: {
            swip.currentIndex = 0
        }
    }
}
