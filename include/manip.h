#pragma once

#include <QString>

class IconManipulator {
public:
    static QString toLight(const QString&);
    static QString toDark(const QString&);
    static QString classIcon(const QString&);
};