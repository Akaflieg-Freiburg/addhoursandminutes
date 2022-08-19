#
# Set up source files
#

set(SOURCES
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
  configure_file(android/res/drawable/splash.xml android/res/drawable/splash.xml COPYONLY)
  configure_file(android/res/values/apptheme.xml android/res/values/apptheme.xml COPYONLY)
  configure_file(android/res/values/strings.xml android/res/values/strings.xml COPYONLY)
  configure_file(android/res/values-de/strings.xml android/res/values-de/strings.xml COPYONLY)
  configure_file(android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java COPYONLY) 

endif()


qt_add_executable(${PROJECT_NAME} MANUAL_FINALIZATION ${SOURCES} ${ANDROID_EXTRA_SOURCES})
target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Core Qt6::Quick Qt6::Svg)
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
set_target_properties(${PROJECT_NAME} PROPERTIES QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/android")

qt_add_qml_module(${PROJECT_NAME}
    URI gui
    VERSION 1.0
    QML_FILES
    qml/main.qml
    qml/LongTextDialog.qml
    qml/Calculator.qml
    SOURCES
    androidAdaptor.cpp
    androidAdaptor.h
    )
qt_import_qml_plugins(${PROJECT_NAME})

qt_add_resources(${PROJECT_NAME} config
    PREFIX "/"
    FILES
    qtquickcontrols2.conf
)

qt_add_resources(${PROJECT_NAME} "imageresources"
    PREFIX "/"
    FILES
    images/shadow_horizontal.png
    images/shadow_top.png
    images/shadow_vertical.png
    images/ic_menu_24px.svg
    images/ic_exit_to_app_24px.svg
    images/ic_help_24px.svg
    images/ic_info_24px.svg
    images/ic_menu_black_24dp.png
    images/ic_exit_to_app_black_24dp.png
    images/ic_help_black_24dp.png
    images/ic_info_black_24dp.png
)

qt_add_resources(${PROJECT_NAME} "programicons"
    PREFIX "/"
    FILES
    ../metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg
    ../generatedSources/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.png

)

qt_add_translations(${PROJECT_NAME}
    TS_FILES
    addhoursandminutes_de.ts
)

qt_finalize_executable(${PROJECT_NAME})


#
# Install things
#

install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
