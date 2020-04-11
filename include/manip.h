#pragma once

#include <QObject>
#include <QString>

enum IconKind { Light, Dark };

class IconManipulator : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool plural MEMBER m_plural NOTIFY pluralChanged)

    Q_PROPERTY(QString input WRITE setInput MEMBER m_input NOTIFY inputChanged)
    Q_PROPERTY(QString output MEMBER m_output NOTIFY outputChanged)

    Q_PROPERTY(QList<QString> inputs WRITE setInputs MEMBER m_inputs NOTIFY inputsChanged)
    Q_PROPERTY(QList<QString> outputs MEMBER m_outputs NOTIFY outputsChanged)

public:
    static QString processIconInternal(const QString& inPath, IconKind type, const QString& idToExtract, int32_t targetSize);
    void setInput(const QString& input);
    void setInputs(const QList<QString>& input);
    Q_INVOKABLE void optimizeAll();
    Q_INVOKABLE void optimizeWithRsvg();
    Q_INVOKABLE void optimizeWithScour();
    Q_INVOKABLE void classAsLight();
    Q_INVOKABLE void classAsDark();

signals:
    void inputChanged();
    void outputChanged();
    void inputsChanged();
    void outputsChanged();
    void pluralChanged();

private:
    QString m_input;
    QString m_output;

    bool m_plural;

    QList<QString> m_inputs;
    QList<QString> m_outputs;
};