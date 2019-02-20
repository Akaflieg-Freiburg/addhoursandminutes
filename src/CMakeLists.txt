#
# Provide translations
#

qt5_add_translation(qm_files
  addHoursAndMinutes_de.ts
  )
add_custom_target(translations DEPENDS ${qm_files})
configure_file(addHoursAndMinutes_translations.qrc addHoursAndMinutes_translations.qrc COPYONLY)
configure_file(text/info.html.in text/info.html)
configure_file(text/info_de.html.in text/info_de.html)
configure_file(text/firstStart.html.in text/firstStart.html)
configure_file(text/firstStart_de.html.in text/firstStart_de.html)


#
# Set up source files
#

set(SOURCES
  addHoursAndMinutes.qrc
  androidAdaptor.cpp
  firstRunNotifier.cpp
  main.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/addHoursAndMinutes_translations.qrc
  )

if(ANDROID)

  #
  # Compile C++ files for Android
  #
  
  add_library(${PROJECT_NAME} SHARED ${SOURCES})
  target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::AndroidExtras Qt5::Core Qt5::Quick)
  
  #
  # Prepare Android APK
  #

  # Configure files
  
  math(EXPR PROJECT_VERSION_CODE 10000*${PROJECT_VERSION_MAJOR}+100*${PROJECT_VERSION_MINOR}+${PROJECT_VERSION_PATCH})
  configure_file(android-sources/AndroidManifest.xml android-sources/AndroidManifest.xml)
  configure_file(android-sources/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java android-sources/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java COPYONLY)
  configure_file(android-sources/res/drawable/splash.xml android-sources/res/drawable/splash.xml COPYONLY)
    configure_file(android-sources/res/values/apptheme.xml android-sources/res/values/apptheme.xml COPYONLY)
  
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
  
  add_custom_target(${PROJECT_NAME}_copyAPK ALL
    COMMAND ${CMAKE_COMMAND} -E copy android-working/build/outputs/apk/release/android-working-release-unsigned.apk ${APP_ID}-unsigned.apk
    )
  add_dependencies(${PROJECT_NAME}_copyAPK ${PROJECT_NAME}_apk)
  
else(ANDROID)
  
  #
  # For non-Android platforms, simply generate executable
  #
  
  add_executable(${PROJECT_NAME} WIN32 ${SOURCES})
  add_dependencies(${PROJECT_NAME} translations)
  target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick)
  
  #
  # Install things
  #
  
  install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
  
endif(ANDROID)
