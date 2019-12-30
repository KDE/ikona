import QtQuick 2.0

import org.kde.kirigami 2.5 as Kirigami

Rectangle {
    property color bg: Kirigami.Theme.backgroundColor

    color: Qt.rgba(bg.r, bg.g, bg.b, 0.8)

    border.width: 1
    border.color: bg
}
