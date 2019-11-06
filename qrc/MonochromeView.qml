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