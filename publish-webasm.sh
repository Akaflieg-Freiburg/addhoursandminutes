#!/bin/bash

# Build for webassembly
./buildscript-webasm.sh


#
# Distribute the webassembly executable
#

echo "Installing webassembly files…"
cd build-webasm-release/src
cp qtloader.js qtlogo.png addhoursandminutes.html addhoursandminutes.js addhoursandminutes.wasm ../../docs/assets/webasm/
cd ../..
git commit -am "New webassembly"
