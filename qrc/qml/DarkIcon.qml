/*
    Copyright (C) 2019  Carson Black

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

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
