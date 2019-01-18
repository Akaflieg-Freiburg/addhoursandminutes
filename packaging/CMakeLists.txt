add_custom_target(packaging)

if (UNIX AND NOT ANDROID)
  add_subdirectory(debian)
  add_subdirectory(flatpak)
  add_subdirectory(RPM)
  add_subdirectory(tar)
endif (UNIX AND NOT ANDROID)

if (WIN32)
  add_subdirectory(installer)
endif (WIN32)
