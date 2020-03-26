#include "manip.h"
#include "ikonars.h"
#include <QDebug>
#include <QtConcurrent>

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

#define QStringToChar auto internalStr = m_input.toStdString(); \
auto internalCStr = internalStr.c_str();

#define ProcIcon(action) \
QtConcurrent::run([=]() { \
QStringToChar \
auto icon = ikona_icon_new_from_path(internalCStr); \
auto proc = action (icon); \
QString ret(ikona_icon_get_filepath(proc)); \
ikona_icon_free(icon); ikona_icon_free(proc); \
m_output = ret; emit outputChanged();\
});

void IconManipulator::setInput(const QString& input) {
    if (input.startsWith("file://")) {
        auto clone = input;
        clone.remove(0, 7);
        m_input = clone;
        emit inputChanged();
        return;
    }
    m_input = input;
    emit inputChanged();
}

void IconManipulator::optimizeAll() {
    ProcIcon(ikona_icon_optimize_all)
}

void IconManipulator::optimizeWithRsvg() {
    ProcIcon(ikona_icon_optimize_with_rsvg)
}

void IconManipulator::optimizeWithScour() {
    ProcIcon(ikona_icon_optimize_with_scour)
}

void IconManipulator::classAsLight() {
    ProcIcon(ikona_icon_class_as_light)
}

void IconManipulator::classAsDark() {
    ProcIcon(ikona_icon_class_as_dark)
}
