#
# Set up source files
#

qt_add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Quick Qt6::Svg)

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

set_source_files_properties(${CMAKE_SOURCE_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg PROPERTIES QT_RESOURCE_ALIAS icon.svg)
set_source_files_properties(${CMAKE_SOURCE_DIR}/generatedSources/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.png PROPERTIES QT_RESOURCE_ALIAS icon.png)
qt_add_resources(${PROJECT_NAME} "programicons"
    PREFIX "/"
    FILES
    ${CMAKE_SOURCE_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg
    ${CMAKE_SOURCE_DIR}/generatedSources/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.png

)

qt_add_translations(${PROJECT_NAME}
    TS_FILES
    addhoursandminutes_de.ts
)


#
# Set up additional files for Android
#

if(ANDROID)

    add_custom_target(
        androidIcons
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
    add_dependencies(${PROJECT_NAME} androidIcons)

    # Configure files
    configure_file(AndroidManifest.xml.in android/AndroidManifest.xml)
    configure_file(android/res/drawable/splash.xml android/res/drawable/splash.xml COPYONLY)
    configure_file(android/res/values/apptheme.xml android/res/values/apptheme.xml COPYONLY)
    configure_file(android/res/values/strings.xml android/res/values/strings.xml COPYONLY)
    configure_file(android/res/values-de/strings.xml android/res/values-de/strings.xml COPYONLY)
    configure_file(android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java COPYONLY)

    set_target_properties(${PROJECT_NAME} PROPERTIES QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/android")

endif()


#
# Install things
#

install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
