#!/bin/bash

#
# This script builds "Add Hours and Minutes" for Android in release mode.
#
# See https://github.com/Akaflieg-Freiburg/addhoursandminutes/wiki/Build-scripts
#

#
# Copyright © 2020 Stefan Kebekus <stefan.kebekus@math.uni-freiburg.de>
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

export Qt6_DIR_ANDROID=/home/kebekus/Software/buildsystems/Qt/6.2.0/android_x86
export OPENSSL_ROOT_DIR=/home/kebekus/Software/buildsystems/openssl-1.1.1k
#export OPENSSL_INCLUDE_DIR=/home/kebekus/Software/buildsystems/openssl-1.1.1k/include			  

cmake .. \
      -G Ninja\
      -DCMAKE_BUILD_TYPE:STRING=Debug \
      -DCMAKE_PREFIX_PATH:STRING=$Qt6_DIR_ANDROID \
      -DOPENSSL_ROOT_DIR:PATH=$OPENSSL_ROOT_DIR \
      -DANDROID_NATIVE_API_LEVEL:STRING=23 \
      -DANDROID_NDK:PATH=/home/kebekus/Software/buildsystems/Android-SDK/ndk/21.3.6528147 \
      -DCMAKE_TOOLCHAIN_FILE:PATH=/home/kebekus/Software/buildsystems/Android-SDK/ndk/21.3.6528147/build/cmake/android.toolchain.cmake \
      -DANDROID_ABI:STRING=x86 \
      -DANDROID_STL:STRING=c++_shared \
      -DCMAKE_FIND_ROOT_PATH:PATH=$Qt6_DIR_ANDROID \
      -DQT_HOST_PATH:PATH=/home/kebekus/Software/buildsystems/Qt/6.2.0/gcc_64 \
      -DANDROID_SDK_ROOT:PATH=/home/kebekus/Software/buildsystems/Android-SDK

#/home/kebekus/Software/buildsystems/Qt/6.2.0/gcc_64/bin/androiddeployqt" --input /home/kebekus/experiment/build-untitled-Android_Qt_6_2_0_Clang_x86-Debug/android-untitled-deployment-settings.json --output /home/kebekus/experiment/build-untitled-Android_Qt_6_2_0_Clang_x86-Debug/android-build --android-platform android-30 --jdk /usr/lib/jvm/java-1.8.0 --gradle --aab --jarsigner