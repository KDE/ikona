#include <QString>
#include <QFile>
#include <QTextStream>

#include "util.h"

void writeFile(const QString& path, const QString& data) {
    QFile of(path);
    if (of.open(QFile::WriteOnly)) {
        QTextStream os(&of);
        os << data;
        of.close();
    }
}

auto readFile(const QString& path) -> QString {
    QFile iF(path);
    if (iF.open( QFile::ReadOnly )) {
        return QString(iF.readAll());
    }
    return "";
}

bool copyFile(const QString& from, const QString& to) {
    if (QFile::exists(to)) {
        QFile::remove(to);
    }
    return QFile::copy(from, to);
}