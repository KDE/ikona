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
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtWebEngine 1.1
import QtGraphicalEffects 1.12

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        Rectangle {
            height: 32
            Layout.fillWidth: true
            Kirigami.Theme.colorSet: Kirigami.Theme.Window
            color: Kirigami.Theme.backgroundColor
            RowLayout {
                anchors.fill: parent
                PlasmaComponents.ToolButton {
                    enabled: webView.canGoBack
                    iconName: "draw-arrow-back"
                    text: i18n("Go Back")
                    onClicked: {
                        webView.goBack()
                    }
                }
                PlasmaComponents.ToolButton {
                    id: forwardBtn
                    enabled: webView.canGoForward
                    iconName: "draw-arrow-forward"
                    text: i18n("Go Forward")
                    onClicked: {
                        webView.goForward()
                    }
                }
                PlasmaComponents.TextField {
                    height: forwardBtn.height
                    Layout.fillWidth: true
                    text: webView.url
                    enabled: false
                }
                PlasmaComponents.ToolButton {
                    iconName: "go-home"
                    text: i18n("Return to HIG Home")
                    onClicked: {
                        webView.url = "https://hig.kde.org/style/icons/index.html"
                    }
                }
            }
        }
        WebEngineView {
            id: webView
            Layout.fillHeight: true
            Layout.fillWidth: true
            url: "https://hig.kde.org/style/icons/index.html"
        }
    }
    Column {
        id: iconColumn
        LayoutMirroring.enabled: false
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        Rectangle {
            height: 64
            width: 64
            color: root.leftColor
            LightIcon {
                anchors.centerIn: parent
                height: 48
                width: 48
                source: root.imageSource
            }
        }
        Rectangle {
            height: 64
            width: 64
            color: root.rightColor
            DarkIcon {
                anchors.centerIn: parent
                height: 48
                width: 48
                source: root.imageSource
            }
        }
    }
    DropShadow {
        anchors.fill: iconColumn
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: iconColumn
    }
}