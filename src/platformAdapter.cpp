/***************************************************************************
 *   Copyright (C) 2018-2025 by Stefan Kebekus                             *
 *   stefan.kebekus@math.uni-freiburg.de                                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/

#include "platformAdapter.h"

#if defined(Q_OS_ANDROID)
#include <QJniObject>
#endif

#if defined(Q_OS_IOS)
#include "ios/ObjCAdapter.h"
#endif

PlatformAdapter::PlatformAdapter(QObject* parent)
    : QObject(parent)
{
}

//Vibration normal
void PlatformAdapter::vibrateBrief()
{
#if defined(Q_OS_IOS)
    ObjCAdapter::vibrateBrief();
#endif

#if defined(Q_OS_ANDROID)
    QJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "vibrateBrief");
#endif
}

//Vibration Error
void PlatformAdapter::vibrateError()
{
#if defined(Q_OS_IOS)
    ObjCAdapter::vibrateError();
#endif

#if defined(Q_OS_ANDROID)
    QJniObject::callStaticMethod<void>("de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor", "vibrateError");
#endif
}
