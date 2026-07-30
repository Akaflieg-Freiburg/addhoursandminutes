#!/bin/bash

#
# This script builds "Add Times" for the Linux desktop in
# "Debug" mode.  Several sanitizers are switched on.
#
# See https://github.com/Akaflieg-Freiburg/enroute/wiki/Build-scripts
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
# Run this script in the main directory tree.

#
# Fail on first error
#

set -e

#
# Clean
#

rm -rf build-linux-debug

#
# Build the executable
#

mkdir build-linux-debug
cd build-linux-debug

# Use clang if available, the system default compiler otherwise
if command -v clang > /dev/null; then
    export CC=clang
    export CXX=clang++
fi

# Enable sanitizers if the compiler can link against the sanitizer runtime
# (requires libasan/libubsan to be installed)
SANITIZE_FLAGS="-fsanitize=address,undefined"
if ! echo 'int main(){}' | ${CXX:-c++} $SANITIZE_FLAGS -x c++ - -o /dev/null 2> /dev/null; then
    echo "WARNING: sanitizer runtime not available, building without sanitizers"
    SANITIZE_FLAGS=""
fi

$Qt6_DIR_LINUX/bin/qt-cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS="$SANITIZE_FLAGS" \
    ..

ninja
cd ..
