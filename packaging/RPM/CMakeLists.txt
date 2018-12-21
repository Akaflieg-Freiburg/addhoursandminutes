#
# Prepare RPM files
#

configure_file(${PROJECT_NAME}.spec ${PROJECT_NAME}.spec)
add_custom_target(packaging-rpm
  COMMAND curl -s -o ${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz https://gitlab.com/kebekus/${PROJECT_NAME}/-/archive/${PROJECT_VERSION}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
  COMMENT "Downloading tarball for RPM package"
  )

#
# Add target
#
add_dependencies(packaging packaging-rpm)
