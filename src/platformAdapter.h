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

    /*! \brief Height of window, for Android systems
     *
     *  On Android, users can split the screen, in order to show two apps next
     *  to one another (or on top of one another). Neither the ApplicationWindow
     *  QML class nor the QScreen C++ class is aware of this change, so that the
     *  right/bottom part of the app become invisible. The wHeight property here
     *  reflects the usable window height. The property automatically updates
     *  when the split view is switched on/off, or when the relative size of the
     *  windows changes.
     *
     *  On systems other than Android, this property contains NaN.
     */
    Q_PROPERTY(double wHeight READ wHeight NOTIFY wHeightChanged)

    /*! \brief Width of window, for Android systems
     *
     *  @see wHeight
     */
    Q_PROPERTY(double wWidth READ wWidth NOTIFY wWidthChanged)


    // Getter method
    double safeInsetBottom() const {return _safeInsetBottom;}

    // Getter method
    double safeInsetLeft() const {return _safeInsetLeft;}

    // Getter method
    double safeInsetRight() const {return _safeInsetRight;}

    // Getter method
    double safeInsetTop() const {return _safeInsetTop;}

    /*! \brief Getter function for the property with the same name
     *
     *  @returns Property wHeight
     */
    double wHeight() const {return m_wHeight;}

    /*! \brief Getter function for the property with the same name
     *
     *  @returns Property wWidth
     */
    double wWidth() const {return m_wWidth;}

public slots:
    /* On Android and iOS, make the device briefly vibrate. On other platforms, this does nothing. */
    static void vibrateBrief();

    /* On Android and iOS, make the device briefly vibrate three times. On other platforms, this does nothing. */
    static void vibrateError();

    // Computes the values of the member variables _safeInset* and emits the notification signals as appropriate.
    void updateSafeInsets();

signals:
    // Notifier signal
    void safeInsetBottomChanged();

    // Notifier signal
    void safeInsetLeftChanged();

    // Notifier signal
    void safeInsetRightChanged();

    // Notifier signal
    void safeInsetTopChanged();

    /*! \brief Notifier signal */
    void wHeightChanged();

    /*! \brief Notifier signal */
    void wWidthChanged();

private:
    // Member variables
    double _safeInsetBottom {0.0};
    double _safeInsetLeft {0.0};
    double _safeInsetRight {0.0};
    double _safeInsetTop {0.0};
    double m_wHeight {qQNaN()};
    double m_wWidth {qQNaN()};
};

#endif // ANDROIDADAPTOR_H
