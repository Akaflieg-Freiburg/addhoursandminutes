#
# Prepare RPM files
#

add_custom_target(packaging-tar
  COMMAND git archive HEAD -o ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMENT "Generating tarball"
  )

#
# Add target
#

add_dependencies(packaging packaging-tar)
