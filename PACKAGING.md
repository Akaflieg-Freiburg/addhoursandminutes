# Packaging


## Linux

The CMakeFiles include a special target, "packaging", that helps to produce
packages for various software distribution systems under Linux.


### flatpak

A flatpak manifest is created in packaging/flatpak.  This requires that the
source tree is a GIT repository, and that the command "git" is available.  It is
also required that a tag in the GIT repository exists that corresponds to the
CMake variable ${PROJECT_VERSION}. The flatpak manifest will refer to this tag
for a download source.


### tar

A tar file is created in packaging/tar.  This requires that the source tree is a
GIT repository, and that the command "git" is available.


### RPM

An RPM spec file and a source tarball are generated in packaging/RPM, suitable
for generation of (S)RPM packages and suitable for upload to the Open Build
Service.  This requires that the source tree is a GIT repository, and that the
command "git" is available, as the command ```git archive HEAD``` is used to
generate the tar file.


### Debian

A debian source package is generated in packaging/debian, suitable for
generation debian packages and suitable for upload to the Open Build
Service. This requires that the source tree is a GIT repository, and that the
command "git" is available, as the command ```git archive HEAD``` is used to
generate the tar file.  It also requires that the command "dpkg-source" is
available.


## Windows

The CMakeFiles include a special target, "packaging", that produces an offline 
installer file using the Qt Installer framework. To this end, the program 
"binarycreator" is used. A hint for the location of the program is hardcoded
into packging/installer/CMakeLists.txt

