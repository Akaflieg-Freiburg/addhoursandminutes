#!/bin/bash

#
# This script builds "Add Times" for Android in debug mode.
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


#
# Configure
#

$Qt6_DIR_ANDROID\_x86_64/bin/qt-cmake \
  -DCMAKE_BUILD_TYPE:STRING="Debug" \
  -DQT_ANDROID_ABIS="arm64-v8a" \
  -G Ninja \
  -S . \
  -B build-android-debug 


#
# Compile
#

cmake --build build-android-debug
