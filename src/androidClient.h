
#ifndef ANDROIDCLIENT_H
#define ANDROIDCLIENT_H

#include <QObject>

#warning Documentation missing!

class AndroidClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString notification READ notification WRITE setNotification NOTIFY notificationChanged)

 public:
    explicit AndroidClient(QObject *parent = 0);

    void setNotification(const QString &notification);
    QString notification() const;

signals:
    void notificationChanged();

public slots:
    void vibrateBrief();

private slots:
    void updateAndroidNotification();

private:
    QString m_notification;
};

#endif // ANDROIDCLIENT_H
