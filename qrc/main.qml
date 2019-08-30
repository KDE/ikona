import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import QtGraphicalEffects 1.12
import me.appadeia.Ikona 1.0
import Qt.labs.settings 1.1
import Qt.labs.platform 1.1 as QNative
import QtWebEngine 1.1

Kirigami.ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 400 + (400 * 1/3)
    minimumHeight: 400 + (400 * 1/3)
    minimumWidth: 800
    property var leftColor: "white"
    property var rightColor: "#121212"
    property url imageSource: "qrc:/ikona.svg"
    property var icons: ["utilities-terminal", "accessories-calculator", "yast", "system-file-manager", "kate", "systemsettings", "system-help", "plasmadiscover", "gimp", "kwin", "sublime-merge", "krdc", "juk", "internet-mail", "okteta", "mpv", "calligrastage", "fingerprint-gui", "cantor", "knotes", "applications-science", "user-desktop", "dialog-positive", "dialog-question", "application-x-rdata", "video-x-flv", "image-jpeg2000", "cups"]
    property var symIcons: ["checkbox", "go-previous", "edit-clear-list", "edit-find", "games-achievements", "go-down-search", "process-stop", "draw-brush"]
    property string fromIconTemplate: ""

    QNative.SystemTrayIcon {
        id: sysTray
        visible: false
        icon.source: imageSource
    }
    onClosing: {
        sysTray.visible = false
    }
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
                    text: "16px Action/Status/Filetype"
                    onTriggered: {
                        root.fromIconTemplate = ":templates/mono-16.svg"
                        savePicker.open()
                    }
                }
                QNative.MenuItem {
                    text: "22px Action/Status/Filetype"
                    onTriggered: {
                        root.fromIconTemplate = ":templates/mono-22.svg"
                        savePicker.open()
                    }
                }
                QNative.MenuItem {
                    text: "Application/Large Filetype"
                    onTriggered: {
                        root.fromIconTemplate = ":/templates/colorful.svg"
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
    }

    Settings {
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
        property alias imageSource: root.imageSource
        property alias leftColor: root.leftColor
        property alias rightColor: root.rightColor
    }
    IconSetter {
        id: setter
    }
    IconManipulator {
        id: manipulator
    }
    title: qsTr("Ikona Design Companion")
    color: Kirigami.Theme.backgroundColor
    Kirigami.GlobalDrawer {
            modal: false
            collapsed: true
            collapsible: true
            id:    sidebar
            titleIcon: "ikona"
            title: "Ikona"
            Component.onCompleted: {
                console.log(sidebar.collapsedSize)
            }

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
                            text: "16px Action/Status/Filetype"
                            onTriggered: {
                                root.fromIconTemplate = ":templates/mono-16.svg"
                                savePicker.open()
                            }
                        }
                        Kirigami.Action {
                            text: "22px Action/Status/Filetype"
                            onTriggered: {
                                root.fromIconTemplate = ":templates/mono-22.svg"
                                savePicker.open()
                            }
                        }
                        Kirigami.Action {
                            text: "48px Application/Large Filetype"
                            onTriggered: {
                                root.fromIconTemplate = ":/templates/colorful.svg"
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
                    iconSource: "editimage"
                    text: "Modify Icon"
                    Kirigami.Action {
                        iconSource: "edit-clear-all"
                        text: "Tidy Icon"
                        onTriggered: {
                            if (manipulator.tidyIcon(imageSource)) {
                                root.showPassiveNotification("Your icon has been cleaned.")
                            } else {
                                root.showPassiveNotification("Something went wrong cleaning your icon.")
                            }
                        }
                    }
                    Kirigami.Action {
                        iconSource: "gtk-convert"
                        text: "Convert Icon Colors to Classes"
                        onTriggered: {
                            if (manipulator.classIcon(imageSource)) {
                                root.showPassiveNotification("Your icon has been converted. You should inject stylesheets if they have not already been injected.")
                            } else {
                                root.showPassiveNotification("Something went wrong converting your icon.")
                            }
                        }
                    }
                    Kirigami.Action {
                        iconSource: "code-context"
                        text: "Inject Stylesheets"
                        onTriggered: {
                            if (manipulator.injectStylesheet(imageSource)) {
                                root.showPassiveNotification("Stylesheets have been added to your icon.")
                            } else {
                                root.showPassiveNotification("Something went wrong adding stylesheets to your icon.")
                            }
                        }
                    }
                    Kirigami.Action {
                        iconSource: "color-picker-black"
                        text: "Change Icon to Light Mode"
                        onTriggered: {
                            if (manipulator.toDark(imageSource)) {
                                root.showPassiveNotification("Your icon has been converted.")
                            } else {
                                root.showPassiveNotification("Something went wrong converting your icon.")
                            }
                        }
                    }
                    Kirigami.Action {
                        iconSource: "color-picker-white"
                        text: "Change Icon to Dark Mode"
                        onTriggered: {
                            if (manipulator.toLight(imageSource)) {
                                root.showPassiveNotification("Your icon has been converted.")
                            } else {
                                root.showPassiveNotification("Something went wrong converting your icon.")
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
                    separator: true
                },
                Kirigami.Action {
                    iconName: "go-home"
                    text: "Regular View"
                    enabled: swipe.currentIndex != 0
                    onTriggered: {
                        swipe.currentIndex = 0
                    }
                },
                Kirigami.Action {
                    iconName: "zoom-out"
                    text: "Small View"
                    enabled: swipe.currentIndex != 1
                    onTriggered: {
                        swipe.currentIndex = 1
                    }
                },
                Kirigami.Action {
                    iconName: "internet-services"
                    text: "HIG View"
                    enabled: swipe.currentIndex != 2
                    onTriggered: {
                        swipe.currentIndex = 2
                    }
                },
                Kirigami.Action {
                    iconName: "zoom-in"
                    text: "Large View"
                    enabled: swipe.currentIndex != 3
                    onTriggered: {
                        swipe.currentIndex = 3
                    }
                },
                Kirigami.Action {
                    separator: true
                },
                Kirigami.Action {
                    id: pullDown
                    iconName: checked ? "window-shade" : "window-unshade"
                    text: "Pull Down Drawers"
                    checkable: true
                },
                Kirigami.Action {
                    separator: true
                },
                Kirigami.Action {
                    iconName: hud.visible ? "view-hidden" : "view-visible"
                    text: hud.visible ? "Close HUD" : "Open HUD"
                    onTriggered: hud.visible = !hud.visible
                },
                Kirigami.Action {
                    iconName: sysTray.visible ? "view-hidden" : "view-visible"
                    text: sysTray.visible ? "Hide Icon in Tray" : "Show Icon in Tray"
                    onTriggered: sysTray.visible = !sysTray.visible
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
                width: root.width
                Kirigami.Heading {
                    text: "Breeze Colors"
                }
                Kirigami.Heading {
                    font.pointSize: 12
                    text: "Neutral Colors"
                }
                Flow {
                    width: parent.width
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
                    width: parent.width
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
                    width: parent.width
                    ColorSwatch {
                        swatchColor: "#1cdc9a"
                        fancyName: "Mellow Turquoise"
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
                print(stdout.trim())
                setter.copy(root.fromIconTemplate, stdout.trim())
                root.imageSource = "file:" + stdout.trim()
                print(root.imageSource)
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
                root.imageSource = "file:" + stdout.trim()
                console.log(stdout.trim())
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
    ListModel {
        id: sizesModel
        ListElement { size: 16 }
        ListElement { size: 22 }
        ListElement { size: 32 }
        ListElement { size: 48 }
    }
    ListModel {
        id: symSizesModel
        ListElement { size: 8 }
        ListElement { size: 16 }
        ListElement { size: 22 }
        ListElement { size: 32 }
        ListElement { size: 48 }
        ListElement { size: 64 }
    }
    Kirigami.ApplicationWindow {
        id: hud
        height: 256 + (Kirigami.Units.largeSpacing * 4)
        flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
        visible: false
        width: 128
        title: "HUD"
        maximumHeight: height
        maximumWidth: width
        minimumHeight: height
        minimumWidth: width
        Column {
            spacing: 0
            Rectangle {
                height: Kirigami.Units.largeSpacing * 4
                width: 128
                Kirigami.Theme.colorSet: Kirigami.Theme.Window
                color: Kirigami.Theme.backgroundColor
                Label {
                    color: Kirigami.Theme.textColor
                    text: "HUD"
                    anchors.centerIn: parent
                }
                PlasmaComponents.ToolButton {
                    iconName: "tab-close-other"
                    height: parent.height * (3/4)
                    width: height
                    anchors.right: parent.right
                    anchors.rightMargin: Kirigami.Units.smallSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        hud.visible = false
                    }
                }
                MouseArea {
                    id: mouseRegion
                    anchors.fill: parent;
                    property int mouseXWin: 0
                    property int mouseYWin: 0

                    onPressed: {
                        mouseXWin = mouse.x
                        mouseYWin = mouse.y
                        cursorShape = Qt.SizeAllCursor
                    }
                    onReleased: {
                        cursorShape = Qt.ArrowCursor
                    }
                    onPositionChanged: {
                        var xdelta = mouse.x - mouseXWin
                        var ydelta = mouse.y - mouseYWin
                        hud.x = hud.x + xdelta
                        hud.y = hud.y + ydelta
                    }
                }
            }
            Rectangle {
                height: 128
                width: 128
                color: root.leftColor
                LightIcon {
                    anchors.centerIn: parent
                    size: 48
                    source: root.imageSource
                }
            }
            Rectangle {
                height: 128
                width: 128
                color: root.rightColor
                DarkIcon {
                    anchors.centerIn: parent
                    size: 48
                    source: root.imageSource
                }
            }
        }
    }
    SwipeView {
        id: swipe
        width: root.width - sidebar.collapsedSize
        anchors.left: parent.left
        anchors.leftMargin: sidebar.collapsedSize
        height: root.height
        Item {
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
                        DropDown {
                            pulledDown: pullDown.checked
                            color: root.leftColor
                        }
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
                        DropDown {
                            pulledDown: pullDown.checked
                            color: root.rightColor
                        }
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
                text: "Enable white effect on icons on dark"
            }
        }
        Item {
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                Rectangle {
                    height: 32
                    Layout.fillWidth: true
                    Kirigami.Theme.colorSet: Kirigami.Theme.Window
                    color: Kirigami.Theme.backgroundColor
                    RowLayout {
                        anchors.fill: parent
                        PlasmaComponents.ToolButton {
                            enabled: webView.canGoBack
                            iconName: "draw-arrow-back"
                            text: "Go Back"
                            onClicked: {
                                webView.goBack()
                            }
                        }
                        PlasmaComponents.ToolButton {
                            id: forwardBtn
                            enabled: webView.canGoForward
                            iconName: "draw-arrow-forward"
                            text: "Go Forward"
                            onClicked: {
                                webView.goForward()
                            }
                        }
                        PlasmaComponents.TextField {
                            height: forwardBtn.height
                            Layout.fillWidth: true
                            text: webView.url
                            enabled: false
                        }
                        PlasmaComponents.ToolButton {
                            iconName: "go-home"
                            text: "Return to HIG Home"
                            onClicked: {
                                webView.url = "https://hig.kde.org/"
                            }
                        }
                    }
                }
                WebEngineView {
                    id: webView
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    url: "https://hig.kde.org/"
                }
            }
            Column {
		id: iconColumn
		LayoutMirroring.enabled: false
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                    height: 64
                    width: 64
                    color: root.leftColor
                    LightIcon {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: root.imageSource
                    }
                }
                Rectangle {
                    height: 64
                    width: 64
                    color: root.rightColor
                    DarkIcon {
                        anchors.centerIn: parent
                        height: 48
                        width: 48
                        source: root.imageSource
                    }
                }
            }
            DropShadow {
                anchors.fill: iconColumn
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: iconColumn
            }
        }
        Row {
            spacing: 0
            Rectangle {
                height: parent.height
                width: parent.width / 2
                color: root.leftColor
                LightIcon {
                    anchors.centerIn: parent
                    size: parent.width - (Kirigami.Units.largeSpacing * 2)
                    source: root.imageSource
                }
            }
            Rectangle {
                height: parent.height
                width: parent.width / 2
                color: root.rightColor
                DarkIcon {
                    anchors.centerIn: parent
                    size: parent.width - (Kirigami.Units.largeSpacing * 2)
                    source: root.imageSource
                }
            }
        }
    }
}
