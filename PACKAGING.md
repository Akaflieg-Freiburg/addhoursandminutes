# Packaging


## Linux

The CMakeFiles include a special target, "packaging", that helps to produce
packages for various software distribution systems under linux.


### flatpak

A flatpak manifest is created in packaging/flatpak.  This requires that the
source tree is a GIT repository, and that the command "git" is available.


### RPM

An RPM spec file and a source tarball are generated in packaging/RPM, suitable
for generation of (S)RPM packages and suitable for upload to the Open Build
Service.  This requires that the command "curl" is available and that the
computer is able to download files from the internet.


### Debian

A debian source package is generated in packaging/debian, suitable for
generation debian packages and suitable for upload to the Open Build
Service. This requires that the commands "curl" and "dpkg-source" are available
and that the computer is able to download files from the internet.


## Android

The CMakeFiles include a special target, "packaging", that produces an Android
APK file in the directory "packaging/android". The program "inkscape" is
required to generate the necessary icons.
