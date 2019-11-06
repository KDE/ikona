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
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.5 as Kirigami

Item {
    id: viewroot
    Row {
        anchors.fill: parent
        Rectangle {
            color: root.leftColor
            height: parent.height
            width: parent.width / 2
            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: lgrid.bottom
                source: "qrc:/bg.jpg"
            }
            DropDown {
                pulledDown: pullDown.checked
                color: root.leftColor
            }
            Grid {
                id: lgrid
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -40
                width: 384
                height: 384
                columns: 3
                rows: 3
                Repeater {
                    model: 4
                    GridRect {
                        LightIcon {
                            anchors.centerIn: parent
                            source: root.icons[index]
                        }
                    }
                }
                GridRect {
                    LightIcon {
                        anchors.centerIn: parent
                        source: root.imageSource
                    }
                }
                Repeater {
                    model: 4
                    GridRect {
                        LightIcon {
                            anchors.centerIn: parent
                            source: root.icons[index+4]
                        }
                    }
                }
            }
            Grid {
                height: 400/3
                width: 384
                anchors.top: lgrid.bottom
                anchors.horizontalCenter: lgrid.horizontalCenter
                columns: 4
                rows: 2
                Repeater {
                    model: sizesModel
                    SmallGridRect {
                        LightIcon {
                            anchors.bottomMargin: -Kirigami.Units.largeSpacing
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: root.imageSource
                            size: model["size"]
                        }
                    }
                }
                Repeater {
                    model: sizesModel
                    SmallGridRect {
                        Label {
                            anchors.centerIn: parent
                            color: root.rightColor
                            text: model["size"]
                        }
                    }
                }
            }
        }
        Rectangle {
            color: root.rightColor
            height: parent.height
            width: parent.width / 2
            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: rgrid.bottom
                source: "qrc:/bg-dark.jpg"
            }
            DropDown {
                pulledDown: pullDown.checked
                color: root.rightColor
            }
            Grid {
                id: rgrid
                width: 384
                height: 384
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -40
                columns: 3
                rows: 3
                Repeater {
                    model: 4
                    GridRect {
                        DarkIcon {
                            anchors.centerIn: parent
                            source: root.icons[index]
                        }
                    }
                }
                GridRect {
                    DarkIcon {
                        anchors.centerIn: parent
                        source: root.imageSource
                    }
                }
                Repeater {
                    model: 4
                    GridRect {
                        DarkIcon {
                            anchors.centerIn: parent
                            source: root.icons[index+4]
                        }
                    }
                }
            }
            Rectangle {
                color: root.rightColor
                height: 400/3
                width: 384
                anchors.top: rgrid.bottom
                anchors.horizontalCenter: rgrid.horizontalCenter
                Grid {
                    height: 400/3
                    width: 384
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 4
                    rows: 2
                    Repeater {
                        model: sizesModel
                        SmallGridRect {
                            DarkIcon {
                                anchors.bottomMargin: -Kirigami.Units.largeSpacing
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                source: root.imageSource
                                size: model["size"]
                            }
                        }
                    }
                    Repeater {
                        model: sizesModel
                        SmallGridRect {
                            Label {
                                anchors.centerIn: parent
                                color: root.leftColor
                                text: model["size"]
                            }
                        }
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Kirigami.Units.longDuration
                    }
                }
            }
        }
    }
}