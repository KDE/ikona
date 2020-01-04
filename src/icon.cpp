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

Icon::Icon(QObject* parent) : QObject(parent) {
    this->m_iconPath = "";
    this->m_darkIconPath = "";
    this->m_lightIconPath = "";
    this->m_watcher = new QFileSystemWatcher();
    QObject::connect(this->m_watcher, &QFileSystemWatcher::fileChanged, this, &Icon::processIcon);
}

void Icon::setIcon(const QString &path) {
    this->m_watcher->removePath(this->m_iconPath);
    this->m_iconPath = path;
    this->m_watcher->addPath(this->m_iconPath);

    this->processIcon(path);
}

void Icon::processIcon(const QString& inPath) {
    QString path = inPath;
    if (path.startsWith("file://")) {
        path = path.replace("file://", "");
    }

    QString lightPath = "/tmp/" + QString::number(qrand() % 1000000) + "ikonalight.svg";
    QString darkPath = "/tmp/" + QString::number(qrand() % 1000000) + "ikonadark.svg";

    QFile::copy(path, lightPath);
    QFile::copy(path, darkPath);

    {
        QString text = readFile(lightPath);

        text = IconManipulator::toLight(text);

        writeFile(lightPath, text);
    }

    {
        QString text = readFile(darkPath);

        text = IconManipulator::toDark(text);

        writeFile(darkPath, text);
    }

    this->m_darkIconPath = darkPath;
    this->m_lightIconPath = lightPath;

    emit lightIconChanged(lightPath);
    emit darkIconChanged(darkPath);
    emit normalIconChanged(path);
}

