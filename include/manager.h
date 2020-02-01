#pragma once

#include <QObject>
#include <QColor>

class ClipboardManager : public QObject {
    Q_OBJECT
public:
    explicit ClipboardManager(QObject *parent = nullptr);
    Q_INVOKABLE void copy(const QColor& colour);
    Q_INVOKABLE void copyImage(const QImage& image);
};
