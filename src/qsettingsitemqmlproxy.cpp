/*
  Copyright (C) 2014 Jussi Vuorisalmi <jussi.vuorisalmi@iki.fi>
  All rights reserved.

  This file is part of the harbour-orienteeringcompass package.

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
