import QtQuick 2.0
import QtQuick.Layouts 1.13

import org.kde.kirigami 2.5 as Kirigami

Row {
    id: monoRoot
    property var sizes: [8, 16, 22, 32]

    Rectangle {
        height: parent.height
        width: parent.width / 2
        color: "#eff0f1"
        Row {
            spacing: Kirigami.Units.largeSpacing
            anchors.centerIn: parent
            ColumnLayout {
                Repeater {
                    model: sizes
                    DisplayIcon {
                        Kirigami.Theme.inherit: false
                        Kirigami.Theme.textColor: "#232629"
                        Kirigami.Theme.backgroundColor: "#eff0f1"
                        Kirigami.Theme.highlightColor: "#3daee9"
                        Kirigami.Theme.highlightedTextColor: "#eff0f1"
                        Kirigami.Theme.positiveTextColor: "#27ae60"
                        Kirigami.Theme.neutralTextColor: "#f67400"
                        Kirigami.Theme.negativeTextColor: "#da4453"

                        Layout.alignment: Qt.AlignHCenter
                        size: modelData
                        source: "list-add"
                        labelColor: "black"
                        showLabel: true
                    }
                }
            }
            ColumnLayout {
                Repeater {
                    model: sizes
                    DisplayIcon {
                        Layout.alignment: Qt.AlignHCenter
                        size: modelData
                        source: root.darkPath
                        labelColor: "black"
                        showLabel: true
                    }
                }
            }
            ColumnLayout {
                Repeater {
                    model: sizes
                    DisplayIcon {
                        Kirigami.Theme.inherit: false
                        Kirigami.Theme.textColor: "#232629"
                        Kirigami.Theme.backgroundColor: "#eff0f1"
                        Kirigami.Theme.highlightColor: "#3daee9"
                        Kirigami.Theme.highlightedTextColor: "#eff0f1"
                        Kirigami.Theme.positiveTextColor: "#27ae60"
                        Kirigami.Theme.neutralTextColor: "#f67400"
                        Kirigami.Theme.negativeTextColor: "#da4453"

                        Layout.alignment: Qt.AlignHCenter
                        size: modelData
                        source: "view-list-details"
                        labelColor: "black"
                        showLabel: true
                    }
                }
            }
        }
    }
    Rectangle {
        height: parent.height
        width: parent.width / 2
        color: "#232629"
        Row {
            anchors.centerIn: parent
            spacing: Kirigami.Units.largeSpacing
            ColumnLayout {
                Repeater {
                    model: sizes
                    DisplayIcon {
                        Kirigami.Theme.inherit: false
                        Kirigami.Theme.textColor: "#eff0f1"
                        Kirigami.Theme.backgroundColor: "#31363b"
                        Kirigami.Theme.highlightColor: "#3daee9"
                        Kirigami.Theme.highlightedTextColor: "#eff0f1"
                        Kirigami.Theme.positiveTextColor: "#27ae60"
                        Kirigami.Theme.neutralTextColor: "#f67400"
                        Kirigami.Theme.negativeTextColor: "#da4453"

                        Layout.alignment: Qt.AlignHCenter
                        size: modelData
                        source: "list-add"
                        labelColor: "white"
                        showLabel: true
                    }
                }
            }
            ColumnLayout {
                Repeater {
                    model: sizes
                    DisplayIcon {
                        Layout.alignment: Qt.AlignHCenter
                        size: modelData
                        source: root.lightPath
                        labelColor: "white"
                        showLabel: true
                    }
                }
            }
            ColumnLayout {
                Repeater {
                    model: sizes
                    DisplayIcon {
                        Kirigami.Theme.inherit: false
                        Kirigami.Theme.textColor: "#eff0f1"
                        Kirigami.Theme.backgroundColor: "#31363b"
                        Kirigami.Theme.highlightColor: "#3daee9"
                        Kirigami.Theme.highlightedTextColor: "#eff0f1"
                        Kirigami.Theme.positiveTextColor: "#27ae60"
                        Kirigami.Theme.neutralTextColor: "#f67400"
                        Kirigami.Theme.negativeTextColor: "#da4453"

                        Layout.alignment: Qt.AlignHCenter
                        size: modelData
                        source: "view-list-details"
                        labelColor: "white"
                        showLabel: true
                    }
                }
            }
        }
    }
}
