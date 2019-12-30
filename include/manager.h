#pragma once

#include <QObject>
#include <KColorSchemeManager>
#include <QColor>

class ColourSchemeManager : public QObject {
    Q_OBJECT
public:
    explicit ColourSchemeManager(QObject *parent = nullptr);
    Q_INVOKABLE void set(const QString& scheme);
    Q_INVOKABLE void copy(const QColor& colour);
private:
    KColorSchemeManager* manager;
};
