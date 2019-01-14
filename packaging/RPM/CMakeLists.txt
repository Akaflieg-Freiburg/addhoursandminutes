#
# Prepare RPM files
#

configure_file(${PROJECT_NAME}.spec ${PROJECT_NAME}.spec)
add_custom_target(packaging-rpm
  COMMAND cp ../tar/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz ${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
  COMMENT "Copying tarball"
  )
add_dependencies(packaging-rpm packaging-tar)

#
# Add target
#
add_dependencies(packaging packaging-rpm)
