#!/bin/bash

#
# Fail on first error
#

set -e

# Build for webassembly
./buildscript-webasm.sh


#
# Distribute the webassembly executable
#

echo "Installing webassembly files…"
cd build-webasm-release/src
cp qtloader.js qtlogo.png addhoursandminutes.html addhoursandminutes.js addhoursandminutes.wasm ../../docs/assets/webasm/
cd ../..

# Commit only the webassembly files; other changes in the working tree must
# not be swept into this commit.
git add docs/assets/webasm
git commit -m "New webassembly" -- docs/assets/webasm
