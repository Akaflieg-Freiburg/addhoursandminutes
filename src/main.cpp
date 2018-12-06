/***************************************************************************
 *   Copyright (C) 2018 by Stefan Kebekus                                  *
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

#include <QApplication>
#include <QGuiApplication>
#include <QFile>
#include <QFont>
#include <QLibraryInfo>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickView>
#include <QTranslator>


int main(int argc, char *argv[])
{
  QApplication app(argc, argv);
  
  // Install translators
  QString locale = QLocale::system().name();
  QTranslator translator;
  translator.load(QString(":addHoursAndMinutes_") + locale.left(2));
  app.installTranslator(&translator);
  QTranslator Qt_translator;
  Qt_translator.load("qt_" + locale.left(2), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
  app.installTranslator(&Qt_translator);

  // Set application parameters
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QCoreApplication::setOrganizationName("Akaflieg Freiburg");
  QCoreApplication::setOrganizationDomain("akaflieg_freiburg.de");
  QCoreApplication::setApplicationName( QCoreApplication::translate("C++ Main Program", "Add Hours and Minutes", "Application Name") );
  QGuiApplication::setWindowIcon(QIcon(":/icon.svg"));
#if defined(Q_OS_LINUX)
  QGuiApplication::setDesktopFileName("de.akaflieg_freiburg.cavok.add_hours_and_minutes");
#endif
  
  
  // Set font size, depending on platform
  QFont stdFont = app.font();
#warning Muss noch testen!
#ifdef Q_OS_ANDROID
  stdFont.setPointSizeF(stdFont.pointSizeF()*2.0);
#else
  stdFont.setPointSizeF(stdFont.pointSizeF()*1.2);
#endif  
  app.setFont(stdFont);
  
  // Load large strings from files, in order to make them available to QML
  QFile file(":text/info.html");
  file.open(QIODevice::ReadOnly);
  auto infoText = file.readAll();
  
  // Start QML Engine
  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("infoText", infoText);
  engine.load("qrc:/qml/main.qml");
  
  return app.exec();
}
