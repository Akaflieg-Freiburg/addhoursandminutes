add_custom_target(packaging)

if (UNIX AND NOT ANDROID)
  add_subdirectory(flatpak)
endif (UNIX AND NOT ANDROID)
