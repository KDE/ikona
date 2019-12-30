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

import QtQuick 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import org.kde.Ikona 1.0

Item {
    id: screenRoot
    visible: false
    width: 800
    height: 400 + (400 * 1/3)

    Item {
        anchors.fill: parent
        Row {
            anchors.fill: parent
            Rectangle {
                height: parent.height
                width: parent.width / 2
                color: "#eff0f1"
            }
            Rectangle {
                height: parent.height
                width: parent.width / 2
                color: "#232629"
            }
        }
        Row {
            anchors.fill: parent
            spacing: 0
            Column {
                width: parent.width / 2
                anchors.verticalCenter: parent.verticalCenter
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        LightIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.darkPath
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        LightIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.symIcons[0]
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        LightIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.symIcons[1]
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        LightIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.symIcons[2]
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        LightIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.symIcons[3]
                        }
                    }
                }
            }
            Column {
                width: parent.width / 2
                anchors.verticalCenter: parent.verticalCenter
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        DarkIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.lightPath
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        DarkIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.symIcons[0]
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        DarkIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.symIcons[1]
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        DarkIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.symIcons[2]
                        }
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 16
                    Repeater {
                        model: [8, 16, 22, 32, 48, 64]
                        DarkIcon {
                            size: modelData
                            anchors.bottom: parent.bottom
                            source: root.symIcons[3]
                        }
                    }
                }
            }
        }
    }
    Row {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: Kirigami.Units.smallSpacing
        LightIcon {
            size: 32
            source: "org.kde.Ikona"
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            color: "#232629"
            text: i18nc("Overlaid on top of an image to indicate that it was made with Ikona", "Montage made with Ikona")
        }
    }
    function shot() {
        screenshotSavePicker.open()
    }
    FileDialog {
        id: screenshotSavePicker
        selectExisting: false
        selectMultiple: false
        selectFolder: false
        onAccepted: {
            print("accepted")
            screenRoot.grabToImage(function(result) {
                print("got result")
                print("url", screenshotSavePicker.fileUrl.toString().slice(7))
                res = result.saveToFile(screenshotSavePicker.fileUrl.toString().slice(7));
                print("res", res)
            });
        }
        nameFilters: [ "PNG screenshot files (*.png)" ]
    }
}
