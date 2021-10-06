# Set up cmake
cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_STANDARD 11)
cmake_policy(SET CMP0058 NEW)
cmake_policy(SET CMP0071 NEW)

# Basic information about our project
project(addhoursandminutes VERSION 1.2.0)
set(APP_ID de.akaflieg_freiburg.cavok.add_hours_and_minutes)
set(PROJECT_DATE 2021-10-02)
math(EXPR PROJECT_VERSION_CODE 10000*${PROJECT_VERSION_MAJOR}+100*${PROJECT_VERSION_MINOR}+${PROJECT_VERSION_PATCH})
add_definitions( -DPROJECT_VERSION="${PROJECT_VERSION}" )

# Include external packages and modules
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include required packages
find_package(Qt6 COMPONENTS Core LinguistTools Quick Svg REQUIRED)
if( ANDROID )
#  find_package(Qt6 COMPONENTS AndroidExtras REQUIRED)
#  find_package(Qt6QuickCompiler)
endif()
include(GNUInstallDirs)

# Subdirectories
add_subdirectory(generatedSources)
add_subdirectory(metadata)
add_subdirectory(src)
add_subdirectory(packaging)
