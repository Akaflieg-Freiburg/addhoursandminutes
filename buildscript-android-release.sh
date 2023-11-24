#!/bin/bash


#
# Fail on first error
#

set -e

#
# Clean up
#
    
rm -rf build-android-release
mkdir -p build-android-release


#
# Configure
#


$Qt6_DIR_ANDROID\_x86/bin/qt-cmake \
  -G Ninja\
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DQT_ANDROID_BUILD_ALL_ABIS=ON \
  -S . \
  -B build-android-release


#
# Compile
#

cmake --build build-android-release --target aab
mv build-android-release/src/android-build/build/outputs/bundle/release/android-build-release.aab build-android-release/addhoursandminutes.aab

jarsigner -keystore $ANDROID_KEYSTORE_FILE \
  -storepass $ANDROID_KEYSTORE_PASS \
   build-android-release/addhoursandminutes.aab \
   "Stefan Kebekus"

echo "Signed AAB file is available at $PWD/build-android-release/addhoursandminutes.aab"
