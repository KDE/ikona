#include <QFile>
#include <QTextStream>
#include <QDebug>
#include "icon.h"

void writeFile(const QString& path, const QString& data) {
    QFile of(path);
    if (of.open(QFile::WriteOnly)) {
        QTextStream os(&of);
        os << data;
        of.close();
    }
}

QString readFile(const QString& path) {
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

        text.replace("fill=\"#eff0f1\"", "fill=\"#232629\"");
        text.replace("fill=\"#31363b\"", "fill=\"#eff0f1\"");
        text.replace("fill=\"#232629\"", "fill=\"#fcfcfc\"");
        text.replace("color:#eff0f1", "color:#232629");
        text.replace("color:#31363b", "color:#eff0f1");
        text.replace("color:#232629", "color:#fcfcfc");

        writeFile(lightPath, text);
    }

    {
        QString text = readFile(darkPath);

        text.replace("fill=\"#232629\"", "fill=\"#eff0f1\"");
        text.replace("fill=\"#eff0f1\"", "fill=\"#31363b\"");
        text.replace("fill=\"#fcfcfc\"", "fill=\"#232629\"");
        text.replace("color:#232629", "color:#eff0f1");
        text.replace("color:#eff0f1", "color:#31363b");
        text.replace("color:#fcfcfc", "color:#232629");

        writeFile(darkPath, text);
    }

    this->m_darkIconPath = darkPath;
    this->m_lightIconPath = lightPath;

    emit lightIconChanged(lightPath);
    emit darkIconChanged(darkPath);
    emit normalIconChanged(path);
}

