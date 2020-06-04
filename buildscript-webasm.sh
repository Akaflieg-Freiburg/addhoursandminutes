#!/bin/bash

#
# This script builds "Add Hours and minutes" for webasm in release mode.
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

rm -rf build-webasm-release
mkdir -p build-webasm-release
cd build-webasm-release

#
# Configure
#

. $EMSDK/emsdk_env.sh
$Qt5_DIR_WASM/bin/qmake ../src/addhoursandminutes.pro


#
# Build the executable
#

$Qt5_DIR_WASM/bin/lrelease ../src/addhoursandminutes.pro
make -j
# GitHub pages does not support SVG, so we need to include a PNG here
rsvg-convert --width=200 --height=200 ../metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg -o qtlogo.png
sed -i 's/qtlogo.svg/qtlogo.png/g' addhoursandminutes.html
sed -i 's/320/200/g' addhoursandminutes.html

#
# Distribute the executable
#

echo "Copy webasm executable to 'docs' directory (y/n)?"
read -rsn1 input
if [ "$input" = "y" ]; then
    echo "Brotli compression"
    brotli addhoursandminutes.wasm
    echo "Copying file…"
    cp qtloader.js qtlogo.png addhoursandminutes.html addhoursandminutes.js addhoursandminutes.wasm.br ../docs/assets/webasm/
fi
