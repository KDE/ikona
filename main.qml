import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import QtGraphicalEffects 1.12
import me.appadeia.IconSetter 1.0
import Qt.labs.settings 1.1
import Qt.labs.platform 1.1 as QNative

Kirigami.ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 400 + (400 * 1/3)
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    property var leftColor: "white"
    property var rightColor: "#121212"
    property string imageSource: "file://usr/share/icons/hicolor/scalable/apps/yast-isns.svg"
    property var icons: ["utilities-terminal", "accessories-calculator", "yast", "system-file-manager", "kate", "systemsettings", "system-help", "plasmadiscover", "gimp", "kwin", "sublime-merge", "krdc", "juk", "internet-mail", "okteta", "mpv", "calligrastage", "fingerprint-gui", "cantor", "knotes", "applications-science", "user-desktop", "dialog-positive", "dialog-question", "application-x-rdata", "video-x-flv", "image-jpeg2000", "cups"]
    property string fromIconTemplate: ""

    Shortcut {
        sequence: StandardKey.Open
        onActivated: picker.open()
    }
    Shortcut {
        sequence: "Ctrl+R"
        onActivated: root.icons = root.shuffle(root.icons)
    }
    Shortcut {
        sequence: "Ctrl+L"
        onActivated: leftColorPicker.open()
    }
    Shortcut {
        sequence: "Ctrl+D"
        onActivated: rightColorPicker.open()
    }
    Shortcut {
        sequence: StandardKey.NextChild
        onActivated: swipe.currentIndex == 0 ? swipe.incrementCurrentIndex() : swipe.decrementCurrentIndex()
    }

    QNative.MenuBar {
        QNative.Menu {
            title: "Icon"
            QNative.MenuItem {
                iconName: "document-open-symbolic"
                text: "Open SVG..."
                onTriggered: picker.open()
                shortcut: StandardKey.Open
            }
            QNative.MenuItem {
                shortcut: "Ctrl+R"
                iconName: "randomize"
                text: "Shuffle Example Icons"
                onTriggered: root.icons = root.shuffle(root.icons)
            }
            QNative.MenuItem {
                iconName: "exchange-positions"
                text: "Set Icon Theme (Requires Restart)"
                onTriggered: iconThemeNameDrawer.prompt()
            }
            QNative.MenuSeparator {}
            QNative.Menu {
                iconName: "document-new-symbolic"
                title: "New Icon from Breeze Templates"
                QNative.MenuItem {
                    text: "16px Monochrome"
                    onTriggered: {
                        root.fromIconTemplate = "/usr/share/templates/.source/svg-16-monochrome.svg"
                        savePicker.open()
                    }
                }
                QNative.MenuItem {
                    text: "22px Monochrome"
                    onTriggered: {
                        root.fromIconTemplate = "/usr/share/templates/.source/svg-22-monochrome.svg"
                        savePicker.open()
                    }
                }
                QNative.MenuItem {
                    text: "32px Monochrome"
                    onTriggered: {
                        root.fromIconTemplate = "/usr/share/templates/.source/svg-32-monochrome.svg"
                        savePicker.open()
                    }
                }
                QNative.MenuItem {
                    text: "32px Color"
                    onTriggered: {
                        root.fromIconTemplate = "/usr/share/templates/.source/svg-32-color.svg"
                        savePicker.open()
                    }
                }
                QNative.MenuItem {
                    text: "48px Color"
                    onTriggered: {
                        root.fromIconTemplate = "/usr/share/templates/.source/svg-48-color.svg"
                        savePicker.open()
                    }
                }
                QNative.MenuItem {
                    text: "64px Color"
                    onTriggered: {
                        root.fromIconTemplate = "/usr/share/templates/.source/svg-64-color.svg"
                        savePicker.open()
                    }
                }
            }
        }
        QNative.Menu {
            title: "Colors"
            QNative.MenuItem {
                shortcut: "Ctrl+L"
                iconName: "color-picker"
                text: "Change Light Color"
                onTriggered: leftColorPicker.open()
            }
            QNative.MenuItem {
                shortcut: "Ctrl+D"
                iconName: "color-picker"
                text: "Change Dark Color"
                onTriggered: rightColorPicker.open()
            }
            QNative.MenuSeparator {}
            QNative.Menu {
                title: "Pick Colors from Theme"
                QNative.MenuItem {
                    text: "Material Design"
                    onTriggered: {
                        root.leftColor = "white"
                        root.rightColor = "#121212"
                    }
                }
                QNative.MenuItem {
                    text: "Breeze"
                    onTriggered: {
                        root.leftColor = "#eff0f1"
                        root.rightColor = "#31363b"
                    }
                }
                QNative.MenuItem {
                    text: "Adwaita"
                    onTriggered: {
                        root.leftColor = "#f6f5f4"
                        root.rightColor = "#353535"
                    }
                }
            }
        }
        QNative.Menu {
            title: "Palettes"
            QNative.MenuItem {
                iconName: "palette-symbolic"
                text: "View Breeze Colors"
                onTriggered: breezeColorsDrawer.open()
            }
        }
        QNative.Menu {
            title: "View"
            QNative.MenuItem {
                shortcut: StandardKey.NextChild
                iconName: "exchange-positions"
                text: swipe.currentIndex == 0 ? "Go to Small View" : "Return to Large View"
                onTriggered: swipe.currentIndex == 0 ? swipe.incrementCurrentIndex() : swipe.decrementCurrentIndex()
            }
        }
    }

    Component.onCompleted: {
        if (Qt.application.arguments[1] != null) {
            root.imageSource = "file:/" + Qt.application.arguments[1]
        }
        console.log(root.imageSource)
    }
    Settings {
        property alias x: root.x
        property alias y: root.y
        property alias imageSource: root.imageSource
        property alias leftColor: root.leftColor
        property alias rightColor: root.rightColor
    }
    IconSetter {
        id: setter
    }

    title: qsTr("Ikona")
    color: Kirigami.Theme.backgroundColor
    Kirigami.GlobalDrawer {
            id:    sidebar
            titleIcon: "ikona"
            title: "Ikona"
            actions: [
                Kirigami.Action {
                    iconSource: "document-open-symbolic"
                    text: "Open SVG..."
                    onTriggered: {
                        picker.open()
                    }
                },
                Kirigami.Action {
                    iconSource: "view-list-icons"
                    text: "Icons"
                    Kirigami.Action {
                        iconSource: "document-new-symbolic"
                        text: "New Icon from Breeze Templates"
                        Kirigami.Action {
                            text: "16px Monochrome Icon"
                            onTriggered: {
                                root.fromIconTemplate = "/usr/share/templates/.source/svg-16-monochrome.svg"
                                savePicker.open()
                            }
                        }
                        Kirigami.Action {
                            text: "22px Monochrome Icon"
                            onTriggered: {
                                root.fromIconTemplate = "/usr/share/templates/.source/svg-22-monochrome.svg"
                                savePicker.open()
                            }
                        }
                        Kirigami.Action {
                            text: "32px Monochrome Icon"
                            onTriggered: {
                                root.fromIconTemplate = "/usr/share/templates/.source/svg-32-monochrome.svg"
                                savePicker.open()
                            }
                        }
                        Kirigami.Action {
                            text: "32px Colour Icon"
                            onTriggered: {
                                root.fromIconTemplate = "/usr/share/templates/.source/svg-32-color.svg"
                                savePicker.open()
                            }
                        }
                        Kirigami.Action {
                            text: "48px Colour Icon"
                            onTriggered: {
                                root.fromIconTemplate = "/usr/share/templates/.source/svg-48-color.svg"
                                savePicker.open()
                            }
                        }
                        Kirigami.Action {
                            text: "64px Colour Icon"
                            onTriggered: {
                                root.fromIconTemplate = "/usr/share/templates/.source/svg-64-color.svg"
                                savePicker.open()
                            }
                        }
                    }
                    Kirigami.Action {
                        iconSource: "exchange-positions"
                        text: "Change Icon Theme"
                        onTriggered: {
                            iconThemeNameDrawer.prompt()
                        }
                    }
                    Kirigami.Action {
                        iconSource: "randomize"
                        text: "Shuffle Example Icons"
                        onTriggered: {
                            root.icons = root.shuffle(root.icons);
                        }
                    }
                },
                Kirigami.Action {
                    iconSource: "color-picker"
                    text: "Set Colors"
                    Kirigami.Action {
                        text: "Change Light Color"
                        onTriggered: {
                            leftColorPicker.open()
                        }
                    }
                    Kirigami.Action {
                        text: "Change Dark Color"
                        onTriggered: {
                            rightColorPicker.open()
                        }
                    }
                    Kirigami.Action {
                        text: "Set Colors From Theme"
                        Kirigami.Action {
                            text: "Material Colors"
                            onTriggered: {
                                root.leftColor = "white"
                                root.rightColor = "#121212"
                            }
                        }
                        Kirigami.Action {
                            text: "Breeze Colors"
                            onTriggered: {
                                root.leftColor = "#eff0f1"
                                root.rightColor = "#31363b"
                            }
                        }
                        Kirigami.Action {
                            text: "Adwaita Colors"
                            onTriggered: {
                                root.leftColor = "#f6f5f4"
                                root.rightColor = "#353535"
                            }
                        }
                    }
                },
                Kirigami.Action {
                    iconSource: "palette-symbolic"
                    text: "View Palettes"
                    Kirigami.Action {
                        text: "Breeze Palette"
                        onTriggered: {
                            breezeColorsDrawer.open()
                        }
                    }
                },
                Kirigami.Action {
                    iconSource: "exchange-positions"
                    text: swipe.currentIndex == 0 ? "Go to Small View" : "Return to Large View"
                    onTriggered: swipe.currentIndex == 0 ? swipe.incrementCurrentIndex() : swipe.decrementCurrentIndex()
                }
            ]
    }
    function shuffle(a) {
        var j, x, i;
        for (i = a.length - 1; i > 0; i--) {
            j = Math.floor(Math.random() * (i + 1));
            x = a[i];
            a[i] = a[j];
            a[j] = x;
        }
        return a;
    }
    Kirigami.OverlayDrawer {
        id:             breezeColorsDrawer
        edge:           Qt.BottomEdge
        height: root.height * 0.9

        contentItem: ScrollView {
            anchors.fill: parent
            clip: true
            Column {
                Kirigami.Heading {
                    text: "Breeze Colors"
                }
                Kirigami.Heading {
                    font.pointSize: 12
                    text: "Neutral Colors"
                }
                Flow {
                    width: 800
                    ColorSwatch {
                        swatchColor: "#fcfcfc"
                        fancyName: "Paper White"
                    }
                    ColorSwatch {
                        swatchColor: "#eff0f1"
                        fancyName: "Cardboard Grey"
                    }
                    ColorSwatch {
                        swatchColor: "#bdc3c7"
                        fancyName: "Alternate Grey"
                    }
                    ColorSwatch {
                        swatchColor: "#95a5a6"
                        fancyName: "Alternate Alternate Grey"
                    }
                    ColorSwatch {
                        swatchColor: "#7f8c8d"
                        fancyName: "Coastal Fog"
                    }
                    ColorSwatch {
                        swatchColor: "#4d4d4d"
                        fancyName: "Icon Grey"
                    }
                    ColorSwatch {
                        swatchColor: "#31363b"
                        fancyName: "Charcoal Grey"
                    }
                    ColorSwatch {
                        swatchColor: "#232627"
                        fancyName: "Shade Black"
                    }
                }
                Kirigami.Heading {
                    font.pointSize: 12
                    text: "Warm Colors"
                }
                Flow {
                    width: 800
                    ColorSwatch {
                        swatchColor: "#e74c3c"
                        fancyName: "Pimpinella"
                    }
                    ColorSwatch {
                        swatchColor: "#da4453"
                        fancyName: "Icon Red"
                    }
                    ColorSwatch {
                        swatchColor: "#ed1515"
                        fancyName: "Danger Red"
                    }
                    ColorSwatch {
                        swatchColor: "#c0392b"
                        fancyName: "Alternate Red"
                    }
                    ColorSwatch {
                        swatchColor: "#f47750"
                        fancyName: "Icon Orange"
                    }
                    ColorSwatch {
                        swatchColor: "#d35400"
                        fancyName: "Alternate Orange"
                    }
                    ColorSwatch {
                        swatchColor: "#fdbc4b"
                        fancyName: "Icon Yellow"
                    }
                    ColorSwatch {
                        swatchColor: "#f67400"
                        fancyName: "Beware Orange"
                    }
                    ColorSwatch {
                        swatchColor: "#c9ce3b"
                        fancyName: "Sunbeam Yellow"
                    }
                    ColorSwatch {
                        swatchColor: "#f39c1f"
                        fancyName: "Alternate Alternate Orange"
                    }
                }
                Kirigami.Heading {
                    font.pointSize: 12
                    text: "Cool Colors"
                }
                Flow {
                    width: 800
                    ColorSwatch {
                        swatchColor: "#1cdc9a"
                        fancyName: "Mellow Turquoise"
                    }
                    ColorSwatch {
                        swatchColor: "#11d116"
                        fancyName: "Verdant Green"
                    }
                    ColorSwatch {
                        swatchColor: "#11d116"
                        fancyName: "Verdant Green"
                    }
                    ColorSwatch {
                        swatchColor: "#2ecc71"
                        fancyName: "Icon Green"
                    }
                    ColorSwatch {
                        swatchColor: "#27ae60"
                        fancyName: "Noble Fir"
                    }
                    ColorSwatch {
                        swatchColor: "#1abc9c"
                        fancyName: "Teal"
                    }
                    ColorSwatch {
                        swatchColor: "#16a085"
                        fancyName: "Alternate Teal"
                    }
                    ColorSwatch {
                        swatchColor: "#3498db"
                        fancyName: "Alternate Blue"
                    }
                    ColorSwatch {
                        swatchColor: "#2980b9"
                        fancyName: "Abyss Blue"
                    }
                    ColorSwatch {
                        swatchColor: "#3daee9"
                        fancyName: "Plasma Blue"
                    }
                    ColorSwatch {
                        swatchColor: "#1d99f3"
                        fancyName: "Icon Blue"
                    }
                    ColorSwatch {
                        swatchColor: "#9b59b6"
                        fancyName: "Purple"
                    }
                    ColorSwatch {
                        swatchColor: "#8e44ad"
                        fancyName: "Alternate Purple"
                    }
                }
            }
        }
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
        id: savePicker
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var exitCode = data["exit code"]
            var stdout = data["stdout"]

            if (exitCode == 0) {
                setter.copy(root.fromIconTemplate, stdout.trim())
                root.imageSource = "file:/" + stdout.trim()
                setter.xdgOpen(stdout.trim())
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
            savePicker.exec("kdialog --getsavefilename . 'SVG Icon Files (*.svg)'", function(){});
        }

        signal exited(string sourceName, string stdout)

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
                setter.linkIcon(stdout.trim())
                root.imageSource = "ikonapreviewicon";
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
    PlasmaCore.DataSource {
        id: leftColorPicker
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var exitCode = data["exit code"]
            var stdout = data["stdout"]

            if (exitCode == 0) {
                root.leftColor = stdout.trim()
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
            leftColorPicker.exec("kdialog --getcolor", function(){});
        }

        signal exited(string sourceName, string stdout)

    }
    PlasmaCore.DataSource {
        id: rightColorPicker
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var exitCode = data["exit code"]
            var stdout = data["stdout"]

            if (exitCode == 0) {
                root.rightColor = stdout.trim()
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
            rightColorPicker.exec("kdialog --getcolor", function(){});
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

    SwipeView {
        id: swipe
        anchors.fill: parent
        Item {
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
                                    source: root.icons[0]
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
                                    source: root.icons[1]
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
                                    source: root.icons[2]
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
                                    source: root.icons[3]
                                }
                            }
                            Rectangle {
                                width: light.width / 3
                                height: light.height / 3
                                color: "transparent"
                                LightIcon {
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
                                    source: root.icons[4]
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
                                    source: root.icons[5]
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
                                    source: root.icons[6]
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
                                    source: root.icons[7]
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
                                    source: root.icons[0]
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
                                    source: root.icons[1]
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
                                    source: root.icons[2]
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
                                    source: root.icons[3]
                                }
                            }
                            Rectangle {
                                width: dark.width / 3
                                height: dark.height / 3
                                color: "transparent"
                                DarkIcon {
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
                                    source: root.icons[4]
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
                                    source: root.icons[5]
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
                                    source: root.icons[6]
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
                                    source: root.icons[7]
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
                            color: root.leftColor
                            Behavior on color {
                                ColorAnimation {
                                    duration: 500
                                }
                            }
                        }
                        Row {
                            id: lightManyRow
                            anchors.fill: parent
                            Rectangle {
                                width: parent.width / 4
                                height: parent.height
                                color: "transparent"
                                LightIcon {
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
                                LightIcon {
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
                                LightIcon {
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
                                LightIcon {
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
                            color: root.rightColor
                            Behavior on color {
                                ColorAnimation {
                                    duration: 500
                                }
                            }
                        }
                        Row {
                            id: darkManyRow
                            anchors.fill: parent
                            Rectangle {
                                width: parent.width / 4
                                height: parent.height
                                color: "transparent"
                                DarkIcon {
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
                                DarkIcon {
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
                                DarkIcon {
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
                                DarkIcon {
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
                anchors.centerIn: parent
                Item {
                    height: 400 * 1/4
                    width: 400
                    id: symLightMany
                    Row {
                        id: symLightManyRow
                        anchors.fill: parent
                        Rectangle {
                            width: parent.width / 3
                            height: parent.height
                            color: "transparent"
                            LightIcon {
                                id: symLight16
                                anchors.centerIn: parent
                                height: 8
                                width: 8
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: symLight16.horizontalCenter
                                anchors.top: symLight16.bottom
                                color: "black"
                                text: "8"
                            }
                        }
                        Rectangle {
                            width: parent.width / 3
                            height: parent.height
                            color: "transparent"
                            LightIcon {
                                id: symLight22
                                anchors.centerIn: parent
                                height: 16
                                width: 16
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: symLight22.horizontalCenter
                                anchors.top: symLight22.bottom
                                color: "black"
                                text: "16"
                            }
                        }
                        Rectangle {
                            width: parent.width / 3
                            height: parent.height
                            color: "transparent"
                            LightIcon {
                                id: symLight32
                                anchors.centerIn: parent
                                height: 22
                                width: 22
                                source: root.imageSource
                            }
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: symLight32.horizontalCenter
                                anchors.top: symLight32.bottom
                                color: "black"
                                text: "22"
                            }
                        }
                    }
                }
                Item {
                    height: 400 * 1/4
                    width: 400
                    id: symDarkMany
                    Row {
                        id: symDarkManyRow
                        anchors.fill: parent
                        Rectangle {
                            width: parent.width / 3
                            height: parent.height
                            color: "transparent"
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: symDark16.horizontalCenter
                                anchors.top: symDark16.bottom
                                color: "white"
                                text: "8"
                            }
                            DarkIcon {
                                id: symDark16
                                anchors.centerIn: parent
                                height: 8
                                width: 8
                                source: root.imageSource
                            }
                        }
                        Rectangle {
                            width: parent.width / 3
                            height: parent.height
                            color: "transparent"
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: symDark22.horizontalCenter
                                anchors.top: symDark22.bottom
                                color: "white"
                                text: "16"
                            }
                            DarkIcon {
                                id: symDark22
                                anchors.centerIn: parent
                                height: 16
                                width: 16
                                source: root.imageSource
                            }
                        }
                        Rectangle {
                            width: parent.width / 3
                            height: parent.height
                            color: "transparent"
                            PlasmaComponents.Label {
                                anchors.horizontalCenter: symDark32.horizontalCenter
                                anchors.top: symDark32.bottom
                                color: "white"
                                text: "22"
                            }
                            DarkIcon {
                                id: symDark32
                                anchors.centerIn: parent
                                height: 22
                                width: 22
                                source: root.imageSource
                            }
                        }
                    }
                }
            }
        }
    }
}
