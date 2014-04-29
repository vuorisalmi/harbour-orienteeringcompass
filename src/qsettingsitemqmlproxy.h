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
    Q_PROPERTY(QVariant value READ value WRITE setValue NOTIFY valueChanged)
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
    void valueChanged();

public slots:

private:
    QSettings *_qsettings;
    QString _key;
    QVariant _value;
    QVariant _defaultValue;
};

#endif // QSETTINGSITEMQMLPROXY_H
