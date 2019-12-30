#pragma once

#include <QObject>
#include <QFileSystemWatcher>

class Icon : public QObject {
    Q_OBJECT
public:
    explicit Icon(QObject *parent = nullptr);
    Q_INVOKABLE void setIcon(const QString& path);
    Q_PROPERTY(QString lightIconPath MEMBER m_lightIconPath NOTIFY lightIconChanged)
    Q_PROPERTY(QString normalIconPath MEMBER m_iconPath NOTIFY normalIconChanged)
    Q_PROPERTY(QString darkIconPath MEMBER m_darkIconPath NOTIFY darkIconChanged)
signals:
    void normalIconChanged(QString val);
    void lightIconChanged(QString val);
    void darkIconChanged(QString val);
private:
    void processIcon(const QString& path);
    QString m_iconPath;
    QString m_darkIconPath;
    QString m_lightIconPath;
    QFileSystemWatcher* m_watcher;
};
