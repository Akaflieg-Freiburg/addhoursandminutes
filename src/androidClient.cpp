
#include "androidClient.h"

#if defined(Q_OS_ANDROID)
#include <QtAndroidExtras/QAndroidJniObject>
#include <QAndroidJniEnvironment>
#endif

AndroidClient::AndroidClient(QObject *parent)
  : QObject(parent)
{
  connect(this, SIGNAL(notificationChanged()), this, SLOT(updateAndroidNotification()));
}

void AndroidClient::setNotification(const QString &notification)
{
  if (m_notification == notification)
    return;
  
  m_notification = notification;
  emit notificationChanged();
}

QString AndroidClient::notification() const
{
  return m_notification;
}


void AndroidClient::vibrateBrief()
{
  //#if defined(Q_OS_ANDROID)
  QAndroidJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidClient",
					    "vibrateBrief");
  
  // Handle exceptions
  /*
    QAndroidJniEnvironment env;
    if (env->ExceptionCheck()) {
  // Nothing to be done for exceptions
    env->ExceptionClear();
    }
  */
  //#endif
}


void AndroidClient::updateAndroidNotification()
{
#if defined(Q_OS_ANDROID)
  QAndroidJniObject javaNotification = QAndroidJniObject::fromString(m_notification);
  QAndroidJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidClient",
					    "notify",
					    "(Ljava/lang/String;)V",
					    javaNotification.object<jstring>());
#endif
}
