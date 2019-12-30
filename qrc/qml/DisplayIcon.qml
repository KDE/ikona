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
