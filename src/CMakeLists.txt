#
# Set up source files
#

qt_add_executable(${PROJECT_NAME}
    main.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Svg)

set_source_files_properties(qml/Style.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

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
    qml/Style.qml
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

# Qt Quick Controls looks for this file at :/qtquickcontrols2.conf
qt_add_resources(${PROJECT_NAME} "controlsconf"
    PREFIX "/"
    FILES
    qtquickcontrols2.conf
)

set_source_files_properties(${CMAKE_SOURCE_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg PROPERTIES QT_RESOURCE_ALIAS icon.svg)
set_source_files_properties(${CMAKE_SOURCE_DIR}/generatedSources/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.png PROPERTIES QT_RESOURCE_ALIAS icon.png)
qt_add_resources(${PROJECT_NAME} "programicons"
    PREFIX "/"
    FILES
    ${CMAKE_SOURCE_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg
    ${CMAKE_SOURCE_DIR}/generatedSources/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.png
)


# The .ts files are found automatically from I18N_TRANSLATED_LANGUAGES,
# set via qt_standard_project_setup() in the top-level CMakeLists.txt.
qt_add_translations(${PROJECT_NAME}
    RESOURCE_PREFIX i18n
    NO_GENERATE_PLURALS_TS_FILE
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

    # Copy files into the Android directories. Using configure_file (rather
    # than file(COPY)) makes CMake re-run and refresh the copies whenever one
    # of the source files changes.
    file(GLOB_RECURSE androidFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} CONFIGURE_DEPENDS android/*)
    foreach(androidFile ${androidFiles})
        configure_file(${androidFile} ${androidFile} COPYONLY)
    endforeach()

    # Configure files
    configure_file(AndroidManifest.xml.in android/AndroidManifest.xml)

    set_target_properties(${PROJECT_NAME} PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/android"
        QT_ANDROID_PACKAGE_NAME ${APP_ID}
        QT_ANDROID_VERSION_NAME ${PROJECT_VERSION}
        QT_ANDROID_VERSION_CODE ${PROJECT_VERSION_CODE}
        QT_ANDROID_TARGET_SDK_VERSION 36
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
    # Note: CMAKE_OSX_DEPLOYMENT_TARGET cannot be set here; it must be set
    # before project(). Release builds pass it on the command line, see the
    # fastlane mac lane and .github/workflows/macos.yml.

    set(app_icon_macos "${CMAKE_CURRENT_SOURCE_DIR}/macos/addhoursandminutes.icns")
    set_source_files_properties(${app_icon_macos} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
    target_sources(${PROJECT_NAME} PRIVATE "${app_icon_macos}")
    set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/macos/addhoursandminutes.entitlements PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
    target_sources(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/macos/addhoursandminutes.entitlements")

    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE true
        MACOSX_BUNDLE_BUNDLE_NAME "Add Times"
        MACOSX_BUNDLE_GUI_IDENTIFIER "de.akafliegfreiburg.addhoursandminutes"
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/macos/Info.plist"
        MACOSX_BUNDLE_ICON_FILE addhoursandminutes.icns
    )
endif ()


#
# Set up additional files for iOS
#

if (CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE TRUE)
    set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/ios/Info.plist")
    set_target_properties(${PROJECT_NAME} PROPERTIES QT_IOS_LAUNCH_SCREEN "${CMAKE_CURRENT_SOURCE_DIR}/ios/LaunchScreen.storyboard")

    set(asset_catalog_path "ios/Assets.xcassets")
    set(PRODUCT_BUNDLE_IDENTIFIER de.akafliegfreiburg.addhoursandminutes)
    set(CMAKE_XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME AppIcon)
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
