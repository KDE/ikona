import QtQuick 2.12
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

Item {
    id: screenRoot
    visible: false
    width: 800
    height: 400 + (400 * 1/3)
    Item {
        anchors.fill: parent
        Row {
            anchors.fill: parent
            ColumnLayout {
                spacing: 0
                height: parent.height
                width: parent.width / 2
                Image {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    source: "qrc:/bg.jpg"
                    Grid {
                        anchors.fill: parent
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
                }
                Rectangle {
                    height: 400 * 1/3
                    Layout.fillWidth: true
                    color: root.leftColor
                    Grid {
                        anchors.fill: parent
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
                    Behavior on color {
                        ColorAnimation {
                            duration: Kirigami.Units.longDuration
                        }
                    }
                }
            }
            ColumnLayout {
                spacing: 0
                height: parent.height
                width: parent.width / 2
                Image {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    source: "qrc:/bg-dark.jpg"
                    Grid {
                        anchors.fill: parent
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
                }
                Rectangle {
                    color: root.rightColor
                    height: 400 * 1/3
                    Layout.fillWidth: true
                    Grid {
                        anchors.fill: parent
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
            text: i18n("Montage made with Ikona")
        }
    }
    function open() {
        screenshotSavePicker.open()
    }
    function clisave(loc) {
        screenRoot.grabToImage(function(result) {
            result.saveToFile(loc);
            Qt.quit();
        });
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