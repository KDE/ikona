#include <QApplication>
#include <QCoreApplication>
#include <QIcon>
#include <QModelIndex>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <KColorSchemeManager>
#include <KLocalizedString>
#include <KLocalizedContext>

#include "icon.h"
#include "manager.h"

void messageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    const char *file = context.file ? context.file : "";
    const char *function = context.function ? context.function : "";
    switch (type) {
    case QtDebugMsg:
        fprintf(stderr, "Debug:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtInfoMsg:
        fprintf(stderr, "Info:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtWarningMsg:
        fprintf(stderr, "Warning:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtCriticalMsg:
        fprintf(stderr, "Critical:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtFatalMsg:
        fprintf(stderr, "Fatal:\t%s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    }
}

QApplication* app;

int main(int argc, char *argv[])
{
    qInstallMessageHandler(messageOutput);
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    app = new QApplication(argc, argv);

    KLocalizedString::setApplicationDomain("ikona");

    KColorSchemeManager *manager = new KColorSchemeManager(app);
    manager->activateScheme(manager->indexForScheme("Breeze Light"));
    delete manager;

    qmlRegisterSingletonType<ColourSchemeManager>("org.kde.Ikona", 1, 0, "ColourScheme", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        ColourSchemeManager *obj = new ColourSchemeManager(app);
        return obj;
    });
    qmlRegisterSingletonType<Icon>("org.kde.Ikona", 1, 0, "Ikoner", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        Icon *obj = new Icon();
        return obj;
    });

    app->setWindowIcon(QIcon::fromTheme(QString("org.kde.Ikona")));

    app->setOrganizationName("KDE");
    app->setOrganizationDomain("org.kde");
    app->setApplicationName("Ikona");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app->exec();
}
