// Ikona - Icon Design Companion
// Copyright (C) 2019  Carson Black

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

import QtQuick 2.12
import org.kde.kirigami 2.5 as Kirigami
import QtQuick.Controls 2.5

Kirigami.OverlayDrawer {
    edge:           Qt.BottomEdge
    height: root.height * 0.9

    contentItem: ScrollView {
        anchors.fill: parent
        clip: true
        Column {
            width: root.width
            Kirigami.Heading {
                text: i18n("Breeze Colors")
            }
            Kirigami.Heading {
                font.pointSize: 12
                text: i18n("Neutral Colors")
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
                text: i18n("Warm Colors")
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
                text: i18n("Cool Colors")
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