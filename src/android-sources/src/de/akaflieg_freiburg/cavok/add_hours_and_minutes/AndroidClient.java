package de.akaflieg_freiburg.cavok.add_hours_and_minutes;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Vibrator;

public class AndroidClient extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static NotificationManager m_notificationManager;
    private static Notification.Builder m_builder;
    private static AndroidClient m_instance;
    private static Vibrator m_vibes;

    public AndroidClient()
    {
        m_instance = this;
    }

    public static void notify(String s)
    {
        if (m_vibes == null)
            m_vibes = (Vibrator) m_instance.getSystemService(Context.VIBRATOR_SERVICE);
        m_vibes.vibrate(20);

/*
        if (m_notificationManager == null) {
            m_notificationManager = (NotificationManager)m_instance.getSystemService(Context.NOTIFICATION_SERVICE);
            m_builder = new Notification.Builder(m_instance);
            m_builder.setSmallIcon(R.drawable.icon);
            m_builder.setContentTitle("A message from Qt!");
        }

        m_builder.setContentText(s);
        m_notificationManager.notify(1, m_builder.build());
*/
    }
}
