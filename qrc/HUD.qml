import QtQuick 2.12
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5

Kirigami.ApplicationWindow {
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
                text: i18nc("The title name of the HUD window", "HUD")
                anchors.centerIn: parent
            }
            ToolButton {
                icon.name: "tab-close-other"
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