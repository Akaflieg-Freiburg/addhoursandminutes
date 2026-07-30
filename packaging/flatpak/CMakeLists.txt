#
# Configure
#

configure_file(${APP_ID}.json ${APP_ID}.json)

#
# Sample build
#
add_custom_target(flatpak-binary
  COMMAND flatpak-builder --force-clean flatpakBuildDirectory de.akaflieg_freiburg.cavok.add_hours_and_minutes.json
  COMMAND echo ""
  COMMAND echo ""
  COMMAND echo "Run your flatpak with the following command"
  COMMAND echo ""
  COMMAND echo " flatpak-builder --run ${CMAKE_CURRENT_BINARY_DIR}/flatpakBuildDirectory ${CMAKE_CURRENT_BINARY_DIR}/${APP_ID}.json addhoursandminutes -platform wayland"
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

# Note: publication to Flathub is handled by the fastlane lane
# "flathubRelease"; see fastlane/Fastfile.
