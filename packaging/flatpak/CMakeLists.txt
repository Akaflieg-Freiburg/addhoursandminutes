#
# Prepare flatpack manifest
#

#
# Configure
#
if (DEFINED TAG_COMMIT)
  configure_file(${APP_ID}.json ${APP_ID}.json)
else()
  message("Not building inside a GIT directory, or git command not available. Flatpak manifest will not be generated.")
endif()

#
# Prepare TAR file
#

add_custom_target(packaging-flatpak
  COMMAND git archive HEAD --prefix ${PROJECT_NAME}-${PROJECT_VERSION}/ -o ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMENT "Generating tarball for flatpak"
  )
