# Compiling

## Dependencies

* Qt5 development packages

* CMake build system

* C++ compiler


## Compilation

The compilation process is currently a mess.  The problem is that cmake, while
working exetremely well for desktop applications, cannot easily and reliably
produce Android packages (as of March 2019).  Until Qt offers better cmake
support, this project uses cmake for desktop, and an ugly mix of cmake and qmake
for compilation under Android.


### Linux/Windows

This app standard cmake system, so compilation is straightforward.  Once the
compilation terminates, you'll find a binary in the build directory.  Because of
the cmake/qmake mix described above, cmake will store some icons and configured
files IN THE SOURCE directory, even when doing out-of-source builds.


### Android

The app can be cross-compiled on linux, using the Android SDK, the Android NDK
and an appropriate pre-compiled version of Qt.  Please have a look at the script
'buildscript-android.sh' to learn how to compile an Android App that can be
uploaded to the Google Play service.  The CMakeFiles require the program
"inkscape" to generate the necessary icons.  The CMakeLists used to generate
Android package have been tested under Linux, but not under Windows.


## Installation

On Linux, simply issue the command 'make install'
