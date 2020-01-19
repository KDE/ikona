#pragma once

#include <QObject>
#include <QFileSystemWatcher>

class AppIcon : public QObject {
    Q_OBJECT
public:
    explicit AppIcon(QObject *parent = nullptr);
    Q_INVOKABLE bool setIcon(const QString& path);
    Q_INVOKABLE void refreshIcon();
    Q_PROPERTY(QString inPath MEMBER m_inPath NOTIFY inPathChanged)

    Q_PROPERTY(QString icon16path MEMBER m_icon16path NOTIFY resultChanged)
    Q_PROPERTY(QString icon22path MEMBER m_icon16path NOTIFY resultChanged)
    Q_PROPERTY(QString icon32path MEMBER m_icon32path NOTIFY resultChanged)
    Q_PROPERTY(QString icon48path MEMBER m_icon48path NOTIFY resultChanged)
    Q_PROPERTY(QString icon64path MEMBER m_icon64path NOTIFY resultChanged)

signals:
    void inPathChanged(QString val);

    void resultChanged(QString val);

private:
    void processIcon(const QString& path);
    QString m_inPath;

    QString m_icon16path;
    QString m_icon22path;
    QString m_icon32path;
    QString m_icon48path;
    QString m_icon64path;

    QFileSystemWatcher* m_watcher;
};

// class MonoIcon : public QObject {
//     Q_OBJECT
// public:
//     explicit MonoIcon(QObject *parent = nullptr);
//     Q_INVOKABLE void setIcon(const QString& path);
// };