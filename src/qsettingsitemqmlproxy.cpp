#include <QDebug>
#include <QSettings>
#include "qsettingsitemqmlproxy.h"

QSettingsItemQmlProxy::QSettingsItemQmlProxy(QObject *parent) :
    QObject(parent)
{
    _qsettings = new QSettings();
    _key = "";
    _defaultValue = "";
}

QSettingsItemQmlProxy::~QSettingsItemQmlProxy()
{
    if (_qsettings) {
        delete _qsettings;
    }
}

const QString & QSettingsItemQmlProxy::key()
{
    return _key;
}

void QSettingsItemQmlProxy::setKey(const QString &newKey)
{
    _key = newKey;
}

const QVariant & QSettingsItemQmlProxy::value()
{
    if (_qsettings) {
        _value = _qsettings->value(_key, _defaultValue);
        qDebug() << "reading key/value " << _key << "/" << _value << "\n";
    }
    return _value;
}

void QSettingsItemQmlProxy::setValue(const QVariant &newValue)
{
    if (_qsettings) {
        if (_value != newValue) {
            _qsettings->setValue(_key, newValue);
            qDebug() << "writing key/value " << _key << "/" << newValue << "\n";
            _value = newValue;
            emit valueChanged();
        }
    }
}

const QVariant & QSettingsItemQmlProxy::defaultValue()
{
    return _defaultValue;
}

void QSettingsItemQmlProxy::setDefaultValue(const QVariant &newValue)
{
    _defaultValue = newValue;
}
