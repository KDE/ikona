#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QUrl>
#include <QDesktopServices>
#include <QProcess>
#include <QDebug>
#include <QGuiApplication>
#include <QClipboard>
#include "iconsetter.h"
#include <QIcon>

IconSetter::IconSetter(QObject *parent) : QObject(parent)
{

}
bool IconSetter::fileExists(QString path)
{
    QFileInfo check_file(path);
    if (check_file.exists() && check_file.isFile()) {
        return true;
    } else {
        return false;
    }
}
void IconSetter::setIconTheme(QString themeName)
{
    QFile file(QDir::homePath() + "/.iconPreviewTheme");
    if (IconSetter::fileExists(QDir::homePath() + "/.iconPreviewTheme")) {
        file.remove();
    }
    if (file.open(QFile::ReadWrite)) {
        QTextStream in(&file);
        in << themeName << endl;
    }
}
void IconSetter::copy(QString from, QString to)
{
    QFile fromfile(from);
    if (QFile::exists(to))
    {
        QFile::remove(to);
    }
    fromfile.copy(to);
}
void IconSetter::linkIcon(QString from)
{
    QIcon::setFallbackSearchPaths(QIcon::fallbackSearchPaths() << QDir::homePath() + "/.ikona");
    QString to = QDir::homePath() + "/.ikona/" + "ikonapreviewicon.svg";
    if (QFile::exists(to))
    {
        QFile::remove(to);
    }
    QFile::link(from, to);
}
void IconSetter::xdgOpen(QString file)
{
    QProcess::startDetached("xdg-open \"" + file + "\"");

    // QDesktopServices::openUrl(QUrl(file));
    // KIO doesn't like QUrl's encoding for whatever reason.
}
void IconSetter::clipboardCopy(QString string)
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(string);
}
