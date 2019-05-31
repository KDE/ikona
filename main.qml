import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import me.appadeia.IconSetter 1.0
import Qt.labs.settings 1.1

Kirigami.ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 400 + (400 * 1/3)
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
    Settings {
        property alias x: root.x
        property alias y: root.y
        property alias imageSource: root.imageSource
    }
    IconSetter {
        id: setter
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
                },
                Kirigami.Action {
                    iconSource: "exchange-positions"
                    text: "Change Icon Theme"
                    onTriggered: {
                        iconThemeNameDrawer.prompt()
                    }
                }
            ]
    }
    Kirigami.OverlayDrawer {
        id:             iconThemeNameDrawer
        edge:           Qt.BottomEdge
        contentItem: ColumnLayout {
                        Kirigami.Heading {
                            id: textPromptLabel
                            text: "Enter the name of the icon theme"
                        }
                        PlasmaComponents.TextField {
                            Layout.fillWidth: true
                            onAccepted: {
                                setter.setIconTheme(this.text)
                                loader.sourceComponent = contentTwo
                                loader.sourceComponent = contentOne
                                iconThemeNameDrawer.close()
                            }
                        }
        }
        function prompt() {
            iconThemeNameDrawer.open()
        }
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
    Component {
        id: contentOne
        Column {
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
                            PlasmaCore.IconItem {
                                anchors.centerIn: parent
                                height: 48
                                width: 48
                                source: "utilities-terminal"
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
                                source: "yast"
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
                            PlasmaCore.IconItem {
                                anchors.centerIn: parent
                                height: 48
                                width: 48
                                source: "utilities-terminal"
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
                                source: "yast"
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
            Row {
                Item {
                    height: 400 * 1/3
                    width: 400
                    id: lightMany
                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                    }
                    Row {
                        id: lightManyRow
                        anchors.fill: parent
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: light16
                                anchors.centerIn: parent
                                height: 16
                                width: 16
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: light16.horizontalCenter
                                anchors.top: light16.bottom
                                color: "black"
                                text: "16"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: light22
                                anchors.centerIn: parent
                                height: 22
                                width: 22
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: light22.horizontalCenter
                                anchors.top: light22.bottom
                                color: "black"
                                text: "22"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: light32
                                anchors.centerIn: parent
                                height: 32
                                width: 32
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: light32.horizontalCenter
                                anchors.top: light32.bottom
                                color: "black"
                                text: "32"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: light48
                                anchors.centerIn: parent
                                height: 48
                                width: 48
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: light48.horizontalCenter
                                anchors.top: light48.bottom
                                color: "black"
                                text: "48"
                            }
                        }
                    }
                }
                Item {
                    height: 400 * 1/3
                    width: 400
                    id: darkMany
                    Rectangle {
                        anchors.fill: parent
                        color: "#121212"
                    }
                    Row {
                        id: darkManyRow
                        anchors.fill: parent
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: dark16
                                anchors.centerIn: parent
                                height: 16
                                width: 16
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: dark16.horizontalCenter
                                anchors.top: dark16.bottom
                                color: "white"
                                text: "16"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: dark22
                                anchors.centerIn: parent
                                height: 22
                                width: 22
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: dark22.horizontalCenter
                                anchors.top: dark22.bottom
                                color: "white"
                                text: "22"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: dark32
                                anchors.centerIn: parent
                                height: 32
                                width: 32
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: dark32.horizontalCenter
                                anchors.top: dark32.bottom
                                color: "white"
                                text: "32"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: dark48
                                anchors.centerIn: parent
                                height: 48
                                width: 48
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: dark48.horizontalCenter
                                anchors.top: dark48.bottom
                                color: "white"
                                text: "48"
                            }
                        }
                    }
                }
            }
        }
    }
    Component {
        id: contentTwo
        Column {
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
                            PlasmaCore.IconItem {
                                anchors.centerIn: parent
                                height: 48
                                width: 48
                                source: "utilities-terminal"
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
                                source: "yast"
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
                            PlasmaCore.IconItem {
                                anchors.centerIn: parent
                                height: 48
                                width: 48
                                source: "utilities-terminal"
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
                                source: "yast"
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
            Row {
                Item {
                    height: 400 * 1/3
                    width: 400
                    id: lightMany
                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                    }
                    Row {
                        id: lightManyRow
                        anchors.fill: parent
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: light16
                                anchors.centerIn: parent
                                height: 16
                                width: 16
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: light16.horizontalCenter
                                anchors.top: light16.bottom
                                color: "black"
                                text: "16"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: light22
                                anchors.centerIn: parent
                                height: 22
                                width: 22
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: light22.horizontalCenter
                                anchors.top: light22.bottom
                                color: "black"
                                text: "22"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: light32
                                anchors.centerIn: parent
                                height: 32
                                width: 32
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: light32.horizontalCenter
                                anchors.top: light32.bottom
                                color: "black"
                                text: "32"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: light48
                                anchors.centerIn: parent
                                height: 48
                                width: 48
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: light48.horizontalCenter
                                anchors.top: light48.bottom
                                color: "black"
                                text: "48"
                            }
                        }
                    }
                }
                Item {
                    height: 400 * 1/3
                    width: 400
                    id: darkMany
                    Rectangle {
                        anchors.fill: parent
                        color: "#121212"
                    }
                    Row {
                        id: darkManyRow
                        anchors.fill: parent
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: dark16
                                anchors.centerIn: parent
                                height: 16
                                width: 16
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: dark16.horizontalCenter
                                anchors.top: dark16.bottom
                                color: "white"
                                text: "16"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: dark22
                                anchors.centerIn: parent
                                height: 22
                                width: 22
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: dark22.horizontalCenter
                                anchors.top: dark22.bottom
                                color: "white"
                                text: "22"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: dark32
                                anchors.centerIn: parent
                                height: 32
                                width: 32
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: dark32.horizontalCenter
                                anchors.top: dark32.bottom
                                color: "white"
                                text: "32"
                            }
                        }
                        Rectangle {
                            width: parent.width / 4
                            height: parent.height
                            color: "transparent"
                            PlasmaCore.IconItem {
                                id: dark48
                                anchors.centerIn: parent
                                height: 48
                                width: 48
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: dark48.horizontalCenter
                                anchors.top: dark48.bottom
                                color: "white"
                                text: "48"
                            }
                        }
                    }
                }
            }
        }
    }
    Loader {
        id: loader
        sourceComponent: contentOne
    }
}
