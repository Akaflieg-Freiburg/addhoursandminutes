#!/bin/bash

#
# This script builds "Add Hours and Minutes" for Android in release mode.
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

rm -f *.apk *.aab

array=( x86 x86_64 arm64_v8a armv7 )
for arch in "${array[@]}"
do

    #
    # Clean up
    #
    
    rm -rf build-android-debug
    mkdir -p build-android-debug
    cd build-android-debug
    
    #
    # Configure
    #
    echo $Qt6_DIR_ANDROID\_${arch}
    cmake .. \
	  -G Ninja\
	  -DCMAKE_BUILD_TYPE:STRING=Debug \
	  -DCMAKE_PREFIX_PATH:STRING=$Qt6_DIR_ANDROID\_${arch} \
	  -DOPENSSL_ROOT_DIR:PATH=$OPENSSL_ROOT_DIR \
	  -DANDROID_NATIVE_API_LEVEL:STRING=23 \
	  -DANDROID_NDK:PATH=$ANDROID_NDK_ROOT \
	  -DCMAKE_TOOLCHAIN_FILE:PATH=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
	  -DANDROID_ABI:STRING=${arch} \
	  -DANDROID_STL:STRING=c++_shared \
	  -DCMAKE_FIND_ROOT_PATH:PATH=$Qt6_DIR_ANDROID\_${arch} \
	  -DQT_HOST_PATH:PATH=$Qt6_DIR_LINUX \
	  -DANDROID_SDK_ROOT:PATH=$ANDROID_SDK_ROOT
    
    #
    # Compile
    #
    
    ninja addhoursandminutes
    ninja addhoursandminutes_prepare_apk_dir
    
    $Qt6_DIR_LINUX/bin/androiddeployqt \
	--aab \
	--input src/android-addhoursandminutes-deployment-settings.json \
	--output src/android-build \
	--apk ../addhoursandminutes-${arch}.apk \
	--depfile src/android-build/addhoursandminutes.d \
	--builddir .
    
    mv ./src/android-build/build/outputs/bundle/release/android-build-release.aab ../addhoursandminutes-${arch}.aab

    #
    # cd out
    #
    cd ..
done


