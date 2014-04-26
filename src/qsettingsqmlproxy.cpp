//#include <iostream>
#include <QDebug>
#include <QSettings>
#include "qsettingsqmlproxy.h"

QSettingsQmlProxy::QSettingsQmlProxy(QQuickItem *parent) :
    QQuickItem(parent)
{
    _qsettings = new QSettings();

//    _nightmodeKey = "Nightmode";
//    _nightmodeDefault = "auto";
}

QSettingsQmlProxy::~QSettingsQmlProxy()
{
    if (_qsettings) {
        delete _qsettings;
    }
}

void QSettingsQmlProxy::setValue(const QString &key, const QVariant &newValue)
{
    if (_qsettings) {
        _qsettings->setValue(key, newValue);
    }
}

const QVariant & QSettingsQmlProxy::value(const QString &key, const QVariant defaultValue)
{
    // TODO: A small (but insignificant) memory leak?
    //QVariant *retValue = new QVariant();

    if (_qsettings) {
        _tmpValue = _qsettings->value(key, defaultValue);
        qDebug() << "Settings: value " << _tmpValue << "\n";

        //*retValue = _qsettings->value(key, defaultValue);
        //qDebug() << "Settings: value " << *retValue << "\n";
        //std::cout << "Settings: value " << *retValue << "\n";
    }
    return _tmpValue;
    //return *retValue;
}

//const QVariant & QSettingsQmlProxy::nightmode()
//{
//    if (_qsettings) {
//        _nightmode = _qsettings->value(_nightmodeKey, _nightmodeDefault);
//        qDebug() << "Settings: nightmode " << _nightmode << "\n";
//    }
//    return _nightmode;
//}

//void QSettingsQmlProxy::setNightmode(const QVariant &newValue)
//{
//    if (_qsettings) {
//        _qsettings->setValue(_nightmodeKey, newValue);
//    }
//    _nightmode = newValue;
//}
