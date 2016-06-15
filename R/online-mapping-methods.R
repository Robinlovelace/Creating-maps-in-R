library(tmap)
library(sp)
lnd = read_shape("data/london_sport.shp")
names(lnd)
plot(lnd)
lnd_wgs = spTransform(lnd, CRS("+init=epsg:4326"))
qtm(lnd_wgs, fill = "Pop_2001")
tmap_mode(mode = "plot")

vignette("tmap-nutshell")
vignette("tmap-modes")

qtm(lnd)
bbox(lnd)

leaflet() %>%
  addPolygons(data = lnd_wgs) %>%
  addPolygons(data = lnd_wgs)

library(leaflet)
leaflet() %>% addTiles() %>%
  addPolygons(data = lnd_wgs)

df = data.frame(x = 12, y = 150000)

names(lnd)
plot(lnd$Partic_Per, lnd$Pop_2001)
library(ggplot2)
ggplot(data = lnd@data, aes(Partic_Per, Pop_2001)) +
  geom_point(aes(color = Pop_2001)) +
  scale_color_gradient(low = "green", high = "red") +
  geom_point(data = df, aes(x = x, y = y), color = "red")
  
# Using mapview - after running Lex Comber's point-pattern code
library(mapview)
library(sp)
library(GISTools)
source("R/point-pattern-lc.R")
plot(breach)
names(breach)
breach_ras = raster(breach.dens)
values(breach_ras) = breach@

leaflet() %>% addTiles() %>%
  addRasterImage(breach_ras)

mapview(breach.dens, alpha = 1)



mapview(breach.dens, alpha = 0.5, col.regions = terrain.colors)
mapview(breach.dens, alpha = 0.5, col.regions = terrain.colors, legend = T)
mapview(breach.dens, alpha = 0.5, col.regions = terrain.colors)
mapview(breach.dens, alpha = 0.5, col.regions = terrain.colors, map.types = "CartoDB.DarkMatter")


# SpatialPixelsDataFrame
data(meuse.grid)
coordinates(meuse.grid) <- ~x+y
proj4string(meuse.grid) <- CRS("+init=epsg:28992")
gridded(meuse.grid) <- TRUE

mapView(meuse.grid, zcol = "soil")

library(raster)
poz = brick("data/poz_modified.tif")
class(poz)
class(s)
plotRGB(poz)
mapview(poz)
m = viewRGB(poz)
htmlwidgets::saveWidget(m@map,
    "~/repos/robinlovelace.github.io2/pozmap.html")
mapview(tmp["var1.pred"])

# WW2 era German map of Nazi occupied Poznan. Georeferenced w. 3 points in @qgis and plotted with #rstats mapview
