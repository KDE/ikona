#include <QApplication>
#include <QProcess>
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtDebug>
#include <Plasma/Svg>
#include <QIcon>
#include <QtWebEngine>
#include <KLocalizedContext>
#include <KLocalizedString>
#include "iconsetter.h"
#include "iconmanipulator.h"

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    const char *file = context.file ? context.file : "";
    const char *function = context.function ? context.function : "";
    switch (type) {
    case QtDebugMsg:
        fprintf(stderr, "Debug: %s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtInfoMsg:
        fprintf(stderr, "Info: %s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtWarningMsg:
        fprintf(stderr, "Warning: %s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtCriticalMsg:
        fprintf(stderr, "Critical: %s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    case QtFatalMsg:
        fprintf(stderr, "Fatal: %s (%s:%u, %s)\n", localMsg.constData(), file, context.line, function);
        break;
    }
}

bool fileExists(const QString &path)
{
    QFileInfo check_file(path);
    if (check_file.exists() && check_file.isFile()) {
        return true;
    } else {
        return false;
    }
}
int main(int argc, char *argv[])
{
    qInstallMessageHandler(myMessageOutput);
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    // QQuickStyle::setStyle("Plasma");
    app.setOrganizationName("Appadeia");
    app.setOrganizationDomain("org.kde");
    app.setApplicationName("Ikona");

    KLocalizedString::setApplicationDomain("ikona");

    QtWebEngine::initialize();

    if (fileExists(QDir::homePath() + "/.iconPreviewTheme")) {
        QFile file(QDir::homePath() + "/.iconPreviewTheme");
        if (file.open(QFile::ReadOnly)) {
            QTextStream in(&file);
            QIcon::setThemeName(in.readAll().trimmed());
            qDebug() << in.readAll().trimmed();
        }
    }
    QDir dir(QDir::homePath() + "/.ikona");
    if (!dir.exists()) {
        dir.mkdir(QDir::homePath() + "/.ikona");
    }

    qmlRegisterType<IconSetter>("org.kde.Ikona", 1, 0, "IconSetter");
    qmlRegisterType<IconManipulator>("org.kde.Ikona", 1, 0, "IconManipulator");

    QIcon::setFallbackSearchPaths(QIcon::fallbackSearchPaths() << QDir::homePath() + "/.ikona");
    qDebug() << QIcon::fallbackSearchPaths();

    app.setWindowIcon(QIcon::fromTheme(QString("ikona")));

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));

    return app.exec();
}
