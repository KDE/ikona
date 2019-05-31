import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Kirigami.ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 400
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    property url imageSource: "file://usr/share/icons/hicolor/scalable/apps/yast-isns.svg"

    Component.onCompleted: {
        if (Qt.application.arguments[1] != null) {
            root.imageSource = "file:/" + Qt.application.arguments[1]
        }
    }

    title: qsTr("Icon Preview")
    color: Kirigami.Theme.backgroundColor
    Kirigami.GlobalDrawer {
            id:    sidebar
            title: "Icon Viewer"
            actions: [
                Kirigami.Action {
                    iconSource: "document-open-symbolic"
                    text: "Open SVG"
                    onTriggered: {
                        picker.open()
                    }
                }
            ]
    }
    PlasmaCore.DataSource {
        id: picker
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var exitCode = data["exit code"]
            var stdout = data["stdout"]

            if (exitCode == 0) {
                root.imageSource = "file:/" + stdout.trim()
            } else {

            }

            if (callbacks[sourceName] !== undefined) {
                callbacks[sourceName](stdout);
            }

            exited(sourceName, stdout)
            disconnectSource(sourceName) // cmd finished
        }

        function exec(cmd, onNewDataCallback) {
            if (onNewDataCallback !== undefined){
                callbacks[cmd] = onNewDataCallback
            }
            connectSource(cmd)

        }
        function open() {
            picker.exec("kdialog --getopenfilename . 'SVG Icon Files (*.svg)'", function(){});
        }

        signal exited(string sourceName, string stdout)

    }
    Timer {
        interval: 250
        repeat: true
        running: true
        onTriggered: {
            var temp = root.imageSource
            root.imageSource = ""
            root.imageSource = temp
        }
    }
    Row {
        Item {
            id: light
            clip: true
            height: 400
            width: 400
            Image {
                anchors.fill: parent
                source: "qrc:/bg.jpg"
                fillMode: Image.PreserveAspectCrop
            }
            GridLayout {
                columnSpacing: 0
                rowSpacing: 0
                columns: 3
                rows: 3
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    Image {
                        cache: false
                        anchors.centerIn: parent
                        height: 32
                        width: 32
                        source: root.imageSource
                    }
                }
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    Image {
                        cache: false
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: root.imageSource
                    }
                }
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    Image {
                        cache: false
                        anchors.centerIn: parent
                        height: 64
                        width: 64
                        source: root.imageSource
                    }
                }
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "system-file-manager"
                    }
                }
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "accessories-calculator"
                    }
                }
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "kate"
                    }
                }
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "systemsettings"
                    }
                }
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "system-help"
                    }
                }
                Rectangle {
                    width: light.width / 3
                    height: light.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "plasmadiscover"
                    }
                }
            }
        }
        Item {
            id: dark
            height: 400
            width: 400
            Image {
                anchors.fill: parent
                source: "qrc:/bg-dark.jpg"
                fillMode: Image.PreserveAspectCrop
            }
            GridLayout {
                columnSpacing: 0
                rowSpacing: 0
                columns: 3
                rows: 3
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    Image {
                        cache: false
                        anchors.centerIn: parent
                        height: 32
                        width: 32
                        source: root.imageSource
                    }
                }
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    Image {
                        cache: false
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: root.imageSource
                    }
                }
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    Image {
                        cache: false
                        anchors.centerIn: parent
                        height: 64
                        width: 64
                        source: root.imageSource
                    }
                }
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "system-file-manager"
                    }
                }
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "accessories-calculator"
                    }
                }
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "kate"
                    }
                }
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "systemsettings"
                    }
                }
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "system-help"
                    }
                }
                Rectangle {
                    width: dark.width / 3
                    height: dark.height / 3
                    color: "transparent"
                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: "plasmadiscover"
                    }
                }
            }
        }
    }
}
