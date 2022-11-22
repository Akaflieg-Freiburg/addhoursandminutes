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
    explicit PlatformAdapter(QObject* parent = 0);

#warning
    Q_PROPERTY(double safeInsetBottom READ safeInsetBottom NOTIFY safeInsetBottomChanged)
    Q_PROPERTY(double safeInsetLeft READ safeInsetLeft NOTIFY safeInsetLeftChanged)
    Q_PROPERTY(double safeInsetRight READ safeInsetRight NOTIFY safeInsetRightChanged)
    Q_PROPERTY(double safeInsetTop READ safeInsetTop NOTIFY safeInsetTopChanged)

#warning
    double safeInsetBottom() {return _safeInsetBottom;}
    double safeInsetLeft() {return _safeInsetLeft;}
    double safeInsetRight() {return _safeInsetRight;}
    double safeInsetTop() {return _safeInsetTop;}

public slots:
    /* On Android and iOS, make the device briefly vibrate. On other platforms, this does nothing. */
    void vibrateBrief();

    /* On Android and iOS, make the device briefly vibrate three times. On other platforms, this does nothing. */
    void vibrateError();

signals:
#warning
    void safeInsetBottomChanged();
    void safeInsetLeftChanged();
    void safeInsetRightChanged();
    void safeInsetTopChanged();

private:
    // Computes the values of the member variables _safeInset* and emits the notification signals as appropriate.
    void getSafeInsets();

    // Member variables
    double _safeInsetBottom {0.0};
    double _safeInsetLeft {0.0};
    double _safeInsetRight {0.0};
    double _safeInsetTop {0.0};
};

#endif // ANDROIDADAPTOR_H
