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


#include <QApplication>
#include <QCoreApplication>
#include <QDebug>
#include <QIcon>
#include <QModelIndex>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <KLocalizedContext>
#include <KLocalizedString>

#include "icon.h"
#include "manager.h"
#include "thememodel.h"
#include "manip.h"

#include "ikonars.h"

void messageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    const char *file = context.file != nullptr ? context.file : "";
    const char *function = context.function != nullptr ? context.function : "";
    switch (type) {
    case QtDebugMsg:
        fprintf(stderr, "[D] Debug:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtInfoMsg:
        fprintf(stderr, "[i] Info:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtWarningMsg:
        fprintf(stderr, "[!] Warning:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtCriticalMsg:
        fprintf(stderr, "[!!] Critical:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtFatalMsg:
        fprintf(stderr, "[X] Fatal:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    }
}

QApplication* app;

auto main(int argc, char *argv[]) -> int
{
    qInstallMessageHandler(messageOutput);
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    app = new QApplication(argc, argv);

    KLocalizedString::setApplicationDomain("ikona");

    qmlRegisterSingletonType<ClipboardManager>("org.kde.Ikona", 1, 0, "Clipboard", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        auto *obj = new ClipboardManager(app);
        return obj;
    });
    qmlRegisterSingletonType<AppIcon>("org.kde.Ikona", 1, 0, "AppIcon", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        AppIcon *obj = new AppIcon();
        return obj;
    });
    qmlRegisterSingletonType<ThemeModel>("org.kde.Ikona", 1, 0, "ThemeModel", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject* {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        ThemeModel *obj = new ThemeModel();
        return obj;
    });
    qmlRegisterSingletonType<IconManipulator>("org.kde.Ikona", 1, 0, "Manipulator", [](QQmlEngine*, QJSEngine*) -> QObject* { return new IconManipulator; });
    qmlRegisterUncreatableType<Icon>("org.kde.Ikona", 1, 0, "ThemeIcon", "ThemeIcon can only be accessed through the ThemeModel");
    qmlRegisterUncreatableType<IconTheme>("org.kde.Ikona", 1, 0, "IconTheme", "IconTheme can only be accessed through the ThemeModel");
    qmlRegisterUncreatableType<IconDirectory>("org.kde.Ikona", 1, 0, "IconDirectory", "IconDirectory can only be accessed through the ThemeModel");

    QApplication::setWindowIcon(QIcon::fromTheme(QString("org.kde.Ikona")));

    QApplication::setOrganizationName("KDE");
    QApplication::setOrganizationDomain("org.kde");
    QApplication::setApplicationName("Ikona");

    QApplication::setDesktopFileName("org.kde.Ikona.desktop");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     app, [url](QObject *obj, const QUrl &objUrl) {
        if ((obj == nullptr) && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    engine.load(url);

    return QApplication::exec();
}
