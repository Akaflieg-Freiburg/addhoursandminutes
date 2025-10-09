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



#
# Set up additional files for Android
#

if (CMAKE_SYSTEM_NAME STREQUAL "Android")
    if (Qt6Core_VERSION VERSION_EQUAL "6.8.1")
        message(FATAL_ERROR "Qt version 6.8.1 is known to have critical errors with multi-architecture Android. Please use a different version.")
    endif()
    if (Qt6Core_VERSION VERSION_EQUAL "6.8.3")
        message(FATAL_ERROR "Qt version 6.8.3 is known to suffer from https://bugreports.qt.io/browse/QTBUG-136077. Please use a different version.")
    endif()
    if(NOT ANDROID_PLATFORM STREQUAL "android-28")
        message(FATAL_ERROR "ANDROID_PLATFORM must be set to android-28, is currently set to " ${ANDROID_PLATFORM})
    endif()

    # Icons
    file(COPY ${CMAKE_SOURCE_DIR}/generatedSources/src/android DESTINATION .)

    # Copy files into the Android directories
    file(COPY ${CMAKE_SOURCE_DIR}/src/android DESTINATION .)

    # Configure files
    configure_file(AndroidManifest.xml.in android/AndroidManifest.xml)
    configure_file(android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java android/src/de/akaflieg_freiburg/cavok/add_hours_and_minutes/AndroidAdaptor.java COPYONLY)

    set_target_properties(${PROJECT_NAME} PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/android"
        QT_ANDROID_TARGET_SDK_VERSION 35
        QT_ANDROID_MIN_SDK_VERSION 28
    )
    qt_import_plugins(${PROJECT_NAME}
        INCLUDE_BY_TYPE imageformats Qt::QSvgPlugin
        EXCLUDE_BY_TYPE platforminputcontexts qmltooling
    )
endif ()


#
# Set up additional files for macOS
#

if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "14.0")
    message("CMAKE_OSX_DEPLOYMENT_TARGET: ${CMAKE_OSX_DEPLOYMENT_TARGET}")

    set(app_icon_macos "${CMAKE_CURRENT_SOURCE_DIR}/macos/addhoursandminutes.icns")
    set_source_files_properties(${app_icon_macos} PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources")
    target_sources(${PROJECT_NAME} PRIVATE "${app_icon_macos}")

    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE true
        MACOSX_BUNDLE_BUNDLE_NAME "Add Times"
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/macos/Info.plist"
        MACOSX_BUNDLE_ICON_FILE addhoursandminutes.icns
    )
endif ()


#
# Set up additional files for iOS
#

if (CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set(bundle_resources
        "ios/Assets.xcassets"
    )
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE true
        MACOSX_BUNDLE_GUI_IDENTIFIER ${PRODUCT_BUNDLE_IDENTIFIER}
        XCODE_GENERATE_SCHEME ON
        XCODE_SCHEME_LAUNCH_CONFIGURATION "Release"
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/ios/Info.plist"
    )
    set_target_properties(${PROJECT_NAME} PROPERTIES QT_IOS_LAUNCH_SCREEN "${CMAKE_CURRENT_SOURCE_DIR}/ios/LaunchScreen.storyboard")

    set(asset_catalog_path "ios/Assets.xcassets")
    set(privacy_manifest "${CMAKE_CURRENT_SOURCE_DIR}/ios/PrivacyInfo.xcprivacy")

    target_sources(${PROJECT_NAME} PRIVATE "${asset_catalog_path}")
    target_sources(${PROJECT_NAME} PRIVATE ios/ObjCAdapter.mm)
    target_sources(${PROJECT_NAME} PRIVATE ios/ObjCAdapter.h)
    target_sources("${PROJECT_NAME}" PRIVATE "${privacy_manifest}")

    set_source_files_properties(${asset_catalog_path} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

    set_property(TARGET "${PROJECT_NAME}" APPEND PROPERTY RESOURCE "${privacy_manifest}")
endif()


#
# Installation for Linux, MacOS, Windows
# see https://www.qt.io/blog/deploying-to-linux-with-cmake
#

# Generate the deployment script for the target ${PROJECT_NAME}.
qt_generate_deploy_qml_app_script(
    TARGET ${PROJECT_NAME}
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
    MACOS_BUNDLE_POST_BUILD
    DEPLOY_TOOL_OPTIONS
    "-sign-for-notarization=Stefan Kebekus"
)

if ((CMAKE_SYSTEM_NAME STREQUAL "Darwin") OR ((CMAKE_SYSTEM_NAME STREQUAL "Linux") OR (CMAKE_SYSTEM_NAME STREQUAL "Windows")))
    # Install the executable into "${CMAKE_INSTALL_PREFIX}/bin".
    install(
        TARGETS ${PROJECT_NAME}
        BUNDLE DESTINATION .
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )

    # Call the deployment script on "cmake --install".
    if (QTDEPLOY)
        install(SCRIPT ${deploy_script})
    endif ()
endif ()
