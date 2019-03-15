CONFIG += c++11
CONFIG += lrelease embed_translations 
  
android {
  QT += androidextras
}
QT += qml
QT += quick

RESOURCES += addHoursAndMinutes.qrc
#RESOURCES += addHoursAndMinutes_translations.qrc 

SOURCES += androidAdaptor.cpp
SOURCES += main.cpp

HEADERS += androidAdaptor.h

TRANSLATIONS += addHoursAndMinutes_de.ts
