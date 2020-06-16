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
# Generate localized versions of the feature graphic for the Google Play Store
#

add_custom_target(featureGraphic
  COMMAND mkdir -p ${CMAKE_CURRENT_SOURCE_DIR}/propaganda/GooglePlay
  COMMAND convert -font Helvetica-bold -fill white -pointsize 60 -gravity center -draw "text 0,0 'Add Hours and Minutes'" ${CMAKE_SOURCE_DIR}/propaganda/GooglePlay/feature.png ${CMAKE_CURRENT_SOURCE_DIR}/propaganda/GooglePlay/feature_en.png
  COMMAND convert -font Helvetica -fill white -pointsize 60 -gravity center -draw "text 0,0 'Rechnen mit Stunden und Minuten'" ${CMAKE_SOURCE_DIR}/propaganda/GooglePlay/feature.png ${CMAKE_CURRENT_SOURCE_DIR}/propaganda/GooglePlay/feature_de.png
  COMMENT "Generated sources: Google Play Feature Graphic"
  VERBATIM
  )


#
# Target 'generatedSources' that combines all of the above
#

add_custom_target(generatedSources
  DEPENDS featureGraphic
  DEPENDS mainIcons
  )
