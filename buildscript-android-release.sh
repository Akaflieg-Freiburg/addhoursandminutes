#!/bin/bash

#
# This script builds "Add Times" for Android in release mode.
#
# See https://github.com/Akaflieg-Freiburg/addhoursandminutes/wiki/Build-scripts
#

#
# Copyright © 2020-2021 Stefan Kebekus <stefan.kebekus@math.uni-freiburg.de>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA.
#


#
# Fail on first error
#

set -e

#
# Clean up
#
    
rm -rf build-android-release
mkdir -p build-android-release
cd build-android-release
    
#
# Configure
#

export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/23.1.7779620
export JAVA_HOME=/usr/lib/jvm/java-19-openjdk

$Qt6_DIR_ANDROID\_x86/bin/qt-cmake .. \
  -G Ninja\
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DQT_ANDROID_BUILD_ALL_ABIS=ON
    
#
# Compile
#
    
ninja aab

mv ./src/android-build/build/outputs/bundle/release/android-build-release.aab ./addhoursandminutes.aab

jarsigner -keystore $ANDROID_KEYSTORE_FILE \
  -storepass $ANDROID_KEYSTORE_PASS \
   ./addhoursandminutes.aab \
   "Stefan Kebekus"

echo "Signed AAB file is available at $PWD/addhoursandminutes.aab"
nautilus $PWD &

#
# cd out
#

cd ..

