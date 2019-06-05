#ifndef ICONSETTER_H
#define ICONSETTER_H

#include <QObject>

class IconSetter : public QObject
{
    Q_OBJECT
public:
    explicit IconSetter(QObject *parent = nullptr);
    Q_INVOKABLE void setIconTheme(QString themeName);
    Q_INVOKABLE void copy(QString from, QString to);
    Q_INVOKABLE void xdgOpen(QString file);

private:
    bool fileExists(QString path);
signals:

public slots:
};

#endif // ICONSETTER_H
