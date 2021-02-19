#
# Prepare flatpack manifest
#

set(FLATPAK_RUNTIME_VERSION 5.15)

#
# Configure
#

configure_file(${APP_ID}.json ${APP_ID}.json)


#
# Prepare TAR file
#

add_custom_target(flatpak
  COMMAND git archive HEAD --prefix ${PROJECT_NAME}-${PROJECT_VERSION}/ -o ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar
  COMMAND tar -v --wildcards --delete */docs/* --file ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar
  COMMAND rm -f ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
  COMMAND gzip -9 ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMENT "Generating tarball for flatpak"
  )


#
# Sample build
#

add_custom_target(flatpak-binary
  COMMAND rm -rf flatpakBuildDirectory .flatpak-builder
  COMMAND flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  COMMAND flatpak install --user --assumeyes org.kde.Sdk/x86_64/${FLATPAK_RUNTIME_VERSION} org.kde.Platform/x86_64/${FLATPAK_RUNTIME_VERSION}
  COMMAND flatpak-builder flatpakBuildDirectory de.akaflieg_freiburg.cavok.add_hours_and_minutes.json
  COMMAND echo ""
  COMMAND echo ""
  COMMAND echo "Run your flatpak with the following command"
  COMMAND echo ""
  COMMAND echo " flatpak-builder --run ${CMAKE_CURRENT_BINARY_DIR}/flatpakBuildDirectory ${CMAKE_CURRENT_BINARY_DIR}/${APP_ID}.json addhoursandminutes"
  COMMAND echo ""
  COMMAND echo ""
  DEPENDS flatpak
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Generating flatpak binary"
  )
