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

import org.kde.kirigami 2.7 as Kirigami

import org.kde.Ikona 1.0

Kirigami.ColumnView {
    id: columnRoot

    columnResizeMode: width <= 1000 ? Kirigami.ColumnView.SingleColumn : Kirigami.ColumnView.DynamicColumns
    
    Item {
        Kirigami.ColumnView.fillWidth: true
        Kirigami.ColumnView.pinned: true
        Kirigami.ColumnView.reservedSpace: Math.ceil((columnRoot.width-1)/2)

        Kirigami.Theme.textColor: "#232629"
        Kirigami.Theme.backgroundColor: "#eff0f1"
        Kirigami.Theme.highlightColor: "#3daee9"
        Kirigami.Theme.highlightedTextColor: "#eff0f1"
        Kirigami.Theme.positiveTextColor: "#27ae60"
        Kirigami.Theme.neutralTextColor: "#f67400"
        Kirigami.Theme.negativeTextColor: "#da4453"

        implicitWidth: 500
        Image {
            fillMode: Image.PreserveAspectCrop
            source: "light.jpg"
            anchors.fill: parent

            ColourPage { anchors.fill: parent; buttonTargetIndex: 1; buttonIcon: "arrow-right" }
        }
    }

    Item {
        Kirigami.ColumnView.fillWidth: true
        Kirigami.ColumnView.pinned: true
        Kirigami.ColumnView.reservedSpace: Math.floor((columnRoot.width-1)/2)

        Kirigami.Theme.textColor: "#eff0f1"
        Kirigami.Theme.backgroundColor: "#31363b"
        Kirigami.Theme.highlightColor: "#3daee9"
        Kirigami.Theme.highlightedTextColor: "#eff0f1"
        Kirigami.Theme.positiveTextColor: "#27ae60"
        Kirigami.Theme.neutralTextColor: "#f67400"
        Kirigami.Theme.negativeTextColor: "#da4453"

        implicitWidth: 500
        Image {
            fillMode: Image.PreserveAspectCrop
            source: "dark.jpg"
            anchors.fill: parent

            ColourPage { anchors.fill: parent; buttonTargetIndex: 0; buttonIcon: "arrow-left" }
        }
    }
}

