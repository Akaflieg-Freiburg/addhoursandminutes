# Set up cmake
cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_STANDARD 11)

# Basic information about our project
project(addhoursandminutes VERSION 1.0.0)
set(APP_ID de.akaflieg_freiburg.cavok.add_hours_and_minutes)
set(PROJECT_DATE 2018-12-07)

# Include external packages and modules
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core LinguistTools Quick REQUIRED)
if(ANDROID)
  find_package(Qt5 COMPONENTS AndroidExtras REQUIRED)
  include(3rdParty/qt-android-cmake/AddQtAndroidApk.cmake)
endif()

include(GNUInstallDirs)


# Find GIT commit for the TAG given by the ${PROJECT_VERSION}, if git is
# available and if we are working in a git source tree

if(EXISTS ${CMAKE_SOURCE_DIR}/.git)
  find_package(Git)
  if(Git_FOUND)
    message("Building inside a GIT directory, git found at ${GIT_EXECUTABLE}")
    execute_process(COMMAND git log --pretty=format:'%H' -n1
      OUTPUT_VARIABLE TAG_COMMIT
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    message("Currently working with git Commit ${TAG_COMMIT}")
  else()
    message("Git not found.")
  endif()
endif()

# Subdirectories
add_subdirectory(metadata)
add_subdirectory(src)
add_subdirectory(packaging)
