#ifndef QSETTINGSITEMQMLPROXY_H
#define QSETTINGSITEMQMLPROXY_H

#include <QObject>
#include <QString>
#include <QVariant>
#include <QSettings>

class QSettingsItemQmlProxy : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString key READ key WRITE setKey)
    Q_PROPERTY(QVariant value READ value WRITE setValue)
    Q_PROPERTY(QVariant defaultValue READ defaultValue WRITE setDefaultValue)

public:
    explicit QSettingsItemQmlProxy(QObject *parent = 0);
    ~QSettingsItemQmlProxy();

    const QString &key();
    void setKey(const QString &newKey);
    const QVariant &value();
    void setValue(const QVariant &newValue);
    const QVariant &defaultValue();
    void setDefaultValue(const QVariant &newValue);

signals:

public slots:

private:
    QSettings *_qsettings;
    QString _key;
    QVariant _value;
    QVariant _defaultValue;
};

#endif // QSETTINGSITEMQMLPROXY_H
