// Ikona - Icon Design Companion
// Copyright (C) 2019  Carson Black

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

import QtQuick 2.12
import org.kde.kirigami 2.5 as Kirigami

Row {
    spacing: 0
    Rectangle {
        height: parent.height
        width: parent.width / 2
        color: root.leftColor
        LightIcon {
            anchors.centerIn: parent
            size: parent.width - (Kirigami.Units.largeSpacing * 2)
            source: root.imageSource
        }
    }
    Rectangle {
        height: parent.height
        width: parent.width / 2
        color: root.rightColor
        DarkIcon {
            anchors.centerIn: parent
            size: parent.width - (Kirigami.Units.largeSpacing * 2)
            source: root.imageSource
        }
    }
}