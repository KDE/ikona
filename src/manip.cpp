#include "manip.h"
#include "ikonars.h"
#include <QDebug>

QString IconManipulator::processIconInternal(const QString& inPath, IconKind type, const QString& idToExtract, int32_t targetSize) {
    auto inPathStr = inPath.toStdString();
    auto idToExtractStr = idToExtract.toStdString();

    auto inPathCStr = inPathStr.c_str();
    auto idToExtractCStr = idToExtractStr.c_str();

    IkonaIcon icon = nullptr;
    int i = 0;
    while (icon == nullptr) {
        icon = ikona_icon_new_from_path(inPathCStr);
        if (i++ < 10000) {
            break;
        }
    }
    if (icon == nullptr) {
        return QString("");
    }
    auto transparent = ikona_icon_inject_stylesheet(icon, "#layer2 { opacity: 0; }");
    auto manip = ikona_icon_crop_to_subicon(transparent, idToExtractCStr, targetSize);
    auto classed = ikona_icon_class_as_light(manip);
    const char* manipulated = ikona_icon_read_to_string(classed);
    
    QString manipulatedString(manipulated);

    ikona_icon_free(transparent);
    ikona_icon_free(icon);
    ikona_icon_free(manip);
    ikona_icon_free(classed);
    return manipulatedString;
}
