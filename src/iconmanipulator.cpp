#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QUrl>
#include <QDesktopServices>
#include <QProcess>
#include <QDebug>
#include <QGuiApplication>
#include <QClipboard>
#include "iconmanipulator.h"
#include <QIcon>
#include <QRegularExpression>
#include <QRegularExpressionMatch>

IconManipulator::IconManipulator(QObject *parent) : QObject(parent)
{

}
bool IconManipulator::prepMono(QString inputPath)
{
    QString path;
    if (inputPath.startsWith("file://")) {
        path = inputPath.replace("file://", "");
    } else {
        path = inputPath;
    }
    QFile file(path);

    if (QFile::exists("/tmp/ikonalight.svg"))
        QFile::remove("/tmp/ikonalight.svg");

    if (QFile::exists("/tmp/ikonadark.svg"))
        QFile::remove("/tmp/ikonadark.svg");

    file.copy("/tmp/ikonalight.svg");
    file.copy("/tmp/ikonadark.svg");

    this->injectStylesheet("file:///tmp/ikonalight.svg");
    this->injectStylesheet("file:///tmp/ikonadark.svg");    

    this->classIcon("file:///tmp/ikonalight.svg");
    this->classIcon("file:///tmp/ikonadark.svg");

    this->toDark("file:///tmp/ikonalight.svg");
    this->toLight("file:///tmp/ikonadark.svg");

    return true;
}
bool IconManipulator::tidyIcon(QString inputPath)
{
    QString path;
    if (inputPath.startsWith("file://")) {
        path = inputPath.replace("file://", "");
    } else {
        path = inputPath;
    }
    QStringList args = { "--set-precision=8", "--enable-viewboxing", "--enable-comment-stripping", "--remove-descriptive-elements", "--create-groups", "--strip-xml-space", "--nindent=4", path };
    QProcess *proc = new QProcess();
    proc->start("scour", args);
    if (proc->waitForFinished())
    {
        if (proc->exitCode() == 0)
        {
            QString output = proc->readAllStandardOutput();
            QFile icon(path);
            if (icon.open( QFile::WriteOnly | QFile::Truncate))
            {
                QTextStream iconStream(&icon);
                iconStream << output;
                return true;
            } else 
            {
                return false;
            }
            return true;
        }
    }
    return false;
}
bool IconManipulator::classIcon(QString inputPath)
{
    QString path;
    if (inputPath.startsWith("file://")) {
        path = inputPath.replace("file://", "");
    } else {
        path = inputPath;
    }
    QFile icon(path);
    if (icon.open( QFile::ReadWrite ))
    {
        QByteArray iconData = icon.readAll();
        QString text(iconData);

        text.replace("fill=\"#232629\"", "class=\"ColorScheme-Text\" fill=\"currentColor\"");
        text.replace("fill=\"#eff0f1\"", "class=\"ColorScheme-Background\" fill=\"currentColor\"");
        text.replace("fill=\"#fcfcfc\"", "class=\"ColorScheme-ViewBackground\" fill=\"currentColor\"");
        text.replace("fill=\"#3daee9\"", "class=\"ColorScheme-ButtonFocus\" fill=\"currentColor\"");
        text.replace("fill=\"#27ae60\"", "class=\"ColorScheme-PositiveText\" fill=\"currentColor\"");
        text.replace("fill=\"#f67400\"", "class=\"ColorScheme-NeutralText\" fill=\"currentColor\"");
        text.replace("fill=\"#da4453\"", "class=\"ColorScheme-NegativeText\" fill=\"currentColor\"");

        icon.seek(0);
        icon.write(text.toUtf8());

        icon.close();
        return true;
    }
    return false;
}
bool IconManipulator::toDark(QString inputPath)
{
    QString path;
    if (inputPath.startsWith("file://")) {
        path = inputPath.replace("file://", "");
    } else {
        path = inputPath;
    }
    QFile icon(path);
    if (icon.open( QFile::ReadWrite ))
    {
        QByteArray iconData = icon.readAll();
        QString text(iconData);

        text.replace("fill=\"#232629\"", "fill=\"#eff0f1\"");
        text.replace("fill=\"#eff0f1\"", "fill=\"#31363b\"");
        text.replace("fill=\"#fcfcfc\"", "fill=\"#232629\"");
        text.replace("color:#232629", "color:#eff0f1");
        text.replace("color:#eff0f1", "color:#31363b");
        text.replace("color:#fcfcfc", "color:#232629");

        icon.seek(0);
        icon.write(text.toUtf8());

        icon.close();
        return true;
    }
    return false;
}
bool IconManipulator::toLight(QString inputPath)
{
    QString path;
    if (inputPath.startsWith("file://")) {
        path = inputPath.replace("file://", "");
    }
    QFile icon(path);
    if (icon.open( QFile::ReadWrite ))
    {
        QByteArray iconData = icon.readAll();
        QString text(iconData);

        text.replace("fill=\"#eff0f1\"", "fill=\"#232629\"");
        text.replace("fill=\"#31363b\"", "fill=\"#eff0f1\"");
        text.replace("fill=\"#232629\"", "fill=\"#fcfcfc\"");
        text.replace("color:#eff0f1", "color:#232629");
        text.replace("color:#31363b", "color:#eff0f1");
        text.replace("color:#232629", "color:#fcfcfc");

        icon.seek(0);
        icon.write(text.toUtf8());

        icon.close();
        return true;
    }
    return false;
}
bool IconManipulator::injectStylesheet(QString inputPath)
{
    QString path;
    if (inputPath.startsWith("file://")) {
        path = inputPath.replace("file://", "");
    }
        QFile icon(path);
    if (icon.open( QFile::ReadWrite ))
    {
        QByteArray iconData = icon.readAll();
        QString text(iconData);

        QRegularExpression re("<svg.*>");
        QRegularExpressionMatch match = re.match(text);

        if (!match.hasMatch()) {
            return false;
        }

        int endOffset = match.capturedEnd();
        
        text.insert(endOffset, "<style type=\"text/css\" id=\"current-color-scheme\"> .ColorScheme-Text {color:#232629;} .ColorScheme-Background {color:#eff0f1;} .ColorScheme-ViewBackground {color:#fcfcfc;} .ColorScheme-ButtonFocus {color:#3daee9;} .ColorScheme-PositiveText {color:#27ae60;} .ColorScheme-NeutralText {color:#f67400;} .ColorScheme-NegativeText {color:#da4453;} </style>");

        icon.seek(0);
        icon.write(text.toUtf8());

        icon.close();
        return true;
    }
    return false;
}