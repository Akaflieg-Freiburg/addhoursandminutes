# Set up cmake
cmake_minimum_required(VERSION 3.19)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Basic information about our project
project(addhoursandminutes VERSION 1.3.0)
set(APP_ID de.akaflieg_freiburg.cavok.add_hours_and_minutes)
set(PROJECT_DATE 2022-10-20)
math(EXPR PROJECT_VERSION_CODE 10000*${PROJECT_VERSION_MAJOR}+100*${PROJECT_VERSION_MINOR}+${PROJECT_VERSION_PATCH})
add_definitions( -DPROJECT_VERSION="${PROJECT_VERSION}" )


if(IOS)
    set(BUNDLE_ID de.simonschneider.addhoursandminutes) #TODO: currently needed (probably for code signing)

    #set Icon
    set(CMAKE_XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME AppIcon)

endif()

# Include required packages
find_package(Qt6 REQUIRED COMPONENTS Core LinguistTools Quick Svg)
qt_standard_project_setup()

# Subdirectories
add_subdirectory(generatedSources)
add_subdirectory(metadata)
add_subdirectory(src)
add_subdirectory(packaging)
