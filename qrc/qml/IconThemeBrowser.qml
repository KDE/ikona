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

import org.kde.kirigami 2.13 as Kirigami

import org.kde.Ikona 1.0

Kirigami.RouterWindow {
    id: browseRoot
    visible: false

    function contextToDescription(context) {
        switch (context) {
            case IconDirectory.Actions:
                return i18n("Icons representing actions a user can perform.")
            case IconDirectory.Animations:
                return i18n("Icons representing stages of an animation.")
            case IconDirectory.Apps:
                return i18n("Icons representing an application.")
            case IconDirectory.Categories:
                return i18n("Icons representing categories of applications.")
            case IconDirectory.Devices:
                return i18n("Icons representing real-world devices, not filesystem devices.")
            case IconDirectory.Emblems:
                return i18n("Icons to be overlaid on other icons.")
            case IconDirectory.Emotes:
                return i18n("Icons representing emotions.")
            case IconDirectory.Filesystems:
                return i18n("Icons representing parts of a filesystem.")
            case IconDirectory.International:
                return i18n("Icons representing international items.")
            case IconDirectory.Mimetypes:
                return i18n("Icons representing MIME types.")
            case IconDirectory.Places:
                return i18n("Icons representing landmark places in a filesystem.")
            case IconDirectory.Status:
                return i18n("Icons representing current status of processes and devices.")
            case IconDirectory.NoContext:
                return i18n("Icons representing anything.")
        }
    }

    function typeToDescription(type) {
        switch (type) {
            case IconDirectory.Scalable:
                return i18n("This icon can be scaled to any size.")
            case IconDirectory.Threshold:
                return i18n("This icon can be scaled to any size within a threshold.")
            case IconDirectory.Fixed:
                return i18n("This icon cannot be scaled and has a fixed size.")
            case IconDirectory.NoType:
                return i18n("This icon has no particular size.")
        }
    }

    function contextToString(context) {
        switch (context) {
            case IconDirectory.Actions:
                return i18n("Actions")
            case IconDirectory.Animations:
                return i18n("Animations")
            case IconDirectory.Apps:
                return i18n("Apps")
            case IconDirectory.Categories:
                return i18n("Categories")
            case IconDirectory.Devices:
                return i18n("Devices")
            case IconDirectory.Emblems:
                return i18n("Emblems")
            case IconDirectory.Emotes:
                return i18n("Emotes")
            case IconDirectory.Filesystems:
                return i18n("Filesystems")
            case IconDirectory.International:
                return i18n("International")
            case IconDirectory.Mimetypes:
                return i18n("Mimetypes")
            case IconDirectory.Places:
                return i18n("Places")
            case IconDirectory.Status:
                return i18n("Status")
            case IconDirectory.NoContext:
                return i18n("No Context")
        }
    }

    function typeToString(type) {
        switch (type) {
            case IconDirectory.Scalable:
                return i18n("Scalable")
            case IconDirectory.Threshold:
                return i18n("Threshold Size")
            case IconDirectory.Fixed:
                return i18n("Fixed Size")
            case IconDirectory.NoType:
                return i18n("NoType")
        }
    }

    Kirigami.PageRoute {
        name: "folder"

        Kirigami.ScrollablePage {
            id: iconComponentRoot

            property var directory: Kirigami.PageRouter.data

            topPadding: 0
            leftPadding: 0
            rightPadding: 0
            bottomPadding: 0

            titleDelegate: RowLayout {
                Kirigami.Heading {
                    text: iconComponentRoot.directory.location
                }
                Item {
                    implicitHeight: 1
                    implicitWidth: Kirigami.Units.largeSpacing*2
                }
                Kirigami.SearchField {
                    id: nameFilter
                    Layout.alignment: Qt.AlignHCenter

                    onTextChanged: { iconView.text = text }
                }
            }

            GridView {
                id: iconView

                property string text

                model: iconComponentRoot.directory.icons.filter((currentVal, indx, array) => {
                    if (iconView.text != "") {
                        return currentVal.name.includes(iconView.text)
                    }
                    return true
                }).sort((a, b) => {
                    return a.name < b.name
                })
                cellWidth: iconComponentRoot.directory.displaySize()+(padding()*2)
                cellHeight: iconComponentRoot.directory.displaySize()+padding()

                function padding() { return Kirigami.Units.gridUnit*5 }

                delegate: Item {
                    height: iconComponentRoot.directory.displaySize()+iconView.padding()
                    width: iconComponentRoot.directory.displaySize()+(iconView.padding()*2)

                    Kirigami.ActionToolBar {
                        anchors {
                            bottom: parent.bottom
                            right: parent.right
                        }

                        Layout.alignment: Qt.AlignRight

                        hiddenActions: [
                            Kirigami.Action {
                                iconName: "edit-copy"
                                text: i18n("Copy icon name to clipboard")
                                onTriggered: modelData.copyName()
                            },
                            Kirigami.Action {
                                iconName: "document-open"
                                text: i18n("Open folder containing icon")
                                onTriggered: modelData.openInFileManager()
                            },
                            Kirigami.Action {
                                iconName: "document-edit"
                                text: i18n("Open icon in editor")
                                onTriggered: modelData.openInEditor()
                            },
                            Kirigami.Action {
                                iconName: "search"
                                text: i18n("View icon at different sizes in this theme")
                                onTriggered: {
                                    iconSizeSheet.model = modelData.sameThemeDifferentSize()
                                    iconSizeSheet.showSize = true
                                    iconSizeSheet.open()
                                }
                            },
                            Kirigami.Action {
                                iconName: "view-list-icons"
                                text: i18n("View icon in different themes at the same size")
                                onTriggered: {
                                    iconSizeSheet.model = modelData.sameSizeDifferentTheme()
                                    iconSizeSheet.showSize = false
                                    iconSizeSheet.open()
                                }
                            },
                            Kirigami.Action {
                                iconName: "camera-photo"
                                text: i18n("Copy montage of icon to clipboard")
                                onTriggered: {
                                    screenshotItem.model = modelData.sameThemeDifferentSize()
                                    screenshotItem.grabToImage(function(result) {
                                        Clipboard.copyImage(result.image)
                                        browseRoot.showPassiveNotification(i18n("Montage copied to clipboard"), "long")
                                    })
                                }
                            }
                        ]
                    }
                    Item {
                        id: screenshotItem
                        property alias model: screenshotRepeater.model

                        visible: false
                        width: screenshotCol.implicitWidth
                        height: screenshotCol.implicitHeight

                        Rectangle {
                            color: "#8f8f8f"
                            anchors.fill: parent
                        }

                        ColumnLayout {
                            id: screenshotCol
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.margins: Kirigami.Units.largeSpacing
                                Kirigami.Heading {
                                    level: 2
                                    color: "white"
                                    text: modelData.parentTheme().displayName
                                }
                                Kirigami.Heading {
                                    level: 4
                                    color: "white"
                                    text: modelData.name
                                }
                                Item {
                                    implicitHeight: 1
                                    Layout.fillWidth: true
                                }
                                Label {
                                    text: i18nc("Overlaid on top of an image to indicate that it was made with Ikona", "Montage made with Ikona")
                                    Layout.alignment: Qt.AlignVCenter
                                }
                                Kirigami.Icon {
                                    height: 32
                                    width: 32

                                    color: "white"
                                    source: "org.kde.Ikona"
                                }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.margins: Kirigami.Units.largeSpacing
                                Layout.alignment: Qt.AlignHCenter
                                Repeater {
                                    id: screenshotRepeater
                                    delegate: ColumnLayout {
                                        id: itemCol
                                        Layout.alignment: Qt.AlignHCenter

                                        Kirigami.Icon {
                                            width: modelData.displaySize()
                                            height: width
                                            source: modelData.location
                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                        Label {
                                            color: "white"
                                            text: iconSizeSheet.showSize ? modelData.displaySize() : modelData.parentTheme().displayName

                                            Layout.alignment: Qt.AlignHCenter
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Kirigami.OverlaySheet {
                        id: iconSizeSheet
                        property alias model: iconSizeSheetRepeater.model
                        property bool showSize: true
                        property bool screenShotting: false
                        background: Rectangle {
                            color: "#8f8f8f"
                            anchors.fill: parent
                        }
                        Item {
                            id: sizes
                            implicitHeight: subLayout.implicitHeight
                            implicitWidth: subLayout.implicitWidth+(Kirigami.Units.gridUnit*10)
                            Rectangle { // This rectangle is here so the
                                        // montage renders with a background
                                color: "#8f8f8f"
                                anchors.fill: parent
                            }
                            ColumnLayout {
                                id: subLayout
                                anchors.fill: parent
                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.margins: Kirigami.Units.largeSpacing
                                    Kirigami.Heading {
                                        level: 2
                                        color: "white"
                                        text: modelData.parentTheme().displayName
                                    }
                                    Kirigami.Heading {
                                        level: 4
                                        color: "white"
                                        text: modelData.name
                                    }
                                    Item {
                                        implicitHeight: 1
                                        Layout.fillWidth: true
                                    }
                                    Label {
                                        id: promoLabel
                                        visible: false
                                        text: i18nc("Overlaid on top of an image to indicate that it was made with Ikona", "Montage made with Ikona")
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                    Kirigami.Icon {
                                        id: promoIcon
                                        height: 32
                                        width: 32

                                        color: "white"
                                        source: "org.kde.Ikona"
                                        visible: false
                                    }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.margins: Kirigami.Units.largeSpacing
                                    Layout.alignment: Qt.AlignHCenter
                                    Repeater {
                                        id: iconSizeSheetRepeater
                                        delegate: ColumnLayout {
                                            id: itemCol
                                            Layout.alignment: Qt.AlignHCenter

                                            Kirigami.Icon {
                                                width: modelData.displaySize()
                                                height: width
                                                source: modelData.location
                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                            Label {
                                                color: "white"
                                                text: iconSizeSheet.showSize ? modelData.displaySize() : modelData.parentTheme().displayName

                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    ColumnLayout {
                        id: columnLayout
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle {
                            implicitHeight: iconComponentRoot.directory.displaySize()+(Kirigami.Units.largeSpacing*2)
                            implicitWidth: iconComponentRoot.directory.displaySize()+(Kirigami.Units.largeSpacing*2)

                            Kirigami.Icon {
                                id: icon
                                source: modelData.location
                                anchors.centerIn: parent
                                width: iconComponentRoot.directory.displaySize()
                                height: iconComponentRoot.directory.displaySize()
                            }

                            Kirigami.ImageColors {
                                id: palette
                                source: icon
                            }

                            color: palette.paletteBrightness == Kirigami.ColorUtils.Light ? "#101114" : "#fcffff"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: modelData.name
                            wrapMode: Text.Wrap
                            horizontalAlignment: Text.AlignHCenter

                            Layout.maximumWidth: iconComponentRoot.directory.displaySize()+(iconView.padding()*2)
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }

    Kirigami.PageRoute {
        name: "folders"

        Kirigami.ScrollablePage {
            title: i18nc("theme name (folder name)", "%1 (%2)").arg(Kirigami.PageRouter.data.displayName).arg(Kirigami.PageRouter.data.name)

            Kirigami.CardsListView {
                id: listView
                model: Kirigami.PageRouter.data.iconDirectories

                delegate: Kirigami.AbstractCard {
                    showClickFeedback: true
                    down: browseRoot.pageStack.lastItem.directory == modelData
                    onClicked: Kirigami.PageRouter.pushFromHere({"route": "folder", "data": modelData})
                    contentItem: Item {
                        implicitWidth: delegateLayout.implicitWidth
                        implicitHeight: delegateLayout.implicitHeight

                        ColumnLayout {
                            id: delegateLayout
                            RowLayout {
                                Kirigami.Heading {
                                    text: modelData.location
                                }
                                ToolButton {
                                    icon.name: "document-open"
                                    onClicked: Qt.openUrlExternally("file://"+modelData.fullLocation)
                                }
                            }
                            RowLayout {
                                Label {
                                    opacity: 0.8
                                    text: i18n("Context: %1").arg(contextToString(modelData.context))
                                    InfoToolTip {
                                        title: i18n("The type of icon this directory has.")

                                        subtitle: i18n("%1: %2")
                                                   .arg(contextToString(modelData.context))
                                                   .arg(contextToDescription(modelData.context))
                                    }
                                }
                                Kirigami.Separator { Layout.fillHeight: true }
                                Label {
                                    opacity: 0.8
                                    text: i18n("Type: %1").arg(typeToString(modelData.type))
                                    InfoToolTip { 
                                        title: i18n ("How this icon can change size.")
                                        
                                        subtitle: i18n("%1: %2")
                                                   .arg(typeToString(modelData.type))
                                                   .arg(typeToDescription(modelData.type))
                                    }
                                }
                                Kirigami.Separator {
                                    visible: modelData.type == IconDirectory.Threshold || modelData.type == IconDirectory.Scalable
                                    Layout.fillHeight: true
                                }
                                Label {
                                    opacity: 0.8
                                    visible: modelData.type == IconDirectory.Threshold
                                    text: i18n("Threshold: %1").arg(modelData.threshold)
                                    InfoToolTip { 
                                        subtitle: i18n("The icons in this directory can be used if the size differs at most by a factor of <b>%1</b> from the source size.").arg(modelData.threshold)
                                    }
                                }
                                Label {
                                    opacity: 0.8
                                    visible: modelData.type == IconDirectory.Scalable
                                    text: i18n("Size Range: <b>%1</b> to <b>%2</b>").arg(modelData.minSize).arg(modelData.maxSize)
                                    InfoToolTip { 
                                        subtitle: i18n("The icons in this directory can be used at sizes from <b>%1</b>dp to <b>%2</b>dp.").arg(modelData.minSize).arg(modelData.maxSize)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    initialRoute: "home"

    Kirigami.PageRoute {
        name: "home"
        Kirigami.ScrollablePage {
            title: i18n("Icon Themes")

            ListView {
                model: ThemeModel
                delegate: Kirigami.SwipeListItem {
                    Kirigami.PageRouter.watchedRoute: ["home", {"route": "folders", "data": iconTheme}]
                    checked: Kirigami.PageRouter.watchedRouteActive

                    Label {
                        text: i18nc("theme name (folder name)", "%1 (%2)").arg(iconTheme.displayName).arg(iconTheme.name)
                    }

                    actions: [
                        Kirigami.Action {
                            icon.name: "document-open"
                            onTriggered: Qt.openUrlExternally("file://"+iconTheme.rootPath)
                        }
                    ]

                    onClicked: Kirigami.PageRouter.pushFromHere({"route": "folders", "data": iconTheme})
                }
            }
        }
    }
}