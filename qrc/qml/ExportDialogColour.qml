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

Window {
    id: exportColour

    title: "Export Icon"
    width: 500
    height: 500
    minimumWidth: 500
    minimumHeight: 500
    maximumWidth: 500
    maximumHeight: 500

    modality: Qt.WindowModal

    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor

        ColumnLayout {
            anchors.centerIn: parent

            Kirigami.Heading {
                Layout.alignment: Qt.AlignHCenter
                text: "Export Icon..."
            }

            RowLayout {
                
                spacing: Kirigami.Units.largeSpacing * 3
                
                Layout.alignment: Qt.AlignHCenter

                Repeater {
                    id: iconRepeater
                    model: [16, 22, 32, 48, 64]

                    DisplayIcon {
                        id: iconCheck
                        size: modelData
                        
                        source: AppIcon["icon"+modelData+"path"]
                        
                        showLabel: true
                        
                        showCheckbox: true
                        checked: true

                        Layout.alignment: Qt.AlignBottom
                        
                        Connections {
                            target: exportColour

                            onClosing: {
                                iconCheck.checked = true
                            }
                        }

                        Connections {
                            target: folderDialog

                            onAccepted: {
                                print(folderDialog.type)
                                print(ExportDialogColour.DirType.PerSize)
                                print(folderDialog.type == ExportDialogColour.DirType.PerSize)
                                AppIcon.exportToDirectory(folderDialog.type == ExportDialogColour.DirType.PerSize, modelData, AppIcon["icon"+modelData+"path"], folderDialog.fileUrl)
                            }
                        }

                    }

                }
            }
            Item {
                height: Kirigami.Units.largeSpacing*4
            }
            RowLayout {
                spacing: Kirigami.Units.largeSpacing * 2
                Button {
                    text: i18n("Export to Per-Size Directories...")
                    onClicked: {
                        folderDialog.type = ExportDialogColour.DirType.PerSize
                        folderDialog.open()
                    }
                }
                Button {
                    text: i18n("Export to One Directory...")
                    onClicked: {
                        folderDialog.type = ExportDialogColour.DirType.One
                        folderDialog.open()
                    }
                }
            }
        }

    }

    enum DirType {
        PerSize,
        One
    }

    FileDialog {
        id: folderDialog

        selectFolder: true

        property int type: ExportDialogColour.DirType.PerSize

        onAccepted: {
            exportColour.close()
        }
        onRejected: {
            exportColour.close()
        }
    }
}