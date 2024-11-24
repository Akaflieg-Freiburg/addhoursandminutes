#
# Set up source files
#

qt_add_executable(${PROJECT_NAME}
    main.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Svg)

qt_add_qml_module(${PROJECT_NAME}
    URI gui
    VERSION 1.0
    QML_FILES
    qml/Calculator.qml
    qml/CalculatorButton.qml
    qml/CenteringDialog.qml
    qml/DecoratedScrollView.qml
    qml/Keypad.qml
    qml/LongTextDialog.qml
    qml/main.qml
    SOURCES
    platformAdapter.cpp
    platformAdapter.h
)

qt_add_resources(${PROJECT_NAME} "imageresources"
    PREFIX "/"
    FILES
    images/ic_menu_24px.svg
    images/ic_help_24px.svg
    images/ic_info_24px.svg
)

set_source_files_properties(${CMAKE_SOURCE_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg PROPERTIES QT_RESOURCE_ALIAS icon.svg)
set_source_files_properties(${CMAKE_SOURCE_DIR}/generatedSources/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.png PROPERTIES QT_RESOURCE_ALIAS icon.png)
qt_add_resources(${PROJECT_NAME} "programicons"
    PREFIX "/"
    FILES
    ${CMAKE_SOURCE_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg
    ${CMAKE_SOURCE_DIR}/generatedSources/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.png

)


if(${QT_VERSION} VERSION_GREATER_EQUAL "6.7.0")
    qt_add_lrelease(
        TS_FILES
        addhoursandminutes_de.ts
        addhoursandminutes_es.ts
        addhoursandminutes_fr.ts
        addhoursandminutes_it.ts
        addhoursandminutes_pl.ts
        QM_FILES_OUTPUT_VARIABLE qmFiles
    )
    qt_add_resources(
        ${PROJECT_NAME}
        translations_addhoursandminutes
        BASE
        ${CMAKE_CURRENT_BINARY_DIR}
        PREFIX
        i18n
        FILES
        ${qmFiles}
    )
else()
    qt_add_translations(${PROJECT_NAME}
        TS_FILES
        addhoursandminutes_de.ts
        addhoursandminutes_es.ts
        addhoursandminutes_fr.ts
        addhoursandminutes_it.ts
        addhoursandminutes_pl.ts
    )
endif()


#
# Set up additional files for Android
#

if (CMAKE_SYSTEM_NAME STREQUAL "Android")

    # Icons
    file(COPY ${CMAKE_SOURCE_DIR}/generatedSources/src/android DESTINATION .)

    # Copy files into the Android directories
    file(COPY ${CMAKE_SOURCE_DIR}/src/android DESTINATION .)

    # Configure files
    configure_file(AndroidManifest.xml.in android/AndroidManifest.xml)
    configure_file(android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java COPYONLY)

    set_target_properties(${PROJECT_NAME} PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/android"
        QT_ANDROID_TARGET_SDK_VERSION 34
        QT_ANDROID_MIN_SDK_VERSION 26
    )

endif ()


#
# Set up additional files for macOS
#

if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE true
        MACOSX_BUNDLE_BUNDLE_NAME "Add Times"
    )
endif ()


#
# Set up additional files for iOS
#

if (CMAKE_SYSTEM_NAME STREQUAL "iOS")
    #Info.plist
    set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE TRUE)
    set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/ios/Info.plist")

    #Assets catalog containing the App icon
    set(asset_catalog_path "ios/Assets.xcassets")
    target_sources(${PROJECT_NAME}  PRIVATE "${asset_catalog_path}")
    set_source_files_properties(${asset_catalog_path} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

    #Launchscreen
    set_target_properties(${PROJECT_NAME} PROPERTIES QT_IOS_LAUNCH_SCREEN "${CMAKE_CURRENT_SOURCE_DIR}/ios/LaunchScreen.storyboard")

    #Platform specific functions
    target_sources(${PROJECT_NAME} PRIVATE ios/ObjCAdapter.mm)
    target_sources(${PROJECT_NAME} PRIVATE ios/ObjCAdapter.h)


    set(privacy_manifest "${CMAKE_CURRENT_SOURCE_DIR}/ios/PrivacyInfo.xcprivacy")
    target_sources("${PROJECT_NAME}" PRIVATE "${privacy_manifest}")
    set_property(TARGET "${PROJECT_NAME}" APPEND PROPERTY RESOURCE "${privacy_manifest}")


    #target_sources(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/iosX/PrivacyInfo.xcprivacy")
    #set_target_properties(${PROJECT_NAME} PROPERTIES
    #    _qt_privacy_manifest "${CMAKE_CURRENT_SOURCE_DIR}/iosX/PrivacyInfo.xcprivacy")

endif()


#
# Installation for Linux, MacOS, Windows
# see https://www.qt.io/blog/deploying-to-linux-with-cmake
#

if ((CMAKE_SYSTEM_NAME STREQUAL "Darwin") OR ((CMAKE_SYSTEM_NAME STREQUAL "Linux") OR (CMAKE_SYSTEM_NAME STREQUAL "Windows")))
    # Install the executable into "${CMAKE_INSTALL_PREFIX}/bin".
    install(
        TARGETS ${PROJECT_NAME}
        BUNDLE  DESTINATION .
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )

    # Generate the deployment script for the target ${PROJECT_NAME}.
    qt_generate_deploy_qml_app_script(
        TARGET ${PROJECT_NAME}
        OUTPUT_SCRIPT deploy_script
        NO_UNSUPPORTED_PLATFORM_ERROR
    )

    # Call the deployment script on "cmake --install".
    install(SCRIPT ${deploy_script})
endif ()
