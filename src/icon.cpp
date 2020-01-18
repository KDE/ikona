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

#include "icon.h"
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QRandomGenerator>

#include "manip.h"

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

AppIcon::AppIcon(QObject* parent) : QObject(parent) {
    this->m_watcher = new QFileSystemWatcher();
    QObject::connect(this->m_watcher, &QFileSystemWatcher::fileChanged, this, &AppIcon::processIcon);
}

void AppIcon::setIcon(const QString &path) {
    this->m_watcher->removePath(this->m_inPath);
    this->m_inPath = path;
    this->m_watcher->addPath(this->m_inPath);
    this->processIcon(path);
}

void AppIcon::processIcon(const QString& inPath) {
    QString path = inPath;
    if (path.startsWith("file://")) {
        path = path.replace("file://", "");
    }

    if (path == "qrc:/ikona.svg") {
        for (const int& size : {16, 22, 32, 48, 64}) {
            auto filepath = QStringLiteral("/tmp/ikona-app-")+QString::number(QRandomGenerator::global()->generate())+QStringLiteral(".svg");
            QFile::copy(":/ikona.svg", filepath);
            this->setProperty(
                qUtf8Printable("icon"+QString::number(size)+QStringLiteral("path")), 
                filepath
            );
        }
        emit resultChanged("");
        return;
    }

    if (!path.endsWith(".ikona.app.svg", Qt::CaseInsensitive)) {
        for (const int& size : {16, 22, 32, 48, 64}) {
            auto filepath = QStringLiteral("/tmp/ikona-app-")+QString::number(QRandomGenerator::global()->generate())+QStringLiteral(".svg");
            QFile::copy(path, filepath);
            this->setProperty(
                qUtf8Printable("icon"+QString::number(size)+QStringLiteral("path")), 
                filepath
            );
        }
        emit resultChanged("");
        return;
    }

    for (const int& size : {16, 22, 32, 48, 64}) {
        auto data = IconManipulator::processIconInternal(path, IconKind::Light, "#"+QString::number(size)+"plate", size);
        auto filepath = QStringLiteral("/tmp/ikona-app-")+QString::number(QRandomGenerator::global()->generate())+QStringLiteral(".svg");
        writeFile(filepath, data);
        this->setProperty(
            qUtf8Printable("icon"+QString::number(size)+QStringLiteral("path")), 
            filepath
        );
    }
    emit resultChanged("");
}

