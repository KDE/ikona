import QtQuick 2.12
import QtGraphicalEffects 1.12
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kirigami 2.0 as Kirigami
import me.appadeia.Ikona 1.0

Item {
    id: itemRoot
    property var swatchColor: "#ffffff"
    property string fancyName: "Fancy Name"
    height: width * (3/7)
    width: parent.width / 6
    IconSetter {
        id: iconSetter
    }
    Rectangle {
        id: swatch
        width: parent.width
        height: parent.height
        color: parent.swatchColor

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                fancyname.opacity = 1
            }
            onExited: {
                fancyname.opacity = 0
            }
            onClicked: {
                fade.restart()
            }
        }

        Rectangle {
            anchors.fill: label
            color: "black"
            opacity: 0.5
        }
        PlasmaComponents.Label {
            id: label
            anchors.centerIn: parent
            height: width
            width: parent.width * (3/7)
            text: itemRoot.swatchColor
            horizontalAlignment: Text.AlignHCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    iconSetter.clipboardCopy(itemRoot.swatchColor)
                    fade.restart()
                }
            }
        }
    }
    Rectangle {
        anchors.fill: fancyname
        color: Kirigami.Theme.backgroundColor
        opacity: fancyname.opacity
    }
    PlasmaComponents.Label {
        color: "white"
        id: fancyname
        text: itemRoot.fancyName
        font.bold: false
        font.pointSize: 10
        opacity: 0
        anchors.bottom: swatch.top
        anchors.bottomMargin: -height
        anchors.horizontalCenter: swatch.horizontalCenter
        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }
    }
    Rectangle {
        anchors.fill: copied
        color: Kirigami.Theme.backgroundColor
        opacity: copied.opacity
    }

    PlasmaComponents.Label {
        color: "white"
        id: copied
        text: "Copied!"
        font.bold: false
        font.pointSize: 10
        opacity: 0
        anchors.bottom: swatch.top
        anchors.bottomMargin: -height
        anchors.horizontalCenter: swatch.horizontalCenter
        SequentialAnimation {
            id: fade
            ScriptAction {
                script: {
                    fancyname.visible = false
                }
            }
            NumberAnimation {
                target: copied
                property: "opacity"
                from: 0
                to: 1
                duration: 150
            }
            PauseAnimation {
                duration: 400
            }
            NumberAnimation {
                target: copied
                property: "opacity"
                from: 1
                to: 0
                duration: 500
            }
            ScriptAction {
                script: {
                    fancyname.visible = true
                }
            }
        }
    }
//    PlasmaComponents.Label {
//        id: name
//        anchors.left: swatch.right
//        anchors.leftMargin: 3
//        anchors.verticalCenter: swatch.verticalCenter
//        font.bold: true
//        text: parent.fancyName
//    }
}
