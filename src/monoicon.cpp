/*
    Copyright (C) 2020  Carson Black

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

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QRandomGenerator>

#include "manip.h"
#include "util.h"

#include "monoicon.h"

MonoIcon::MonoIcon(QObject* parent) : QObject(parent) {
    this->m_watcher = new QFileSystemWatcher();
    this->m_isEnhanced = false;
    QObject::connect(this->m_watcher, &QFileSystemWatcher::fileChanged, this, &MonoIcon::processIcon);
}

bool MonoIcon::setIcon(const QString &path) {
    QString watcherPath = path;
    if (path.startsWith("file://")) {
        watcherPath = watcherPath.replace("file://", "");
    }
    this->m_watcher->removePath(this->m_inPath);
    this->m_inPath = watcherPath;
    this->processIcon(watcherPath);
    if (!this->m_watcher->addPath(this->m_inPath)) {
        qWarning() << "Failed to add watcher path" << m_inPath;
        qWarning() << "Falling back to regular polling...";
        return false;
    }
    return true;
}

void MonoIcon::exportTemplate(const QString& targetPath) {
    QString resolvedPath = targetPath;
    if (targetPath.startsWith("file://")) {
        resolvedPath = resolvedPath.replace("file://", "");
    }
    if (QFile::exists(resolvedPath)) {
        QFile::remove(resolvedPath);
    }
    QFile::copy(":/template.ikona.app.svg", resolvedPath);
}

void MonoIcon::refreshIcon() {
    this->processIcon(this->m_inPath);
}

void MonoIcon::processIcon(const QString& inPath) {
    if (inPath == "qrc:/ikona.svg") {
        for (const QString& variant : {QStringLiteral("light"), QStringLiteral("dark")}) {
            for (const int& size : {8, 16, 22, 32}) {
                auto filepath = QStringLiteral("/tmp/ikona-app-")+variant+QString::number(QRandomGenerator::global()->generate())+QStringLiteral(".svg");
                QFile::copy(":/ikona.svg", filepath);
                this->setProperty(
                    qUtf8Printable(variant+QString::number(size)+QStringLiteral("path")), 
                    filepath
                );
            }
        }
        emit resultChanged("");
        return;
    }

    if (!inPath.endsWith(".ikona.mono.svg", Qt::CaseInsensitive)) {
        for (const QString& variant : {QStringLiteral("light"), QStringLiteral("dark")}) {
            for (const int& size : {8, 16, 22, 32}) {
                auto filepath = QStringLiteral("/tmp/ikona-app-")+QString::number(QRandomGenerator::global()->generate())+QStringLiteral(".svg");
                qDebug() << "in";
                qDebug() << inPath;
                qDebug() << "file";
                qDebug() << filepath;
                QFile::copy(inPath, filepath);
                this->setProperty(
                    qUtf8Printable(variant+QString::number(size)+QStringLiteral("path")), 
                    filepath
                );
            }
        }
        this->m_isEnhanced = false;
        emit isEnhancedChanged(false);
        emit resultChanged("");
        return;
    } else {
        this->m_isEnhanced = true;
        emit isEnhancedChanged(true);
    }

    for (const QString& variant : {QStringLiteral("light"), QStringLiteral("dark")}) {
        for (const int& size : {16, 22, 32, 48, 64}) {
            auto data = IconManipulator::processIconInternal(
                inPath, 
                variant == "light" ? IconKind::Light : IconKind::Dark, 
                "#"+QString::number(size)+"plate", 
                size
            );
            auto filepath = QStringLiteral("/tmp/ikona-app-")+QString::number(QRandomGenerator::global()->generate())+QStringLiteral(".svg");
            writeFile(filepath, data);
            this->setProperty(
                qUtf8Printable(variant+QString::number(size)+QStringLiteral("path")), 
                filepath
            );
        }
    }
    emit resultChanged("");
}

void MonoIcon::exportToDirectory(bool useSepDirs, const QString& size, const QString& destPath, const QString& targetPath) {
    QString trueDestPath = targetPath;
    if (targetPath.startsWith("file://")) {
        trueDestPath = trueDestPath.replace("file://", "");
    }
    QString exportName = QFileInfo(this->m_inPath).baseName();
    if (useSepDirs) {
        if (QFile::exists(QDir::cleanPath(trueDestPath + QDir::separator() + size + QDir::separator() + exportName + ".svg"))) {
            QFile::remove(QDir::cleanPath(trueDestPath + QDir::separator() + size + QDir::separator() + exportName + ".svg"));
        }
        QDir("/").mkpath(QDir::cleanPath(trueDestPath + QDir::separator() + size));
        QFile::copy(destPath, QDir::cleanPath(trueDestPath + QDir::separator() + size + QDir::separator() + exportName + ".svg"));
    } else {
        if (QFile::exists(trueDestPath + QDir::separator() + exportName + "-" + size + ".svg")) {
            QFile::remove(trueDestPath + QDir::separator() + exportName + "-" + size + ".svg");
        }
        QFile::copy(destPath, trueDestPath + QDir::separator() + exportName + "-" + size + ".svg");
    }
}