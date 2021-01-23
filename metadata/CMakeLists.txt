# On Unix, generate and install metadata information

if (UNIX)
  CONFIGURE_FILE(${APP_ID}.desktop ${APP_ID}.desktop)
  INSTALL(FILES ${PROJECT_BINARY_DIR}/metadata/${APP_ID}.desktop
    RENAME ${APP_ID}.desktop
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)
  
  CONFIGURE_FILE(${APP_ID}.appdata.xml ${APP_ID}.appdata.xml)
  INSTALL(FILES ${PROJECT_BINARY_DIR}/metadata/${APP_ID}.appdata.xml
    RENAME ${APP_ID}.appdata.xml
    DESTINATION share/appdata)
  
  INSTALL(FILES ${PROJECT_SOURCE_DIR}/metadata/${APP_ID}.svg
    RENAME ${APP_ID}.svg
    DESTINATION share/icons/hicolor/scalable/apps)
endif (UNIX)
