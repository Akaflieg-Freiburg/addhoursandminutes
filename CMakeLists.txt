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


#
# Find GIT repository data.
#

if (EXISTS ${CMAKE_SOURCE_DIR}/.git)
    # Get the current working branch
    execute_process(
        COMMAND git rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    message("Currently working with git branch ${GIT_BRANCH}")

    # Get the latest abbreviated commit hash of the working branch
    execute_process(
        COMMAND git log -1 --format=%h
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    message("Currently working with git Commit ${GIT_COMMIT}")

    # Get the latest commit date of the working branch
    execute_process(
        COMMAND git log -1 --format=%as
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_DATE
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    message("Currently working with git commit from ${GIT_DATE}")
else()
    message("Not working from a GIT directory")
    set(GIT_BRANCH "")
    set(GIT_BRANCH "")
    set(GIT_COMMIT "")
    set(GIT_DATE "")
endif()


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
