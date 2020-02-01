#pragma once

#include "icon.h"

class MonoIcon : public QObject {
    Q_OBJECT
public:
    explicit MonoIcon(QObject *parent = nullptr);
    Q_INVOKABLE bool setIcon(const QString& path);
    Q_INVOKABLE void refreshIcon();
    Q_INVOKABLE void exportToDirectory(bool useSepDirs, const QString& size, const QString& destPath, const QString& targetPath);
    Q_INVOKABLE void exportTemplate(const QString& targetPath);
    Q_PROPERTY(QString inPath MEMBER m_inPath NOTIFY inPathChanged)
    Q_PROPERTY(bool isEnhanced MEMBER m_isEnhanced NOTIFY isEnhancedChanged)

    Q_PROPERTY(QString light8path  MEMBER m_light8path NOTIFY resultChanged)
    Q_PROPERTY(QString light16path MEMBER m_light16path NOTIFY resultChanged)
    Q_PROPERTY(QString light22path MEMBER m_light22path NOTIFY resultChanged)
    Q_PROPERTY(QString light32path MEMBER m_light32path NOTIFY resultChanged)

    Q_PROPERTY(QString dark8path  MEMBER m_dark8path NOTIFY resultChanged)
    Q_PROPERTY(QString dark16path MEMBER m_dark16path NOTIFY resultChanged)
    Q_PROPERTY(QString dark22path MEMBER m_dark22path NOTIFY resultChanged)
    Q_PROPERTY(QString dark32path MEMBER m_dark32path NOTIFY resultChanged)

signals:
    void inPathChanged(QString val);
    void isEnhancedChanged(bool val);
    void resultChanged(QString val);

private:
    QString m_light8path;
    QString m_light16path;
    QString m_light22path;
    QString m_light32path;

    QString m_dark8path;
    QString m_dark16path;
    QString m_dark22path;
    QString m_dark32path;

    void processIcon(const QString& path);

    bool m_isEnhanced;
    QString m_inPath;
    QFileSystemWatcher* m_watcher;
};