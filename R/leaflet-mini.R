library(raster)
lnd <- shapefile("data/london_sport.shp")
plot(lnd)

# library(devtools)
# install_github("rstudio/leaflet")
library(leaflet)

summary(lnd)

lnd84 <- spTransform(lnd, CRSobj = CRS("+init=epsg:4326"))

leaflet() %>%
  addTiles() %>%
  addPolygons(data = lnd84)
