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

ColumnLayout {
    id: iconRoot

    property alias source: icon.source
    property alias iconVisible: icon.visible
    property int size: 48
    property bool showLabel: false
    property bool showCheckbox: false
    property bool resetOnDrag: false
    property alias checked: checkbox.checked
    property alias labelColor: label.color


    Kirigami.Icon {
        Layout.alignment: Qt.AlignHCenter
        id: icon
        width: iconRoot.size
        height: iconRoot.size

        property var prevX: 0
        property var prevY: 0

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: icon.source.startsWith("/")

            drag.target: parent
            onPressed: parent.grabToImage(function(result) {
                parent.Drag.imageSource = result.url
            })
        }

        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0
        
        Drag.supportedActions: Qt.CopyAction
        
        Drag.mimeData: { "text/uri-list": "file://"+icon.source }
        Drag.dragType: Drag.Automatic

        onSourceChanged: {
            icon.visible = true
        }

        Drag.onDragStarted: {
            icon.prevX = icon.x
            icon.prevY = icon.y
        }
        Drag.onDragFinished: (dropAction) => {
            if (iconRoot.resetOnDrag) {
                icon.visible = false
            } else {
                icon.visible = false
                AppIcon.refreshIcon()
                icon.visible = true
            }
        }
    }
    Label {
        id: label
        Layout.alignment: Qt.AlignHCenter
        visible: showLabel
        text: iconRoot.size
    }
    CheckBox {
        id: checkbox
        Layout.alignment: Qt.AlignHCenter
        visible: showCheckbox
    }
}
