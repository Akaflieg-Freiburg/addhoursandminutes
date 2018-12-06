# Set up cmake
cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_STANDARD 11)

# Basic information about our project
project(addHoursAndMinutes VERSION 1.0.0)
set(PROJECT_DATE 2018-12-05)
add_definitions(-DPROJECT_VERSION="${PROJECT_VERSION}")

# Add support for Qt
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Qt5 COMPONENTS Core LinguistTools Quick QuickWidgets Widgets REQUIRED )

if(ANDROID)
  message(FATAL_ERROR "Android development is not supported in the CMakeList.txt. Please use the qmake file provided.")
endif()

# Subdirectories
ADD_SUBDIRECTORY(metadata)
#ADD_SUBDIRECTORY(packaging)
add_subdirectory(src)
