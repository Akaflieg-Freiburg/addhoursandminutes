#include <QGuiApplication>
#include <QScreen>
#include <QTimer>

#include "platformAdapter.h"


#if defined(Q_OS_ANDROID)
#include <QJniObject>
#endif

#if defined(Q_OS_IOS)
#include "ios/ObjCAdapter.h"
#endif

PlatformAdapter::PlatformAdapter(QObject* parent)
    : QObject(parent)
{
    auto* timer = new QTimer(this);
    timer->setSingleShot(true);
    timer->setInterval(100);
    connect(timer, &QTimer::timeout, this, &PlatformAdapter::getSafeInsets);
    connect(QGuiApplication::primaryScreen(), &QScreen::orientationChanged, timer, [timer]{ timer->start(); });
    timer->start();
}


void PlatformAdapter::getSafeInsets()
{

#if defined(Q_OS_ANDROID)
    auto devicePixelRatio = QGuiApplication::primaryScreen()->devicePixelRatio();
    if ( !qIsFinite(devicePixelRatio) || (devicePixelRatio < 0.0))
    {
        return;
    }

    auto safeInsetBottom = static_cast<double>(QJniObject::callStaticMethod<jdouble>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "safeInsetBottom"));
    if ( qIsFinite(safeInsetBottom) && (safeInsetBottom >= 0.0) )
    {
        safeInsetBottom = safeInsetBottom/devicePixelRatio;
        if (safeInsetBottom != _safeInsetBottom)
        {
            _safeInsetBottom = safeInsetBottom;
            emit safeInsetBottomChanged();
        }
    }

    auto safeInsetLeft = static_cast<double>(QJniObject::callStaticMethod<jdouble>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "safeInsetLeft"));
    if ( qIsFinite(safeInsetLeft) && (safeInsetLeft >= 0.0) )
    {
        safeInsetLeft = safeInsetLeft/devicePixelRatio;
        if (safeInsetLeft != _safeInsetLeft)
        {
            _safeInsetLeft = safeInsetLeft;
            emit safeInsetLeftChanged();
        }
    }

    auto safeInsetRight = static_cast<double>(QJniObject::callStaticMethod<jdouble>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "safeInsetRight"));
    if ( qIsFinite(safeInsetRight) && (safeInsetRight >= 0.0) )
    {
        safeInsetRight = safeInsetRight/devicePixelRatio;
        if (safeInsetRight != _safeInsetRight)
        {
            _safeInsetRight = safeInsetRight;
            emit safeInsetRightChanged();
        }
    }

    auto safeInsetTop = static_cast<double>(QJniObject::callStaticMethod<jdouble>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "safeInsetTop"));
    if ( qIsFinite(safeInsetTop) && (safeInsetTop >= 0.0) )
    {
        safeInsetTop = safeInsetTop/devicePixelRatio;
        if (safeInsetTop != _safeInsetTop)
        {
            _safeInsetTop = safeInsetTop;
            emit safeInsetTopChanged();
        }
    }
#endif

#warning need iOS implementation!
}


//Vibration normal
void PlatformAdapter::vibrateBrief()
{
    Q_UNUSED(this)

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
    Q_UNUSED(this)

#if defined(Q_OS_IOS)
    ObjCAdapter::vibrateError();
#endif

#if defined(Q_OS_ANDROID)
    QJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "vibrateError");
#endif
}
