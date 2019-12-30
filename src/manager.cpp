#include <QModelIndex>
#include <QColor>
#include <QClipboard>
#include <QApplication>

#include <KColorSchemeManager>

#include "manager.h"

ColourSchemeManager::ColourSchemeManager(QObject* parent) : QObject(parent) {
    this->manager = new KColorSchemeManager(parent);
}

void ColourSchemeManager::set(const QString& scheme) {
    this->manager->activateScheme(this->manager->indexForScheme(scheme));
}

void ColourSchemeManager::copy(QColor colour) {
    QClipboard *clip = QApplication::clipboard();
    clip->setText(colour.name(QColor::NameFormat::HexRgb));
}
