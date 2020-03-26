import QtQuick 2.12
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.7

import org.kde.kirigami 2.5 as Kirigami


MouseArea {
    id: mausArea
    hoverEnabled: true
    anchors.fill: parent

    property alias title: title.text
    property alias subtitle: subtitle.text
    property alias icon: childIcon

    ToolTip {
        id: toolTip
        width: columnView.implicitWidth + (Kirigami.Units.largeSpacing*2)
        height: columnView.implicitHeight + (Kirigami.Units.largeSpacing*2)

        visible: mausArea.containsMouse

        ColumnLayout {
            id: columnView

            Kirigami.Icon {
                id: childIcon

                Layout.alignment: Qt.AlignHCenter
            }
            Kirigami.Heading {
                id: title
                level: 3
                visible: text != ""

                Layout.alignment: Qt.AlignHCenter
            }
            Label {
                id: subtitle
                visible: text != ""

                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}