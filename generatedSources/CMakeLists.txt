#
# Generate PNG versions of the main program icon
#

add_custom_target(mainIcons
  COMMAND mkdir -p ${CMAKE_CURRENT_SOURCE_DIR}/metadata
  COMMAND rsvg-convert ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}_angular.svg -o ${CMAKE_CURRENT_SOURCE_DIR}/metadata/${APP_ID}_angular.png -h 512 -w 512
  COMMAND rsvg-convert ${CMAKE_SOURCE_DIR}/metadata/${APP_ID}.svg -o ${CMAKE_CURRENT_SOURCE_DIR}/metadata/${APP_ID}.png -h 512 -w 512
  COMMENT "Generated sources: main program icons"
  )


#
# Target 'generatedSources' that combines all of the above
#

add_custom_target(generatedSources
  DEPENDS mainIcons
  )
