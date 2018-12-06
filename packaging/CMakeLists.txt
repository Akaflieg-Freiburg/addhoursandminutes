if (UNIX)
  #
  # Prepare flatpack manifest
  #
  
  if (DEFINED TAG_COMMIT)
    configure_file(flatpak/de.akaflieg_freiburg.cavok.add_hours_and_minutes.json flatpak/de.akaflieg_freiburg.cavok.add_hours_and_minutes.json)
  else()
    message("Not building inside a GIT directory, or git command not available. Flatpak manifest will not be generated.")
  endif()
  
  
  #
  # Prepare RPM files
  #
  
#  configure_file(RPM/ellipticcurve.spec RPM/ellipticcurve.spec)
#  add_custom_target(packaging-rpm
#    COMMAND curl -s -o ellipticcurve-${PROJECT_VERSION}.tar.gz https://gitlab.com/kebekus/ellipticcurve/-/archive/${PROJECT_VERSION}/ellipticcurve-${PROJECT_VERSION}.tar.gz
#    WORKING_DIRECTORY RPM
#    COMMENT "Downloading tarball and for RPM package"
#    )
  
  
  #
  # Prepare Debian package
  #
  
#  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/debian)
#  configure_file(debian/changelog debian-working/changelog)
#  configure_file(debian/compat debian-working/compat)
#  configure_file(debian/control debian-working/control COPYONLY)
#  configure_file(debian/copyright debian-working/copyright COPYONLY)
#  configure_file(debian/rules debian-working/rules)
#  configure_file(debian/source/format debian-working/source/format)
  
#  add_custom_target(packaging-debian
#    COMMAND curl -s -o ellipticcurve_${PROJECT_VERSION}.orig.tar.gz https://gitlab.com/kebekus/ellipticcurve/-/archive/${PROJECT_VERSION}/ellipticcurve-${PROJECT_VERSION}.tar.gz
#    COMMAND tar xf ellipticcurve_${PROJECT_VERSION}.orig.tar.gz
#    COMMAND mkdir ellipticcurve-${PROJECT_VERSION}/debian
#    COMMAND cp -prd ../debian-working/* ellipticcurve-${PROJECT_VERSION}/debian
#    COMMAND dpkg-source -b ellipticcurve-${PROJECT_VERSION}
#    COMMAND rm -rf ellipticcurve-${PROJECT_VERSION}
#    COMMENT "Downloading tarball and building Debian source package"
#    WORKING_DIRECTORY debian
#    )
  
#  add_custom_target(packaging-windows
#    COMMAND /usr/i686-w64-mingw32/bin/qt5/windeployqt ../src/ellipticcurve.exe
#    #  WORKING_DIRECTORY debian
#    )

  
  #
  # Add target that include  both RPM and Debian packages
  #
  
#  add_custom_target(packaging
#    DEPENDS packaging-debian
#    DEPENDS packaging-rpm
#    )
  
endif (UNIX)
