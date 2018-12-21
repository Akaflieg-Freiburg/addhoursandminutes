if (ANDROID)

  #
  # Prepare Android APK
  #

  configure_file(AndroidManifest.xml android-sources/AndroidManifest.xml)

  # Generate icons
  add_custom_target(icons
    COMMAND inkscape -z -f ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -e icon.png -h 512 -w 512
    COMMAND ${CMAKE_COMMAND} -E make_directory android-sources/res/drawable-xxxhdpi
    COMMAND inkscape -z -f ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -e android-sources/res/drawable-xxxhdpi/icon.png -h 192 -w 192
    COMMAND ${CMAKE_COMMAND} -E make_directory android-sources/res/drawable-xxhdpi
    COMMAND inkscape -z -f ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -e android-sources/res/drawable-xxhdpi/icon.png -h 144 -w 144
    COMMAND ${CMAKE_COMMAND} -E make_directory android-sources/res/drawable-xhdpi
    COMMAND inkscape -z -f ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -e android-sources/res/drawable-xhdpi/icon.png -h 96 -w 96
    COMMAND ${CMAKE_COMMAND} -E make_directory android-sources/res/drawable-hdpi
    COMMAND inkscape -z -f ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -e android-sources/res/drawable-hdpi/icon.png -h 72 -w 72
    COMMAND ${CMAKE_COMMAND} -E make_directory android-sources/res/drawable-mdpi
    COMMAND inkscape -z -f ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -e android-sources/res/drawable-mdpi/icon.png -h 48 -w 48
    COMMENT "Generate icons"
    )
  
  # Generate Android package
  add_qt_android_apk(${PROJECT_NAME}_apk ${PROJECT_NAME}
    PACKAGE_SOURCES android-sources
    PROJECT_VERSION_CODE ${VERSION_CODE}
    PACKAGE_NAME ${APP_ID}
    )
  add_dependencies(${PROJECT_NAME}_apk icons)
  
  # Copy the package to the android directory
  add_custom_target(android
    COMMAND ${CMAKE_COMMAND} -E copy android-working/build/outputs/apk/release/android-working-release-unsigned.apk ${APP_ID}-unsigned.apk
    )
  add_dependencies(android ${PROJECT_NAME}_apk)
  
  
  #
  # Add target that includes Android packages
  #
  
  add_dependencies(packaging android)
  
endif (ANDROID)
