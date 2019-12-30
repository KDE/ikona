import QtQuick 2.0
import org.kde.kirigami 2.5 as Kirigami

Kirigami.Icon {
    id: icon
    Kirigami.Theme.inherit: false
    Kirigami.Theme.textColor: "#eff0f1"
    Kirigami.Theme.backgroundColor: "#31363b"
    Kirigami.Theme.highlightColor: "#3daee9"
    Kirigami.Theme.highlightedTextColor: "#eff0f1"
    Kirigami.Theme.positiveTextColor: "#27ae60"
    Kirigami.Theme.neutralTextColor: "#f67400"
    Kirigami.Theme.negativeTextColor: "#da4453"
    property int size: 48
    height: size
    width: size
}
