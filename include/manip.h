#pragma once

#include <QString>

enum IconKind { Light, Dark };

class IconManipulator {
public:
    static QString processIconInternal(const QString& inPath, IconKind type, const QString& idToExtract, int32_t targetSize);
};