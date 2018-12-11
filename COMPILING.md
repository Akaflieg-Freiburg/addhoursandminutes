# Compiling

## Dependencies

* Qt5 development packages (including QtSVG and the lupdate tool)

* CMake build system

* C++ compiler


## Compilation

### Linux

This app standard cmake system, so compilation is straightforward. Once the
compilation terminates, you'll find a binary in the build directory.


### Android

The app can be cross-compiled on linux, using the Android NDK and an appropriate
pre-compiled version of Qt. On the author's computer, the following command
lines will do the trick.

mkdir build-android
cd build-android
cmake \
-DCMAKE_FIND_ROOT_PATH=/home/kebekus/Software/buildsystems/Qt/5.11.2/android_armv7 \
-DCMAKE_TOOLCHAIN_FILE=/home/kebekus/Software/buildsystems/android/android-ndk-r18b/build/cmake/android.toolchain.cmake \
..
make


## Installation

On Linux, simply issue the command 'make install'
