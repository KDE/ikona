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
#include "iconsetter.h"

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

bool fileExists(QString path)
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

    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Desktop");
    app.setOrganizationName("Appadeia");
    app.setOrganizationDomain("me.appadeia");
    app.setApplicationName("Ikona");

    if (fileExists(QDir::homePath() + "/.iconPreviewTheme")) {
        QFile file(QDir::homePath() + "/.iconPreviewTheme");
        if (file.open(QFile::ReadOnly)) {
            QTextStream in(&file);
            QIcon::setThemeName(in.readAll().trimmed());
            qDebug() << in.readAll().trimmed();
        }
    }
    qmlRegisterType<IconSetter>("me.appadeia.IconSetter", 1, 0, "IconSetter");
    app.setWindowIcon(QIcon::fromTheme(QString("ikona")));

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
