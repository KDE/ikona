import QtQuick 2.2
import QtQuick.Controls 2.5 as QQC2
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.3

import org.kde.kirigami 2.8 as Kirigami

Item {
    id: dualMontage
    visible: false
    height: 512
    width: 512
    Kirigami.Theme.inherit: false
    function shot() {
        ssPicker.open()
    }
    FileDialog {
        id: ssPicker
        selectExisting: false
        selectMultiple: false
        selectFolder: false
        onAccepted: {
            dualMontage.grabToImage(function(result) {
                res = result.saveToFile(ssPicker.fileUrl.toString().slice(7))
            });
        }
        nameFilters: [ "PNG screenshot files (*.png)" ]
    }
    Column {
        Rectangle {
            height: 256
            width: 512
            color: Kirigami.Theme.backgroundColor
            Kirigami.Theme.inherit: false
            Kirigami.Theme.textColor: "#232629"
            Kirigami.Theme.backgroundColor: "#eff0f1"
            Kirigami.Theme.highlightColor: "#3daee9"
            Kirigami.Theme.highlightedTextColor: "#eff0f1"
            Kirigami.Theme.positiveTextColor: "#27ae60"
            Kirigami.Theme.neutralTextColor: "#f67400"
            Kirigami.Theme.negativeTextColor: "#da4453"

            GridLayout {
                id: previewGrid
                anchors.centerIn: parent
                columns: sizes.length
                rows: 2
                property var sizes: [8, 16, 22, 32, 48, 64, 128]
                Repeater {
                    model: previewGrid.sizes.length
                    delegate: Kirigami.Icon {
                        Layout.alignment: Qt.AlignBottom
                        source: root.normalPath
                        width: previewGrid.sizes[index]
                        height: previewGrid.sizes[index]
                    }
                }
                Repeater {
                    model: previewGrid.sizes.length
                    delegate: QQC2.Label {
                        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                        text: previewGrid.sizes[index]
                    }
                }
            }
            Row {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: Kirigami.Units.smallSpacing
                Kirigami.Icon {
                    height: 32
                    width: 32
                    source: "org.kde.Ikona"
                }
                QQC2.Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: i18nc("Overlaid on top of an image to indicate that it was made with Ikona", "Montage made with Ikona")
                }
            }
        }
        Rectangle {
            height: 256
            width: 512
            color: Kirigami.Theme.backgroundColor
            Kirigami.Theme.inherit: false
            Kirigami.Theme.textColor: "#eff0f1"
            Kirigami.Theme.backgroundColor: "#31363b"
            Kirigami.Theme.highlightColor: "#3daee9"
            Kirigami.Theme.highlightedTextColor: "#eff0f1"
            Kirigami.Theme.positiveTextColor: "#27ae60"
            Kirigami.Theme.neutralTextColor: "#f67400"
            Kirigami.Theme.negativeTextColor: "#da4453"

            GridLayout {
                anchors.centerIn: parent
                columns: sizes.length
                rows: 2
                property var sizes: [8, 16, 22, 32, 48, 64, 128]
                Repeater {
                    model: previewGrid.sizes.length
                    delegate: Kirigami.Icon {
                        Layout.alignment: Qt.AlignBottom
                        source: root.normalPath
                        width: previewGrid.sizes[index]
                        height: previewGrid.sizes[index]
                    }
                }
                Repeater {
                    model: previewGrid.sizes.length
                    delegate: QQC2.Label {
                        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                        text: previewGrid.sizes[index]
                    }
                }
            }
        }
    }
}
