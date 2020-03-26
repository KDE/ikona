#pragma once

#include <QAbstractListModel>
#include "ikonars.h"

class IconTheme;
class IconDirectory;

class Icon : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name MEMBER m_name NOTIFY _)
    Q_PROPERTY(QString location MEMBER m_location NOTIFY _)

Q_SIGNALS:
    void _();

public:
    explicit Icon(QObject* parent = nullptr);

    Q_INVOKABLE void copyName();
    Q_INVOKABLE void openInFileManager();
    Q_INVOKABLE void openInEditor();
    Q_INVOKABLE QList<Icon*> sameThemeDifferentSize();
    Q_INVOKABLE QList<Icon*> sameSizeDifferentTheme();
    Q_INVOKABLE IconDirectory* parentDir();
    Q_INVOKABLE IconTheme* parentTheme();
    Q_INVOKABLE qint32 displaySize();

    QString m_name;
    QString m_location;
};

class IconDirectory : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qint32 size MEMBER m_size NOTIFY _)
    Q_PROPERTY(qint32 scale MEMBER m_scale NOTIFY _)
    Q_PROPERTY(Context context MEMBER m_context NOTIFY _)
    Q_PROPERTY(Type type MEMBER m_type NOTIFY _)
    Q_PROPERTY(qint32 threshold MEMBER m_threshold NOTIFY _)
    Q_PROPERTY(qint32 minSize MEMBER m_minSize NOTIFY _)
    Q_PROPERTY(qint32 maxSize MEMBER m_maxSize NOTIFY _)
    Q_PROPERTY(QString location MEMBER m_location NOTIFY _)
    Q_PROPERTY(QString fullLocation MEMBER m_fullLocation NOTIFY _)
    Q_PROPERTY(QList<Icon*> icons MEMBER m_icons NOTIFY _)

Q_SIGNALS:
    void _();

public:
    explicit IconDirectory(QObject* parent = nullptr);

    enum Context {
        Actions,
        Animations,
        Apps,
        Categories,
        Devices,
        Emblems,
        Emotes,
        Filesystems,
        International,
        Mimetypes,
        Places,
        Status,
        NoContext
    };
    Q_ENUM(Context)

    enum Type {
        Scalable,
        Threshold,
        Fixed,
        NoType
    };
    Q_ENUM(Type)

    Q_INVOKABLE qint32 displaySize();
    Q_INVOKABLE IconTheme* parentTheme();

    qint32 m_size;
    qint32 m_scale;
    Context m_context;
    Type m_type;
    qint32 m_threshold;
    qint32 m_minSize;
    qint32 m_maxSize;
    QString m_location;
    QString m_fullLocation;
    QList<Icon*> m_icons;
};

class IconTheme : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString displayName MEMBER m_displayName NOTIFY _)
    Q_PROPERTY(QString name MEMBER m_name NOTIFY _)
    Q_PROPERTY(QString rootPath MEMBER m_rootPath NOTIFY _)
    Q_PROPERTY(QList<IconDirectory*> iconDirectories MEMBER m_iconDirectories NOTIFY _)

Q_SIGNALS:
    void _();

public:
    explicit IconTheme(QObject* parent = nullptr);

    QString m_displayName;
    QString m_name;
    QString m_rootPath;
    QList<IconDirectory*> m_iconDirectories;
};

class ThemeModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ModelRoles {
        ThemeRole
    };

    explicit ThemeModel(QObject* parent = nullptr);

    QVariant data(const QModelIndex& index, int role) const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    QHash<int, QByteArray> roleNames() const override;
private:
    QList<IconTheme*> m_themeWrappers;
    IkonaThemeList m_themes;
};