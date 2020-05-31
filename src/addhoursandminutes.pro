QT += qml
QT += quick
  
CONFIG += qtquickcompiler
CONFIG += c++11
CONFIG += release

SOURCES += androidAdaptor.cpp 
SOURCES += main.cpp

HEADERS += androidAdaptor.h

RESOURCES += addhoursandminutes.qrc

TRANSLATIONS += addhoursandminutes_de.ts
