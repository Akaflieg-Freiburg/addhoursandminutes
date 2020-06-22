#
# Prepare flatpack manifest
#

set(FLATPAK_RUNTIME_VERSION 5.14)

#
# Configure
#

configure_file(${APP_ID}.json ${APP_ID}.json)


#
# Prepare TAR file
#

add_custom_target(flatpak
  COMMAND git archive HEAD --prefix ${PROJECT_NAME}-${PROJECT_VERSION}/ -o ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz
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


#
# Publish
#

add_custom_target(publish-to-flathub
  COMMAND git pull
  COMMAND git rm -f addhoursandminutes-*.tar.gz
  COMMAND cp ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz .
  COMMAND git add ${PROJECT_NAME}-${PROJECT_VERSION}.tar.gz .
  COMMAND cp ${CMAKE_CURRENT_BINARY_DIR}/${APP_ID}.json .
  COMMAND git commit -am "New upstream version"
  COMMAND git push
  DEPENDS flatpak-binary
  WORKING_DIRECTORY /home/kebekus/Software/buildsystems/flatpak/de.akaflieg_freiburg.cavok.add_hours_and_minutes
  COMMENT "Publishing flatpak to flathub.org"
  )
