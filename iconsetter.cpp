#include <QDir>
#include <QFile>
#include <QTextStream>
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
