#include <QDebug>
#include <QSettings>
#include <QMetaType>
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

// TODO: currenly only correcly returns QVariant types: QVariant(QString), QVariant(bool).
// Add support for other types (like int, double) when needed.
// By default the returned value is of type QVariant(QString).
const QVariant & QSettingsItemQmlProxy::value()
{
    if (_qsettings) {
        _value = _qsettings->value(_key, _defaultValue);
        //qDebug() << "type of default value: " << _defaultValue.typeName();
        if (_defaultValue.type() == QMetaType::Bool) {
            _value = QVariant(_value.toBool());
        }
        qDebug() << "reading key/value " << _key << "/" << _value;
    }
    return _value;
}

void QSettingsItemQmlProxy::setValue(const QVariant &newValue)
{
    if (_qsettings) {
        if (_value != newValue) {
            _qsettings->setValue(_key, newValue);
            qDebug() << "writing key/value " << _key << "/" << newValue;
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
