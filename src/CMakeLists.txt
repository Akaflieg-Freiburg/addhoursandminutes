#
# Provide translations
#

cmake_policy(SET CMP0071 NEW)

qt5_add_translation(qm_files
  addHoursAndMinutes_de.ts
  )
add_custom_target(translations DEPENDS ${qm_files})
configure_file(addHoursAndMinutes_translations.qrc addHoursAndMinutes_translations.qrc COPYONLY)
configure_file(text/info.html.in text/info.html)
configure_file(text/info_de.html.in text/info_de.html)


#
# Set up target for executable
#

qtquick_compiler_add_resources(RESOURCES addHoursAndMinutes.qrc)
message(${RESOURCES})
set(SOURCES
    main.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/addHoursAndMinutes_translations.qrc
    ${RESOURCES}
  )
if(ANDROID)
  add_library(${PROJECT_NAME} SHARED ${SOURCES})
else(ANDROID)
  add_executable(${PROJECT_NAME} WIN32 ${SOURCES})
endif(ANDROID)
add_dependencies(${PROJECT_NAME} translations)
add_dependencies(${PROJECT_NAME} translations)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick)


#
# Install things
#

install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
