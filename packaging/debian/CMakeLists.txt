#
# Prepare Debian package
#

file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/debian)
configure_file(changelog debian-working/changelog)
configure_file(compat debian-working/compat)
configure_file(control debian-working/control COPYONLY)
configure_file(copyright debian-working/copyright COPYONLY)
configure_file(rules debian-working/rules)
configure_file(source/format debian-working/source/format)

add_custom_target(packaging-debian
  COMMAND curl -s -o ${PROJECT_NAME}_${PROJECT_VERSION}.orig.tar.gz https://gitlab.com/kebekus/${PROJECT_NAME}/-/archive/${PROJECT_VERSION}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
  COMMAND tar xf ${PROJECT_NAME}_${PROJECT_VERSION}.orig.tar.gz
  COMMAND rm -rf ${PROJECT_NAME}-${PROJECT_VERSION}/debian
  COMMAND mkdir ${PROJECT_NAME}-${PROJECT_VERSION}/debian
  COMMAND cp -prd ../debian-working/* ${PROJECT_NAME}-${PROJECT_VERSION}/debian
  COMMAND dpkg-source -b ${PROJECT_NAME}-${PROJECT_VERSION}
  COMMAND rm -rf ${PROJECT_NAME}-${PROJECT_VERSION}
  COMMENT "Downloading tarball and building Debian source package"
  WORKING_DIRECTORY debian
  )


#
# Add target that include  both RPM and Debian packages
#
add_dependencies(packaging packaging-debian)
