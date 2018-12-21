add_custom_target(packaging)

add_subdirectory(android)

if (UNIX AND NOT ANDROID)
  add_subdirectory(debian)
  add_subdirectory(flatpak)
  add_subdirectory(installer)
  add_subdirectory(RPM)
endif (UNIX AND NOT ANDROID)
