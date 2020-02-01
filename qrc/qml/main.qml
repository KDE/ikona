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
    minimumHeight: 500
    minimumWidth: 500
    title: i18n("Ikona")

    Welcome { id: welc }

    Component.onCompleted: {
        AppIcon.setIcon("qrc:/ikona.svg")
        MonoIcon.setIcon("qrc:/ikona.svg")
    }

    property var appExamples: ["accessories-calculator", "accessories-camera", "accessories-character-map", "accessories-text-editor", "akregator", "utilities-terminal", "anjuta", "choqok"]
    property var symIcons: ["checkbox", "go-previous", "edit-clear-list", "edit-find", "games-achievements", "go-down-search", "process-stop", "draw-brush"]

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        Kirigami.ActionToolBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            actions: [
                Kirigami.Action {
                    icon.name: "go-previous"
                    onTriggered: {
                        welc.open()
                    }
                },
                Kirigami.Action {
                    icon.name: "document-new"
                    text: i18n("Create Icon...")
                    onTriggered: {
                        savePicker.open()
                    }
                },
                Kirigami.Action {
                    icon.name: "document-open"
                    text: i18n("Open Icon...")
                    onTriggered: {
                        if (swipe.currentIndex == 0) {
                            picker.open()
                        } else {
                            monoPicker.open()
                        }
                    }
                },
                Kirigami.Action {
                    icon.name: "camera-photo"
                    text: i18n("Take Montage...")
                    onTriggered: {
                        if (swipe.currentIndex == 0) {
                            screen.shot()
                        } else {
                            monoScreen.shot()
                        }
                    }
                },
                Kirigami.Action {
                    icon.name: "document-export"
                    text: i18n("Export Icon...")
                    enabled: AppIcon.isEnhanced
                    onTriggered: {
                        colour.show()
                    }
                }
            ]
        }
        ExportDialogColour { id: colour }
        Timer {
            id: tock

            interval: 2000
            repeat: true
            
            onTriggered: {
                AppIcon.refreshIcon()
            }
        }
        Timer {
            id: tick

            interval: 2000
            repeat: true
            
            onTriggered: {
                MonoIcon.refreshIcon()
            }
        }
        FileDialog {
            id: picker
            onAccepted: {
                tock.running = !AppIcon.setIcon(picker.fileUrl)
            }
            nameFilters: ["Icon SVGs (*.svg)"]
        }
        FileDialog {
            id: monoPicker
            onAccepted: {
                tick.running = !MonoIcon.setIcon(monoPicker.fileUrl)
            }
            nameFilters: ["Icon SVGs (*.svg)"]
        }
        FileDialog {
            id: savePicker
            selectExisting: false
            onAccepted: {
                AppIcon.exportTemplate(savePicker.fileUrl)
            }
            nameFilters: ["Ikona App SVGs (*.ikona.app.svg)"]
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
