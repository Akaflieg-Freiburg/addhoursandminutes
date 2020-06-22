#!/bin/bash

#
# Pull in the latest versions of everything
#

git submodule init
git submodule update
git pull
cd 3rdParty/de.akaflieg_freiburg.cavok.add_hours_and_minutes
git pull
cd ../..

#
# Build the executable in all formats. Only proceed it all platforms can be
# built.
#

# Build for Android
./buildscript-android-release.sh

# Build for Linux (including flatpak)
./buildscript-linux-debug.sh
cd build-linux-debug
ninja flatpak-binary
cd ..

# Build for webassembly
./buildscript-webasm.sh


#
# Distribute the webassembly executable
#

echo "Installing webassembly files…"
cd build-webasm-release
cp qtloader.js qtlogo.png addhoursandminutes.html addhoursandminutes.js addhoursandminutes.wasm ../docs/assets/webasm/
cd ..
git commit -am "New webassembly"


#
# Distribute the flatpak
#

echo "Installing flathub files…"
cd build-linux-debug
git clone git@github.com:flathub/de.akaflieg_freiburg.cavok.add_hours_and_minutes.git
cd de.akaflieg_freiburg.cavok.add_hours_and_minutes
git rm addhoursandminutes-*.tar.gz
cp ../packaging/flatpak/de.akaflieg_freiburg.cavok.add_hours_and_minutes.json .
cp ../packaging/flatpak/addhoursandminutes-*.tar.gz .
git add addhoursandminutes-*.tar.gz
git commit -am "New upstream release"
git push
cd ..
rm -rf  de.akaflieg_freiburg.cavok.add_hours_and_minutes
cd ..
