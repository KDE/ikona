#include "thememodel.h"
#include <QApplication>
#include <QClipboard>
#include <QDesktopServices>
#include <QDebug>
#include <QDir>
#include <QUrl>

Icon::Icon(QObject* parent) : QObject(parent) {}

void Icon::copyName() {
    QApplication::clipboard()->setText(m_name);
}

void Icon::openInFileManager() {
    QFileInfo fi(m_location);
    QDesktopServices::openUrl(fi.absoluteDir().absolutePath());
}

void Icon::openInEditor() {
    QDesktopServices::openUrl(m_location);
}

qint32 Icon::displaySize() { return parentDir()->displaySize(); }

IconDirectory* Icon::parentDir() { auto dir = qobject_cast<IconDirectory*>(parent()); Q_ASSERT(dir); return dir; }
IconTheme* Icon::parentTheme() { auto theme = qobject_cast<IconTheme*>(parent()->parent()); Q_ASSERT(theme); return theme; }

QList<Icon*> Icon::sameThemeDifferentSize() {
    auto theme = parentTheme();

    QList<Icon*> retList;

    for (auto icon : theme->findChildren<Icon*>()) {
        if (icon->m_name == m_name) {
            retList << icon;
        }
    }

    struct {
        bool operator()(Icon* a, Icon* b) const {
            return a->parentDir()->displaySize() < b->parentDir()->displaySize();
        }
    } customLess;

    std::sort(retList.begin(), retList.end(), customLess);

    return retList;
}

QList<Icon*> Icon::sameSizeDifferentTheme() {
    auto themes = qobject_cast<ThemeModel*>(parentTheme()->parent());

    QList<Icon*> retList;

    for (auto icon : themes->findChildren<Icon*>()) {
        if (icon->m_name == m_name && icon->displaySize() == displaySize()) {
            retList << icon;
        }
    }

    struct {
        bool operator()(Icon* a, Icon* b) const {
            return a->parentTheme()->m_displayName.compare(b->parentTheme()->m_displayName);
        }
    } customLess;

    std::sort(retList.begin(), retList.end(), customLess);

    return retList;
}

IconDirectory::IconDirectory(QObject* parent) : QObject(parent) {}

qint32 IconDirectory::displaySize() {
    if (m_type == Fixed || m_type == Threshold) {
        return m_size;
    } else if (m_type == Scalable) {
        return m_minSize;
    }
}

IconTheme* IconDirectory::parentTheme() { auto theme = qobject_cast<IconTheme*>(parent()); Q_ASSERT(theme); return theme; }

IconTheme::IconTheme(QObject* parent) : QObject(parent) {}

ThemeModel::ThemeModel(QObject *parent) : QAbstractListModel(parent)
{
    m_themes = ikona_theme_list_new();

    if (m_themes) {
        for (int i = 0; i < ikona_theme_list_get_length(m_themes); i++) {
            IconTheme* theme = new IconTheme(this);
            auto cTheme = ikona_theme_list_get_index(m_themes, i);
            
            auto cStr = ikona_theme_get_display_name(cTheme);
            theme->m_displayName = QString::fromUtf8(cStr);
            ikona_string_free(cStr);

            cStr = ikona_theme_get_name(cTheme);
            theme->m_name = QString::fromUtf8(cStr);
            ikona_string_free(cStr);

            cStr = ikona_theme_get_root_path(cTheme);
            theme->m_rootPath = QString::fromUtf8(cStr);
            ikona_string_free(cStr);

            auto directories = ikona_theme_get_directory_list(cTheme);

            if (directories) {
                for (int i = 0; i < ikona_theme_directory_list_get_length(directories); i++) {
                    IconDirectory* directory = new IconDirectory(theme);
                    auto cDirectory = ikona_theme_directory_list_get_index(directories, i);

                    directory->m_size = ikona_theme_directory_get_size(cDirectory);
                    directory->m_scale = ikona_theme_directory_get_scale(cDirectory);
                    directory->m_context = (IconDirectory::Context)ikona_theme_directory_get_context(cDirectory);
                    directory->m_type = (IconDirectory::Type)ikona_theme_directory_get_type(cDirectory);
                    directory->m_threshold = ikona_theme_directory_get_threshold(cDirectory);
                    directory->m_minSize = ikona_theme_directory_get_min_size(cDirectory);
                    directory->m_maxSize = ikona_theme_directory_get_max_size(cDirectory);
                    
                    auto cStr = ikona_theme_directory_get_location(cDirectory);
                    directory->m_location = QString::fromUtf8(cStr);
                    ikona_string_free(cStr);

                    directory->m_fullLocation = QDir::cleanPath(theme->m_rootPath + QDir::separator() + directory->m_location);

                    auto icons = ikona_theme_directory_get_icon_list(cDirectory);

                    if (icons) {
                        for (int i = 0; i < ikona_icon_list_get_length(icons); i++) {
                            Icon* icon = new Icon(directory);
                            auto cIcon = ikona_icon_list_get_index(icons, i);

                            auto cStr = ikona_theme_icon_get_location(cIcon);
                            icon->m_location = QString::fromUtf8(cStr);
                            ikona_string_free(cStr);

                            cStr = ikona_theme_icon_get_name(cIcon);
                            icon->m_name = QString::fromUtf8(cStr);
                            ikona_string_free(cStr);

                            directory->m_icons << icon;
                        }

                        ikona_icon_list_free(icons);
                    }

                    theme->m_iconDirectories << directory;
                }

                ikona_theme_directory_list_free(directories);
            }

            m_themeWrappers << theme;
        }

        ikona_theme_list_free(m_themes);
    }
}

QVariant ThemeModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid()
        || index.row() < 0
        || index.row() >= m_themeWrappers.length()) return QVariant();

    return QVariant::fromValue(m_themeWrappers[index.row()]);
}

QHash<int, QByteArray> ThemeModel::roleNames() const
{
    QHash<int, QByteArray> names = QAbstractItemModel::roleNames();
    names.insert(ThemeRole, "iconTheme");
    return names;
}

int ThemeModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid()) return 0;

    return m_themeWrappers.length();
}
