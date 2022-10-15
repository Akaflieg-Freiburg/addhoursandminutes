#ifndef PlATFORMADAPTER_H
#define PlATFORMADAPTER_H

#include <QObject>
#include <QQmlEngine>

class PlatformAdapter : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit PlatformAdapter(QObject *parent = 0);

public slots:
    /* On Android, make the device briefly vibrate. On other platforms, this does nothing. */
    void vibrateBrief();
    void vibrateError();
};

#endif // ANDROIDADAPTOR_H
