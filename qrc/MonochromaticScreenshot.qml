import QtQuick 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import me.appadeia.Ikona 1.0

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
                            source: "file:/tmp/ikonalight.svg"
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
                            size: model["size"]
                            anchors.bottom: parent.bottom
                            source: "file:/tmp/ikonadark.svg"
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
    }
    Row {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: Kirigami.Units.smallSpacing
        LightIcon {
            size: 32
            source: "qrc:/ikona.svg"
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            color: root.rightColor
            text: "Montage made with Ikona"
        }
    }
    IconManipulator {
        id: manip
    }
    function open() {
        manip.prepMono(root.imageSource);
        screenshotSavePicker.open()
    }
    FileDialog {
        id: screenshotSavePicker
        selectExisting: false
        selectMultiple: false
        selectFolder: false
        onAccepted: {
            screenRoot.grabToImage(function(result) {
                res = result.saveToFile(screenshotSavePicker.fileUrl.toString().slice(7));
                console.log(res);
            });
        }
        nameFilters: [ "PNG screenshot files (*.png)" ]
    }
}