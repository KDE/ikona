#include "manip.h"
#include "ikonars.h"
#include <QDebug>

QString toLight(const QString& data) {
    QString manip = data;
    
    manip.replace("fill=\"#eff0f1\"", "fill=\"#232629\"");
    manip.replace("fill=\"#31363b\"", "fill=\"#eff0f1\"");
    manip.replace("fill=\"#232629\"", "fill=\"#fcfcfc\"");
    manip.replace("color:#eff0f1", "color:#232629");
    manip.replace("color:#31363b", "color:#eff0f1");
    manip.replace("color:#232629", "color:#fcfcfc");

    return manip;
}

QString toDark(const QString& data) {
    QString manip = data;

    manip.replace("fill=\"#232629\"", "fill=\"#eff0f1\"");
    manip.replace("fill=\"#eff0f1\"", "fill=\"#31363b\"");
    manip.replace("fill=\"#fcfcfc\"", "fill=\"#232629\"");
    manip.replace("color:#232629", "color:#eff0f1");
    manip.replace("color:#eff0f1", "color:#31363b");
    manip.replace("color:#fcfcfc", "color:#232629");

    return manip;
}

QString classIcon(const QString& data) {
    auto dataStr = data.toStdString();
    auto dataCStr = dataStr.c_str();

    auto icon = ikona_icon_new_from_string(dataCStr);
    auto light = ikona_icon_class_as_light(icon);
    auto cdata = ikona_icon_read_to_string(light);

    QString lightString(cdata);

    return lightString;
}

QString IconManipulator::processIconInternal(const QString& inPath, IconKind type, const QString& idToExtract, int32_t targetSize) {
    auto inPathStr = inPath.toStdString();
    auto idToExtractStr = idToExtract.toStdString();

    auto inPathCStr = inPathStr.c_str();
    auto idToExtractCStr = idToExtractStr.c_str();

    auto icon = ikona_icon_new_from_path(inPathCStr);
    auto manip = ikona_icon_extract_subicon_by_id(icon, idToExtractCStr, targetSize);
    const char* manipulated = ikona_icon_read_to_string(manip);
    
    QString manipulatedString(manipulated);

    manipulatedString = classIcon(manipulatedString);

    if (type == IconKind::Dark) {
        manipulatedString = toDark(manipulatedString);
    }

    return manipulatedString;
}