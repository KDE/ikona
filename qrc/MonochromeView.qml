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
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    Row {
        anchors.fill: parent
        Rectangle {
            height: parent.height
            width: parent.width / 2
            color: root.leftColor
            Behavior on color {
                ColorAnimation {
                    duration: 500
                }
            }
        }
        Rectangle {
            height: parent.height
            width: parent.width / 2
            color: root.rightColor
            Behavior on color {
                ColorAnimation {
                    duration: 500
                }
            }
        }
    }
    Row {
        anchors.fill: parent
        spacing: 0
        Column {
            width: parent.width / 2
            anchors.verticalCenter: parent.verticalCenter
            Spacer {}
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    LightIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.imageSource
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    LightIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.symIcons[0]
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    LightIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.symIcons[1]
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    LightIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.symIcons[2]
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    LightIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.symIcons[3]
                    }
                }
            }
        }
        Column {
            width: parent.width / 2
            anchors.verticalCenter: parent.verticalCenter
            Spacer {}
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    DarkIcon {
                        overlayWhite: overlayCheck.checked
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.imageSource
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    DarkIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.symIcons[0]
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    DarkIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.symIcons[1]
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    DarkIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.symIcons[2]
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16
                Repeater {
                    model: symSizesModel
                    DarkIcon {
                        size: model["size"]
                        anchors.bottom: parent.bottom
                        source: root.symIcons[3]
                    }
                }
            }
        }
    }
    PlasmaComponents.CheckBox {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        id: overlayCheck
    }
    PlasmaComponents.Label {
        anchors.left: overlayCheck.right
        anchors.leftMargin: 5
        color: "black"
        anchors.verticalCenter: overlayCheck.verticalCenter
        text: i18n("Enable white effect on icons on dark")
    }
}