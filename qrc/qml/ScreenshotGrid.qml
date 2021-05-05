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
            implicitWidth: modelData
            implicitHeight: modelData
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
