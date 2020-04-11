pragma Singleton
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

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.Dialogs 1.3

import org.kde.kirigami 2.12 as Kirigami

import org.kde.Ikona 1.0

Kirigami.ApplicationWindow {
    height: 150
    width: 300

    maximumHeight: height
    maximumWidth: width

    minimumHeight: height
    minimumWidth: width

    title: i18n("Icon Processor")

    ColumnLayout {
        anchors {
            fill: parent
            margins: Kirigami.Units.largeSpacing*2
        }
        RowLayout {
            Layout.preferredHeight: 90
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Frame {
                implicitWidth: 70
                implicitHeight: 70

                Kirigami.Icon {
                    height: 64
                    width: 64

                    anchors.centerIn: parent

                    source: Manipulator.plural ? "folder" : Manipulator.input
                }

                Rectangle {
                    id: dragrect
                    color: Qt.rgba(0.07, 0.07, 0.07, 0.8);
                    anchors.fill: parent;
                    opacity: area.containsDrag ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                    DarkIcon {
                        anchors.centerIn: parent
                        source: "document-open"
                        size: dragrect.width / 2
                    }
                }
                DropArea {
                    id: area
                    anchors.fill: parent;
                    keys: ["text/plain"]
                    onEntered: {
                        drag.accept(Qt.CopyAction);
                    }
                    onDropped: (s) => {
                        if (s.hasUrls) {
                            if (s.urls.length > 1) {
                                Manipulator.plural = true
                                Manipulator.inputs = s.urls.map(x => x.toString())
                                output.iconVisible = false
                            } else {
                                Manipulator.plural = false
                                Manipulator.input = s.urls[0]
                            }
                        }
                    }
                }

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            }
            Button {
                width: 16
                height: 16

                hoverEnabled: true

                icon.name: "arrow-right"

                ToolTip.delay: Kirigami.Units.shortDuration
                ToolTip.visible: hovered
                ToolTip.text: i18n("Process icon")

                onClicked: {
                    indicator.visible = true
                    output.iconVisible = false
                    switch (combo.currentIndex) {
                        case 0: Manipulator.optimizeAll(); break;
                        case 1: Manipulator.optimizeWithRsvg(); break;
                        case 2: Manipulator.optimizeWithScour(); break;
                        case 3: Manipulator.classAsLight(); break;
                        case 4: Manipulator.classAsDark(); break;
                    }
                }

                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            }
            Frame {
                implicitWidth: 70
                implicitHeight: 70

                DisplayIcon {
                    id: output
                    size: 64

                    anchors.centerIn: parent

                    resetOnDrag: true
                    source: Manipulator.plural ? "folder" : Manipulator.output
                }
                BusyIndicator {
                    id: indicator
                    width: 64
                    height: 64

                    visible: false
                    anchors.centerIn: parent
                }

                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            }
        }
        Connections {
            target: Manipulator
            onOutputChanged: {
                indicator.visible = false
                output.multipleSources = []
            }
            onOutputsChanged: {
                indicator.visible = false
                output.iconVisible = true
                output.multipleSources = Manipulator.outputs
            }
        }
        ComboBox {
            id: combo

            model: ["Optimize with all methods", "Optimize using librsvg", "Optimize using scour", "Inject stylesheet/convert to light", "Inject stylesheet/convert to dark"]

            Layout.fillWidth: true
        }
    }
}