#!/bin/bash

#
# This script builds "Add Hours and minutes" for webasm in release mode.
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

rm -rf build-webasm-release
mkdir -p build-webasm-release
cd build-webasm-release

#
# Setup paths
#

. $EMSDK/emsdk_env.sh
export Qt6_DIR_BASE=/home/kebekus/Software/buildsystems/Qt/6.2.0
export Qt6_DIR_ANDROID=$Qt6_DIR_BASE/android_x86
export Qt6_DIR_LINUX=$Qt6_DIR_BASE/gcc_64
export Qt6_DIR_WASM=$Qt6_DIR_BASE/wasm_32
export OPENSSL_ROOT_DIR=/home/kebekus/Software/buildsystems/openssl-1.1.1k

#
# Configure
#

~/Software/buildsystems/Qt/Tools/CMake/bin/cmake .. \
    -DCMAKE_TOOLCHAIN_FILE:PYTH=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake \
    -DCMAKE_PREFIX_PATH:PATH=$Qt6_DIR_WASM \
    -DCMAKE_FIND_ROOT_PATH:PATH=$Qt6_DIR_WASM \
    -DQT_HOST_PATH:PATH=$Qt6_DIR_LINUX \
    -GNinja

#
# Build the executable
#

ninja
# GitHub pages does not support SVG, so we need to include a PNG here
rsvg-convert --width=200 --height=200 ../metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg -o src/qtlogo.png
sed -i 's/qtlogo.svg/qtlogo.png/g' src/addhoursandminutes.html
sed -i 's/320/200/g' src/addhoursandminutes.html
