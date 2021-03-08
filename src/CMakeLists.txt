#
# Provide translations.  For better cooperation with qmake, we save the
# translation files in the SOURCE directory.  If we ever move to a pure cmake
# build in the future, this should be fixed.
#

set_source_files_properties(addhoursandminutes_de.ts PROPERTIES OUTPUT_LOCATION ${CMAKE_CURRENT_SOURCE_DIR})
qt5_add_translation(qm_files addhoursandminutes_de.ts)
add_custom_target(translations DEPENDS ${qm_files})


#
# Configure QMake file -- required for the webassembly platform
#

configure_file(addhoursandminutes.pro.in addhoursandminutes.pro)


#
# Set up source files
#

set(SOURCES
  addhoursandminutes.qrc
  androidAdaptor.cpp
  main.cpp
  )

if(ANDROID)

  # Generate android extra sources. This includes icons, but also a few other files
  set(ANDROID_EXTRA_SOURCES
    ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-xxxhdpi/icon.png
    ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-xxhdpi/icon.png
    ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-xhdpi/icon.png
    ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-hdpi/icon.png
    ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-mdpi/icon.png
    ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable/splash.xml
    ${CMAKE_CURRENT_BINARY_DIR}/android/res/values/apptheme.xml
    )
  add_custom_command(
    OUTPUT ${ANDROID_EXTRA_SOURCES}
    DEPENDS ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg
    COMMAND ${CMAKE_COMMAND} -E make_directory android/res/drawable-xxxhdpi
    COMMAND rsvg-convert ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -o ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-xxxhdpi/icon.png -h 384 -w 384
    COMMAND ${CMAKE_COMMAND} -E make_directory android/res/drawable-xxhdpi
    COMMAND rsvg-convert ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -o ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-xxhdpi/icon.png -h 288 -w 288
    COMMAND ${CMAKE_COMMAND} -E make_directory android/res/drawable-xhdpi
    COMMAND rsvg-convert ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -o ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-xhdpi/icon.png -h 192 -w 192
    COMMAND ${CMAKE_COMMAND} -E make_directory android/res/drawable-hdpi
    COMMAND rsvg-convert ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -o ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-hdpi/icon.png -h 144 -w 144
    COMMAND ${CMAKE_COMMAND} -E make_directory android/res/drawable-mdpi
    COMMAND rsvg-convert ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -o ${CMAKE_CURRENT_BINARY_DIR}/android/res/drawable-mdpi/icon.png -h 96 -w 96
    COMMENT "Generate android icons"
    )
  
  # The android target require a few additional variables
  set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/android" CACHE INTERNAL "")
  
  # Configure files
  configure_file(AndroidManifest.xml.in android/AndroidManifest.xml)
  configure_file(android/build.gradle android/build.gradle COPYONLY)
  configure_file(android/gradle/wrapper/gradle-wrapper.properties android/gradle/wrapper/gradle-wrapper.properties COPYONLY)
  configure_file(android/gradle/wrapper/gradle-wrapper.jar android/gradle/wrapper/gradle-wrapper.jar COPYONLY)
  configure_file(android/gradlew android/gradlew COPYONLY)
  configure_file(android/gradlew.bat android/gradlew.bat COPYONLY)
  configure_file(android/res/drawable/splash.xml android/res/drawable/splash.xml COPYONLY)
  configure_file(android/res/values/apptheme.xml android/res/values/apptheme.xml COPYONLY)
  configure_file(android/res/values/strings.xml android/res/values/strings.xml COPYONLY)
  configure_file(android/res/values-de/strings.xml android/res/values-de/strings.xml COPYONLY)
  configure_file(android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java COPYONLY)

  # The android target is a library, not an executable
  add_library(${PROJECT_NAME} SHARED ${SOURCES} ${ANDROID_EXTRA_SOURCES})
  
  # Add libraries
  target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::AndroidExtras Qt5::Core Qt5::Quick Qt5::Svg)
endif()


#
# Generate unix executable
#
if (NOT ANDROID)

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
  
endif()
