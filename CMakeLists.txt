# Set up cmake
cmake_minimum_required(VERSION 3.19)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Basic information about our project
project(addhoursandminutes VERSION 1.3.5)
set(APP_ID de.akaflieg_freiburg.cavok.add_hours_and_minutes)
set(DISPLAY_NAME "Add Times")
set(PROJECT_DATE 2023-3-28)
math(EXPR PROJECT_VERSION_CODE 100000*${PROJECT_VERSION_MAJOR}+1000*${PROJECT_VERSION_MINOR}+${PROJECT_VERSION_PATCH})
add_definitions( -DPROJECT_VERSION="${PROJECT_VERSION}" )


if(IOS)
    set(PRODUCT_BUNDLE_IDENTIFIER de.akafliegfreiburg.addhoursandminutes)
#    set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "XXXXX")

    #set Icon
    set(CMAKE_XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME AppIcon)
endif()


# Include required packages
find_package(Qt6 6.5 REQUIRED COMPONENTS Core LinguistTools Quick QuickControls2 Svg)
qt_standard_project_setup()
qt_policy(SET QTP0001 NEW)

# Subdirectories
add_subdirectory(generatedSources)
add_subdirectory(metadata)
add_subdirectory(src)
add_subdirectory(packaging)
