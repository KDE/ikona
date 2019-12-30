import QtQuick 2.0
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Kirigami.ApplicationWindow {
    title: i18nc("The window title of the colour palette", "Colour Palette")
    visible: false
    width: 300
    height: 820
    minimumHeight: 820
    minimumWidth: 300

    Rectangle {
        color: "#8f8f8f"
        anchors.fill: col
        anchors.margins: -20
        radius: 5
    }

    ColumnLayout {
        id: col
        anchors.centerIn: parent
        spacing: 0
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#a20967", "#cb0b81", "#e93a9a", "#ff5bb6", "#ff7cc5"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#99002e", "#bf0039", "#e93d58", "#ff6c7f", "#ff8999"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#a43e1e", "#cd4d25", "#e9643a", "#ff8255", "#ff9b77"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#a6641a", "#d07d20", "#ef973c", "#ffb256", "#ffc178"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#9d8900", "#c4ab00", "#e8cb2d", "#ffe247", "#ffe86c"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#7aa100", "#99c900", "#b6e521", "#d1ff43", "#daff69"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#469922", "#57bf2a", "#3dd425", "#59f07c", "#7af396"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#009356", "#00b86b", "#00d485", "#1ff1a0", "#4cf4b3"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#00927e", "#00b79d", "#00d3b8", "#44f0d3", "#69f3dc"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#228199", "#2aa1bf", "#3daee9", "#6dd3ff", "#8adcff"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#7d499a", "#9c5bc0", "#b875dc", "#d792e7", "#dfa8ec"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#5e44a0", "#7655c8", "#926ee4", "#af88ff", "#bfa0ff"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#101114", "#1a1b1e", "#232629", "#2e3134", "#393c3f"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#4f5356", "#5c5f62", "#686b6f", "#818488", "#9b9ea2"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#a8abb0", "#b6b9bd", "#d1d5d9", "#eef1f5", "#fcffff"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#440000", "#5d1800", "#6a250e", "#783019", "#873c23"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#95482f", "#b26145", "#cb775a", "#ed9576", "#ffb090"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#00223e", "#003756", "#004e6e", "#036688", "#327fa2"]
                ColorBlock {
                    color: modelData
                }
            }
        }
        Row {
            Layout.alignment: Qt.AlignHCenter
            Repeater {
                model: ["#5199bd", "#6eb4d9", "#8acff6", "#abe9fb"]
                ColorBlock {
                    color: modelData
                }
            }
        }
    }
}
