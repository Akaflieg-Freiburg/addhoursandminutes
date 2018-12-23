
configure_file(config/config.xml installer-working/config/config.xml)
configure_file(packages/${APP_ID}/meta/package.xml installer-working/packages/${APP_ID}/meta/package.xml)
configure_file(${CMAKE_SOURCE_DIR}/LICENSE.md installer-working/packages/${APP_ID}/meta/license.md)

find_program (BINARYCREATOR binarycreator
    HINTS /Qt/Tools/QtInstallerFramework/3.0/bin
    )

add_custom_target(installer
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/src/${PROJECT_NAME}.exe installer-working/packages/${APP_ID}/data/${PROJECT_NAME}.exe
  COMMAND windeployqt.exe installer-working/packages/${APP_ID}/data/${PROJECT_NAME}
  COMMAND ${BINARYCREATOR} -v -c installer-working/config/config.xml -p installer-working/packages ${PROJECT_NAME}-installer.exe
  COMMENT "Generate installer binary"
  )
add_dependencies(installer ${PROJECT_NAME})
add_dependencies(packaging installer)
