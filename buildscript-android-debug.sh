#!/bin/bash

#
# This script builds "Add Hours and Minutes" for Android in debug mode.
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
    
rm -rf build-android-debug
mkdir -p build-android-debug
cd build-android-debug


#
# Configure
#

ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/22.1.7171670
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.15.0.10-1.fc35.x86_64

$Qt6_DIR_ANDROID\_x86/bin/qt-cmake .. \
  -G Ninja \
  -DCMAKE_BUILD_TYPE:STRING=Debug


#
# Compile
#

ninja


#
# cd out
#

cd ..
