
configure_file(config/config.xml installer-working/config/config.xml)
configure_file(packages/de.akaflieg_freiburg.cavok.add_hours_and_minutes/meta/package.xml installer-working/packages/de.akaflieg_freiburg.cavok.add_hours_and_minutes/meta/package.xml)
configure_file(${CMAKE_SOURCE_DIR}/LICENSE.md installer-working/packages/de.akaflieg_freiburg.cavok.add_hours_and_minutes/meta/license.md)

add_custom_target(installer
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/src/${PROJECT_NAME} installer-working/packages/de.akaflieg_freiburg.cavok.add_hours_and_minutes/data/${PROJECT_NAME}
  COMMAND binarycreator -c installer-working/config/config.xml -p installer-working/packages ${PROJECT_NAME}-installer.exe
  COMMENT "Generate installer binary"
  )
add_dependencies(installer ${PROJECT_NAME})
add_dependencies(packaging installer)
