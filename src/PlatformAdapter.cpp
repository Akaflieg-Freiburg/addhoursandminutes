
#include "PlatformAdapter.h"
#include "ios/ObjCAdapter.h"

#include <QJniObject>

PlatformAdapter::PlatformAdapter(QObject *parent)
    : QObject(parent)
{
}


//Vibration normal
void PlatformAdapter::vibrateBrief()
{
#if defined(Q_OS_IOS)
    ObjCAdapter::vibrateBrief();
#endif

#if defined(Q_OS_ANDROID)
    QJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor",
                                       "vibrateBrief");
#endif
}

//Vibration Error
void PlatformAdapter::vibrateError()
{
#if defined(Q_OS_IOS)
    ObjCAdapter::vibrateError();
#endif

#if defined(Q_OS_ANDROID)
    QJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor",
                                       "vibrateBrief");
#endif
}
