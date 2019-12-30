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
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

import org.kde.kirigami 2.5 as Kirigami

import org.kde.Ikona 1.0

Kirigami.ApplicationWindow {
    id: root

    visible: true
    width: 500
    height: 500
    maximumHeight: 500
    maximumWidth: 500
    minimumHeight: 500
    minimumWidth: 500
    title: i18n("Ikona")

    Welcome { id: welc }

    Component.onCompleted: {
        Ikoner.setIcon("qrc:/ikona.svg")
    }

    property string normalPath
    property string darkPath
    property string lightPath
    property int colourSize: 48
    property var appExamples: ["accessories-calculator", "accessories-camera", "accessories-character-map", "accessories-text-editor", "akregator", "utilities-terminal", "anjuta", "choqok"]
    property var symIcons: ["checkbox", "go-previous", "edit-clear-list", "edit-find", "games-achievements", "go-down-search", "process-stop", "draw-brush"]

    Timer {
        interval: 1000
        running: true
        onTriggered: {
            root.normalPath = Ikoner.normalIconPath
            root.darkPath = Ikoner.darkIconPath
            root.lightPath = Ikoner.lightIconPath
            Ikoner.normalIconChanged.connect((val) => {
                root.normalPath = val
            })
            Ikoner.darkIconChanged.connect((val) => {
                root.darkPath = val
            })
            Ikoner.lightIconChanged.connect((val) => {
                root.lightPath = val
            })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        ToolBar {
            Layout.fillWidth: true
            Row {
                anchors.fill: parent
                spacing: Kirigami.Units.largeSpacing
                ToolButton {
                    icon.name: "go-previous"
                    onClicked: {
                        welc.open()
                    }
                }
                ToolButton {
                    id: darkBtn

                    checkable: true
                    text: i18nc("Togglebutton to switch between Breeze Light and Breeze Dark", "Use Dark Colours")
                    onClicked: {
                        if (checked) {
                            ColourScheme.set("Breeze Dark")
                        } else {
                            ColourScheme.set("Breeze Light")
                        }
                    }
                }
                ToolButton {
                    icon.name: "document-open"
                    text: i18n("Open Icon...")
                    onClicked: {
                        picker.open()
                    }
                }
                ToolButton {
                    icon.name: "camera-photo"
                    text: i18n("Take Montage...")
                    onClicked: {
                        if (swipe.currentIndex == 0) {
                            screen.shot()
                        } else {
                            monoScreen.shot()
                        }
                    }
                }
            }
        }
        FileDialog {
            id: picker
            onAccepted: {
                Ikoner.setIcon(picker.fileUrl)
            }
            nameFilters: ["Icon SVGs (*.svg)"]
        }
        SwipeView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            id: swipe
            interactive: false

            ColourView {}
            MonoView {}
        }
    }

    Screenshot { id: screen }
    MonochromaticScreenshot { id: monoScreen }
}
