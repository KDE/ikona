#include <QObject>

class IconManipulator : public QObject
{
    Q_OBJECT
public:
    explicit IconManipulator(QObject *parent = nullptr);
    Q_INVOKABLE bool tidyIcon(QString inputPath);
    Q_INVOKABLE bool classIcon(QString inputPath);
    Q_INVOKABLE bool injectStylesheet(QString inputPath);
    Q_INVOKABLE bool toDark(QString inputPath);
    Q_INVOKABLE bool toLight(QString inputPath);

signals:

public slots:
};