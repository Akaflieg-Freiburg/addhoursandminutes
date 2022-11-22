#include <QGuiApplication>
#include <QScreen>
#include <QTimer>
#include <chrono>

#include "platformAdapter.h"

using namespace std::chrono_literals;


#if defined(Q_OS_ANDROID)
#include <QJniObject>
#endif

#if defined(Q_OS_IOS)
#include "ios/ObjCAdapter.h"
#endif

PlatformAdapter::PlatformAdapter(QObject* parent)
    : QObject(parent)
{
    // Update the properties safeInsets* 100ms after the screen orientation changes.
    // Experience shows that the system calls on Android do not always
    // reflect updates in the safeInsets* immediately.
    auto* timer = new QTimer(this);
    timer->setSingleShot(true);
    timer->setInterval(100ms);
    connect(timer, &QTimer::timeout, this, &PlatformAdapter::updateSafeInsets);
    connect(QGuiApplication::primaryScreen(), &QScreen::orientationChanged, timer, [timer]{ timer->start(); });

    // Update the properties safeInsets* 100ms from now.
    timer->start();
}


void PlatformAdapter::updateSafeInsets()
{
    auto safeInsetBottom {_safeInsetBottom};
    auto safeInsetLeft {_safeInsetLeft};
    auto safeInsetRight {_safeInsetRight};
    auto safeInsetTop {_safeInsetTop};


#if defined(Q_OS_ANDROID)   
    auto devicePixelRatio = QGuiApplication::primaryScreen()->devicePixelRatio();
    if ( qIsFinite(devicePixelRatio) && (devicePixelRatio > 0.0))
    {
        double inset = 0.0;

        inset = static_cast<double>(QJniObject::callStaticMethod<jdouble>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "safeInsetBottom"));
        if ( qIsFinite(safeInsetBottom) && (safeInsetBottom >= 0.0) )
        {
            safeInsetBottom = inset/devicePixelRatio;
        }

        inset = static_cast<double>(QJniObject::callStaticMethod<jdouble>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "safeInsetLeft"));
        if ( qIsFinite(safeInsetLeft) && (safeInsetLeft >= 0.0) )
        {
            safeInsetLeft = inset/devicePixelRatio;
        }

        inset = static_cast<double>(QJniObject::callStaticMethod<jdouble>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "safeInsetRight"));
        if ( qIsFinite(safeInsetRight) && (safeInsetRight >= 0.0) )
        {
            safeInsetRight = inset/devicePixelRatio;
        }

        inset = static_cast<double>(QJniObject::callStaticMethod<jdouble>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "safeInsetTop"));
        if ( qIsFinite(safeInsetTop) && (safeInsetTop >= 0.0) )
        {
            safeInsetTop = inset/devicePixelRatio;
        }
    }
#endif

#if defined(Q_OS_IOS)
    auto primaryScreen = QGuiApplication::primaryScreen();
    safeInsetBottom = primaryScreen->size().height() - primaryScreen->availableGeometry().height() - primaryScreen->availableGeometry().y();
    safeInsetLeft = primaryScreen->availableGeometry().x();
    safeInsetRight =  primaryScreen->size().width() - primaryScreen->availableGeometry().width() - primaryScreen->availableGeometry().x();
    safeInsetTop = primaryScreen->availableGeometry().y();
#endif

    // Update properties and emit notification signals
    if (safeInsetBottom != _safeInsetBottom)
    {
        _safeInsetBottom = safeInsetBottom;
        emit safeInsetBottomChanged();
    }
    if (safeInsetLeft != _safeInsetLeft)
    {
        _safeInsetLeft = safeInsetLeft;
        emit safeInsetLeftChanged();
    }
    if (safeInsetRight != _safeInsetRight)
    {
        _safeInsetRight = safeInsetRight;
        emit safeInsetRightChanged();
    }
    if (safeInsetTop != _safeInsetTop)
    {
        _safeInsetTop = safeInsetTop;
        emit safeInsetTopChanged();
    }

}


//Vibration normal
void PlatformAdapter::vibrateBrief()
{
#if defined(Q_OS_IOS)
    ObjCAdapter::vibrateBrief();
#endif

#if defined(Q_OS_ANDROID)
    QJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "vibrateBrief");
#endif
}

//Vibration Error
void PlatformAdapter::vibrateError()
{
#if defined(Q_OS_IOS)
    ObjCAdapter::vibrateError();
#endif

#if defined(Q_OS_ANDROID)
    QJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "vibrateError");
#endif
}
