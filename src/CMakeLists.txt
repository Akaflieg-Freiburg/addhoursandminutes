#
# Provide translations
#

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

set(SOURCES
  addHoursAndMinutes.qrc
  androidClient.cpp
  main.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/addHoursAndMinutes_translations.qrc
  )

if(ANDROID)
  add_library(${PROJECT_NAME} SHARED ${SOURCES})
  target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::AndroidExtras)
else(ANDROID)
  add_executable(${PROJECT_NAME} WIN32 ${SOURCES})
endif(ANDROID)

add_dependencies(${PROJECT_NAME} translations)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick)


#
# Install things
#

install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
