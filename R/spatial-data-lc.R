
library(GISTools)
data("georgia")

class(georgia)
georgia_sp = SpatialPolygons(georgia@polygons)
class(georgia_sp)
plot(georgia_sp)
slotNames(georgia_sp)

plot(georgia)
slotNames(georgia)
georgia_dat = georgia@data[sample(nrow(georgia)),]

georgia_joined = SpatialPolygonsDataFrame(Sr = georgia_sp, data = georgia_dat)
identical(georgia, georgia_joined)

plot(georgia[c(1,3,4)], add = T, col = "red")

plot(georgia)
plot(georgia[c(1,3,4),], add = T, col = "red")

# how to access geometry
geom1 = georgia@polygons[[1]]@Polygons[[1]]@coords
head(geom1)
points(geom1)

geoms = sapply(georgia@polygons, function(x) x@Polygons[[1]]@coords)
geoms = do.call(rbind, geoms)
points(geoms)
library(stplanr)

proj4string(georgia)

proj4string(lnd)
library(leaflet)
leaflet() %>% addTiles() %>% addPolygons(data = lnd)

lnd_latlon = spTransform(x = lnd, CRSobj = CRS("+init=epsg:4326"))
bbox(lnd)

gArea(lnd, byid = T) / 10000

gArea(lnd_latlon)

library(tmap)
tmap_mode("view")
qtm(lnd, "conservative")
tmap_mode("view")


