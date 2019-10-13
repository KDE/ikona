#include <QObject>

class IconSetter : public QObject
{
    Q_OBJECT
public:
    explicit IconSetter(QObject *parent = nullptr);
    Q_INVOKABLE void setIconTheme(const QString &themeName);
    Q_INVOKABLE void copy(const QString &from, const QString &to);
    Q_INVOKABLE void linkIcon(const QString &from);
    Q_INVOKABLE void xdgOpen(const QString &file);
    Q_INVOKABLE void clipboardCopy(const QString &string);

private:
    bool fileExists(const QString &path);
signals:

public slots:
};
