add_custom_target(packaging)


#
# Prepare TAR file
#

add_custom_target(tar
  COMMAND git archive HEAD --prefix ${PROJECT_NAME}-${PROJECT_VERSION}/ -o ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar
  COMMAND tar -v --wildcards --delete */docs/* --file ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar
  COMMAND rm -f ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
  COMMAND gzip -9 ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMENT "Generating tarball for flatpak"
)


#
# Prepare TAR Flatpak distribution
#

if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    add_subdirectory(flatpak)
endif ()
