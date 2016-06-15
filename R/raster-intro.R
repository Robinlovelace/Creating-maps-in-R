load("data/lnd.RData")
library(raster)

r = raster(nrow = 50, ncol = 50, ext = extent(lnd))
lnd_raster = rasterize(lnd, r)
class(lnd_raster)
plot(lnd_raster)
head(lnd_raster@data@attributes)
plot(lnd_raster$layer)
plot(lnd_raster, "Pop_2001")
# for more details
?raster::plot
library(mapview)
mapview(lnd_raster)

# Add stations data
stns = tmap::read_shape("data/lnd-stns.shp")
crs(stns)
stns = spTransform(stns, CRS(proj4string(lnd)))
names(stns)
stns_raster = rasterize(stns, r,
                        field = "NAME",
                        fun = "count")
summary(stns_raster)
plot(stns_raster)
points(stns)
mapview(stns, stns_raster)
  
plot(stns)
# poznan data
poz = raster("data/poz_modified.tif")

mapview(poz)
