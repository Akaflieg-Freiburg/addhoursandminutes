android: QT += androidextras
QT += qml
QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code APIsaway from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the  deprecated before Qt 6.0.0

SOURCES += androidAdaptor.cpp \
main.cpp

HEADERS += androidAdaptor.h

RESOURCES += addhoursandminutes.qrc

TRANSLATIONS += addhoursandminutes_de.ts

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
