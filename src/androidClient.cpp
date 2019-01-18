
#include "androidClient.h"

#if defined(Q_OS_ANDROID)
#include <QtAndroidExtras/QAndroidJniObject>
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

void AndroidClient::buzz()
{
  #warning not implemented
}


void AndroidClient::updateAndroidNotification()
{
#if defined(Q_OS_ANDROID)
  /*
  QAndroidJniObject javaNotification = QAndroidJniObject::fromString(m_notification);
  QAndroidJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidClient.java",
					    "notify",
					    "(Ljava/lang/String;)V",
					    javaNotification.object<jstring>());
  */
#endif
}
