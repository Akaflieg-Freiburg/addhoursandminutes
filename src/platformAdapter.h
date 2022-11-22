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

    // Safe inset at bottom of screen, so as to avoid system status bars and display cutouts
    Q_PROPERTY(double safeInsetBottom READ safeInsetBottom NOTIFY safeInsetBottomChanged)

    // Safe inset at left of screen, so as to avoid system status bars and display cutouts
    Q_PROPERTY(double safeInsetLeft READ safeInsetLeft NOTIFY safeInsetLeftChanged)

    // Safe inset at right of screen, so as to avoid system status bars and display cutouts
    Q_PROPERTY(double safeInsetRight READ safeInsetRight NOTIFY safeInsetRightChanged)

    // Safe inset at top of screen, so as to avoid system status bars and display cutouts
    Q_PROPERTY(double safeInsetTop READ safeInsetTop NOTIFY safeInsetTopChanged)


    // Getter method
    double safeInsetBottom() const {return _safeInsetBottom;}

    // Getter method
    double safeInsetLeft() const {return _safeInsetLeft;}

    // Getter method
    double safeInsetRight() const {return _safeInsetRight;}

    // Getter method
    double safeInsetTop() const {return _safeInsetTop;}

public slots:
    /* On Android and iOS, make the device briefly vibrate. On other platforms, this does nothing. */
    static void vibrateBrief();

    /* On Android and iOS, make the device briefly vibrate three times. On other platforms, this does nothing. */
    static void vibrateError();

signals:
    // Notifier signal
    void safeInsetBottomChanged();

    // Notifier signal
    void safeInsetLeftChanged();

    // Notifier signal
    void safeInsetRightChanged();

    // Notifier signal
    void safeInsetTopChanged();

private:
    // Computes the values of the member variables _safeInset* and emits the notification signals as appropriate.
    void updateSafeInsets();

    // Member variables
    double _safeInsetBottom {0.0};
    double _safeInsetLeft {0.0};
    double _safeInsetRight {0.0};
    double _safeInsetTop {0.0};
};

#endif // ANDROIDADAPTOR_H
