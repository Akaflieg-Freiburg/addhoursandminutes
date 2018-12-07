# Compiling

## Dependencies

* Qt5 development packages (including QtSVG and the lupdate tool)

* CMake build system

* C++ compiler

## Compilation

### Linux

The Elliptic Curve Plotter uses the standard qmake cmake system, so compilation
is straightforward. Once the compilation terminates, you'll find a binary in the
build directory.

### Windows

The cmake files provided can be used to cross-compile a static binary for
windows, using the MXE (M cross environment, https://mxe.cc) cross compiler
unter Linux.


## Installation

On Linux, simply issue the command 'make install'
