#
# Provide translations
#

qt5_add_translation(qm_files
  addHoursAndMinutes_de.ts
  )
add_custom_target(translations DEPENDS ${qm_files})
configure_file(addHoursAndMinutes_translations.qrc addHoursAndMinutes_translations.qrc COPYONLY)


#
# Set up target for executable
#

set(SOURCES
    main.cpp
    addHoursAndMinutes.qrc
    ${CMAKE_CURRENT_BINARY_DIR}/addHoursAndMinutes_translations.qrc
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
