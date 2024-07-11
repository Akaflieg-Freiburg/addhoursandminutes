#
# Configure
#

configure_file(${APP_ID}.json ${APP_ID}.json)

#
# Sample build
#
add_custom_target(flatpak-binary
  COMMAND rm -rf flatpakBuildDirectory .flatpak-builder
  COMMAND flatpak-builder flatpakBuildDirectory de.akaflieg_freiburg.cavok.add_hours_and_minutes.json
  COMMAND echo ""
  COMMAND echo ""
  COMMAND echo "Run your flatpak with the following command"
  COMMAND echo ""
  COMMAND echo " flatpak-builder --run ${CMAKE_CURRENT_BINARY_DIR}/flatpakBuildDirectory ${CMAKE_CURRENT_BINARY_DIR}/${APP_ID}.json addhoursandminutes"
  COMMAND echo ""
  COMMAND echo ""
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Generating flatpak binary"
)

#
# Run linter on sample build
#
add_custom_target(flatpak-lint
  COMMAND flatpak run --command=flatpak-builder-lint org.flatpak.Builder manifest de.akaflieg_freiburg.cavok.add_hours_and_minutes.json
  COMMAND flatpak run --command=flatpak-builder-lint org.flatpak.Builder appstream ../../metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.appdata.xml
  COMMAND flatpak run --command=flatpak-builder-lint org.flatpak.Builder builddir flatpakBuildDirectory
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Linting flatpak build"
)

#
# Publication
#
add_custom_target(flatpak-publish
  COMMAND rm -rf de.akaflieg_freiburg.cavok.add_hours_and_minutes
  COMMAND git clone --depth 1 --branch upstream git@github.com:flathub/de.akaflieg_freiburg.cavok.add_hours_and_minutes.git
  COMMAND cp de.akaflieg_freiburg.cavok.add_hours_and_minutes.json de.akaflieg_freiburg.cavok.add_hours_and_minutes
  COMMAND cd de.akaflieg_freiburg.cavok.add_hours_and_minutes
  COMMAND git diff-index --quiet HEAD || git commit -am "New upstream release"
  COMMAND git push
  COMMAND gh pr create --title "New upstream release" --body "Please merge the following new upstream release"
  COMMAND cd ..
  COMMAND rm -rf de.akaflieg_freiburg.cavok.add_hours_and_minutes
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Publishing flatpak"
)
