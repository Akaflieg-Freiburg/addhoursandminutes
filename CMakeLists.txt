# Set up cmake
cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_STANDARD 11)

# Basic information about our project
project(addHoursAndMinutes VERSION 0.9.1)
set(PROJECT_DATE 2018-12-07)
set(APP_ID de.akaflieg_freiburg.cavok.add_hours_and_minutes)


# Include external packages and modules
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Qt5 COMPONENTS Core LinguistTools Quick QuickWidgets Widgets REQUIRED )
include(GNUInstallDirs)

if(ANDROID)
  message(FATAL_ERROR "Android development is not supported in the CMakeList.txt. Please use the qmake file provided.")
endif()

# Find GIT commit for the TAG given by the ${PROJECT_VERSION}, if git is
# available and if we are working in a git source tree
if(EXISTS ${CMAKE_SOURCE_DIR}/.git)
  find_package(Git)
  if(Git_FOUND)
    message("Building inside a GIT directory, git found at ${GIT_EXECUTABLE}")
    execute_process(COMMAND git rev-list -n1 ${PROJECT_VERSION}
      OUTPUT_VARIABLE TAG_COMMIT
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    message("Git Tag ${PROJECT_VERSION} = Commit ${TAG_COMMIT}")
  else()
    message("Git not found.")
  endif()
endif()

# Subdirectories
add_subdirectory(metadata)
add_subdirectory(packaging)
add_subdirectory(src)
