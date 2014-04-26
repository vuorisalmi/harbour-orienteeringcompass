#ifndef QSETTINGSQMLPROXY_H
#define QSETTINGSQMLPROXY_H

#include <QQuickItem>
#include <QSettings>

class QSettingsQmlProxy : public QQuickItem
{
    Q_OBJECT
//    Q_PROPERTY(QString nightmode READ nightmode WRITE setNightmode)

public:
    explicit QSettingsQmlProxy(QQuickItem *parent = 0);
    ~QSettingsQmlProxy();

    Q_INVOKABLE void setValue(const QString &key, const QVariant &newValue);
    Q_INVOKABLE const QVariant &value(const QString &key, const QVariant defaultValue);

//    const QVariant &nightmode();
//    void setNightmode(const QVariant &newValue);

signals:

public slots:

private:
    QSettings *_qsettings;
    QVariant _tmpValue;
//    QVariant _nightmode;

//    QString _nightmodeKey;
//    QVariant _nightmodeDefault;

};

#endif // QSETTINGSQMLPROXY_H
