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
    /* On Android and iOS, make the device briefly vibrate. On other platforms, this does nothing. */
    void vibrateBrief();

    /* On Android and iOS, make the device briefly vibrate three times. On other platforms, this does nothing. */
    void vibrateError();
};

#endif // ANDROIDADAPTOR_H
