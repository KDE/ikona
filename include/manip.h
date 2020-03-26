#pragma once

#include <QObject>
#include <QString>

enum IconKind { Light, Dark };

class IconManipulator : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString input WRITE setInput MEMBER m_input NOTIFY inputChanged)
    Q_PROPERTY(QString output MEMBER m_output NOTIFY outputChanged)

public:
    static QString processIconInternal(const QString& inPath, IconKind type, const QString& idToExtract, int32_t targetSize);
    void setInput(const QString& input);
    Q_INVOKABLE void optimizeAll();
    Q_INVOKABLE void optimizeWithRsvg();
    Q_INVOKABLE void optimizeWithScour();
    Q_INVOKABLE void classAsLight();
    Q_INVOKABLE void classAsDark();

signals:
    void inputChanged();
    void outputChanged();

private:
    QString m_input;
    QString m_output;
};