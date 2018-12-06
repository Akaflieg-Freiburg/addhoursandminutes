# On Unix, generate and install metadata information

if (UNIX)
  CONFIGURE_FILE(de.akaflieg_freiburg.cavok.add_hours_and_minutes.desktop de.akaflieg_freiburg.cavok.add_hours_and_minutes.desktop)
  INSTALL(FILES ${PROJECT_BINARY_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.desktop DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)
  
  CONFIGURE_FILE(de.akaflieg_freiburg.cavok.add_hours_and_minutes.appdata.xml de.akaflieg_freiburg.cavok.add_hours_and_minutes.appdata.xml)
  INSTALL(FILES ${PROJECT_BINARY_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.appdata.xml DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/metainfo)
  
  INSTALL(FILES ${PROJECT_SOURCE_DIR}/metadata/de.akaflieg_freiburg.cavok.add_hours_and_minutes.svg DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/apps)
endif (UNIX)
