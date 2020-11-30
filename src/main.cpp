/***************************************************************************
 *   Copyright (C) 2018 - 2019 by Stefan Kebekus                           *
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


#include <QGuiApplication>
#include <QFile>
#include <QFont>
#include <QLibraryInfo>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include <QSettings>
#include <QTranslator>

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

#include "androidAdaptor.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    // Install translators
    QString locale = QLocale::system().name();
    QTranslator translator;
    translator.load(QString(":addhoursandminutes_") + locale.left(2));
    QGuiApplication::installTranslator(&translator);
    QTranslator Qt_translator;
    Qt_translator.load("qt_" + locale.left(2), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    QGuiApplication::installTranslator(&Qt_translator);

    // Set application parameters
    QCoreApplication::setOrganizationName("Akaflieg Freiburg");
    QCoreApplication::setOrganizationDomain("akaflieg_freiburg.de");
    QCoreApplication::setApplicationName( QCoreApplication::translate("C++ Main Program", "Add Hours and Minutes", "Application Name") );
    QGuiApplication::setWindowIcon(QIcon(":/icon.png"));
#if defined(Q_OS_LINUX)
    QGuiApplication::setDesktopFileName("de.akaflieg_freiburg.cavok.add_hours_and_minutes");
#endif

    // Start QML Engine
    QQmlApplicationEngine engine;

    // Make AndroidAdaptor available to QML engine
    auto *adaptor = new AndroidAdaptor(&engine);
    engine.rootContext()->setContextProperty("AndroidAdaptor", adaptor);

    // Attach FirstRunNotifier
    engine.rootContext()->setContextProperty("projectVersion", PROJECT_VERSION);

    // Make font scaling factor available to QML engine; this scaling factor
    // depends on the platform
#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty("fontScale", 1.5);
#else
    engine.rootContext()->setContextProperty("fontScale", 1.2);
#endif

    // Now load the QML code
    engine.load("qrc:/qml/main.qml");

#ifdef Q_OS_ANDROID
    QtAndroid::hideSplashScreen();
#endif

    return QGuiApplication::exec();
}
