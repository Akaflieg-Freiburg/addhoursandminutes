add_custom_target(packaging)

if (UNIX AND NOT ANDROID)
  #
  # Prepare flatpack manifest
  #
  
  if (DEFINED TAG_COMMIT)
    configure_file(flatpak/${APP_ID}.json flatpak/${APP_ID}.json)
  else()
    message("Not building inside a GIT directory, or git command not available. Flatpak manifest will not be generated.")
  endif()
  
  
  #
  # Prepare RPM files
  #
  
  configure_file(RPM/${PROJECT_NAME}.spec RPM/${PROJECT_NAME}.spec)
  add_custom_target(packaging-rpm
    COMMAND curl -s -o ${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz https://gitlab.com/kebekus/${PROJECT_NAME}/-/archive/${PROJECT_VERSION}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
    WORKING_DIRECTORY RPM
    COMMENT "Downloading tarball for RPM package"
    )
  
  
  #
  # Prepare Debian package
  #
  
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/debian)
  configure_file(debian/changelog debian-working/changelog)
  configure_file(debian/compat debian-working/compat)
  configure_file(debian/control debian-working/control COPYONLY)
  configure_file(debian/copyright debian-working/copyright COPYONLY)
  configure_file(debian/rules debian-working/rules)
  configure_file(debian/source/format debian-working/source/format)
  
  add_custom_target(packaging-debian
    COMMAND curl -s -o ${PROJECT_NAME}_${PROJECT_VERSION}.orig.tar.gz https://gitlab.com/kebekus/${PROJECT_NAME}/-/archive/${PROJECT_VERSION}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
    COMMAND tar xf ${PROJECT_NAME}_${PROJECT_VERSION}.orig.tar.gz
    COMMAND rm -rf ${PROJECT_NAME}-${PROJECT_VERSION}/debian
    COMMAND mkdir ${PROJECT_NAME}-${PROJECT_VERSION}/debian
    COMMAND cp -prd ../debian-working/* ${PROJECT_NAME}-${PROJECT_VERSION}/debian
    COMMAND dpkg-source -b ${PROJECT_NAME}-${PROJECT_VERSION}
    COMMAND rm -rf ${PROJECT_NAME}-${PROJECT_VERSION}
    COMMENT "Downloading tarball and building Debian source package"
    WORKING_DIRECTORY debian
    )
  
  
  #
  # Add target that include  both RPM and Debian packages
  #
  add_dependencies(packaging packaging-debian packaging-rpm)
endif (UNIX AND NOT ANDROID)

if (ANDROID)

  #
  # Prepare Android APK
  #
  add_qt_android_apk(${PROJECT_NAME}_apk ${PROJECT_NAME})

    
  #
  # Add target that includes Android packages
  #

  add_dependencies(packaging ${PROJECT_NAME}_apk)
  
endif (ANDROID)
  
