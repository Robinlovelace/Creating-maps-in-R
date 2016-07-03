library(leaflet)
library(tmap)
library(raster)

saveas <- function(map, file){
  class(map) <- c("saveas",class(map))
  attr(map,"filesave")=file
  map
}

print.saveas <- function(x, ...){
  class(x) = class(x)[class(x)!="saveas"]
  htmltools::save_html(x, file=attr(x,"filesave"))
}

b <- bb("New York")
hf <- read_osm(x = b, minNumTiles = 5, type = "osm-bw")
ggmap::
openmap()
tm_shape(hf) +
  tm_raster()

r <- raster(hf)
plot(r)

leaflet() %>% addTiles() %>% saveas("index.html")

leaflet() %>% addWMSTiles("http://tile.openstreetmap.de/tiles/osmde/")
