#!/bin/bash

#
# Use cmake to generate icons and to configure files
#

rm -rf build-intermediate
mkdir build-intermediate
cd build-intermediate
cmake ..
make icons
make translations
cd ..
rm -rf build-intermediate

#
# Now the build starts in earnest
#

# Clear and generate build directory, cd into there
rm -rf build-android-armv7
mkdir build-android-armv7
cd build-android-armv7

# Compile
export JAVA_HOME=/usr/lib/jvm/java
export ANDROID_SDK_ROOT=/home/kebekus/Software/buildsystems/Android-SDK
export ANDROID_NDK_ROOT=/home/kebekus/Software/buildsystems/Android-SDK/ndk-bundle
export QTDIR=/home/kebekus/Software/buildsystems/Qt/5.12.2
$QTDIR/android_armv7/bin/qmake ../src/addhoursandminutes.pro -spec android-clang CONFIG+=qtquickcompiler CONFIG+=release
make -j9
make install INSTALL_ROOT=.
$QTDIR/android_armv7/bin/androiddeployqt --input android-libaddhoursandminutes.so-deployment-settings.json --output . --android-platform android-28 --jdk $JAVA_HOME --gradle --release --sign ~/.android-keystore/android.jks "stefan kebekus"
