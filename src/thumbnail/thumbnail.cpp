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