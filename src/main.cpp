/***************************************************************************
 *   Copyright (C) 2018-2022 by Stefan Kebekus                             *
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

#include <QFile>
#include <QFont>
#include <QGuiApplication>
#include <QLibraryInfo>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QQuickView>
#include <QSettings>
#include <QTranslator>

auto main(int argc, char *argv[]) -> int
{
    QGuiApplication app(argc, argv);

    // Install translators
    QString locale = QLocale::system().name();
    QTranslator translator;
    if (translator.load(QStringLiteral(":i18n/addhoursandminutes_") + locale.left(2))) {
        QGuiApplication::installTranslator(&translator);
    }
    QTranslator Qt_translator;
    if (Qt_translator.load("qt_" + locale.left(2), QLibraryInfo::path(QLibraryInfo::TranslationsPath))) {
        QGuiApplication::installTranslator(&Qt_translator);
    }

    // Set application parameters
    QCoreApplication::setOrganizationName(QStringLiteral("Akaflieg Freiburg"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("akaflieg_freiburg.de"));
    QCoreApplication::setApplicationName( QCoreApplication::translate("C++ Main Program", "Add Times", "Application Name") );
    QGuiApplication::setWindowIcon(QIcon(":/icon.png"));
#if defined(Q_OS_LINUX)
    QGuiApplication::setDesktopFileName(QStringLiteral("de.akaflieg_freiburg.cavok.add_hours_and_minutes"));
#endif

#if defined(Q_OS_WINDOWS)
    QQuickStyle::setStyle(u"Universal"_qs);
#endif

    // Start QML Engine
    QQmlApplicationEngine engine;

    // Attach FirstRunNotifier
    engine.rootContext()->setContextProperty(QStringLiteral("projectVersion"), PROJECT_VERSION);

    // Make screen available to QML
    engine.rootContext()->setContextProperty(QStringLiteral("primaryScreen"), QGuiApplication::primaryScreen());

    // Make font scaling factor available to QML engine; this scaling factor
    // depends on the platform
#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty(QStringLiteral("fontScale"), 1.5);
#else
    engine.rootContext()->setContextProperty(QStringLiteral("fontScale"), 1.2);
#endif

    // Now load the QML code
    engine.load(QStringLiteral("qrc:/qt/qml/gui/qml/main.qml"));

#ifdef Q_OS_ANDROID
    QNativeInterface::QAndroidApplication::hideSplashScreen();
#endif

    return QGuiApplication::exec();
}
