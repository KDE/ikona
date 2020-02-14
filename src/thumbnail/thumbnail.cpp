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

#include <QPixmap>
#include <kio/thumbcreator.h>
#include <QtSvg>
#include <QLoggingCategory>
#include "ikonars.h"

Q_DECLARE_LOGGING_CATEGORY(LOG_KIO_IKONA)
Q_LOGGING_CATEGORY(LOG_KIO_IKONA, "kio_ikona")

class IkonaThumbnailer : public ThumbCreator {
public:
    IkonaThumbnailer();

    virtual bool create(const QString &path, int width, int height, QImage &img) {
        qCDebug(LOG_KIO_IKONA) << "Thumbnailing Ikona app SVG...";
        auto manip = ikona_icon_new_from_path(qUtf8Printable(path));
        if (manip == nullptr) {
            qCDebug(LOG_KIO_IKONA) << "Failed to thumbnail Ikona app SVG";
            return false;
        }
        QSvgRenderer renderer(QString::fromLocal8Bit(ikona_icon_get_filepath(manip)));
        QPainter painter(&img);
        renderer.render(&painter);
        ikona_icon_free(manip);
        qCDebug(LOG_KIO_IKONA) << "Thumbnailed Ikona app SVG";
        return true;
    }
    virtual Flags flags() const {
        return Flags::None;
    }
};

IkonaThumbnailer::IkonaThumbnailer() {}

extern "C" {
    Q_DECL_EXPORT IkonaThumbnailer *new_creator()
    {
        return new IkonaThumbnailer();
    }
}