library(shiny)
library(leaflet)

function(input, output) {
  
#   map = leaflet() %>% addTiles() %>% # basic map background
  
#   opencyclemap background:
#   see http://leaflet-extras.github.io/leaflet-providers/preview/index.html
  map = leaflet() %>% addTiles("http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png") %>%
      setView(-1.5, 53.4, zoom = 10) %>% # map location
      addMarkers(-1.4, 53.5) %>% # add a marker
      addPopups(-1.6, 53.3, popup = "Hello Sheffield!") %>% # popup
      # add som circles:
      addCircles(color = "black", runif(90, -2, -1), runif(90, 53, 54), runif(90, 10, 500))
  output$myMap = renderLeaflet(map)
}