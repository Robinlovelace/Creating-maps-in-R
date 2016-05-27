r = "D://chiara-gps-project/10uid.shp"

library(raster)

devtools::install_github("robinlovelace/overpass")

r = shapefile(r)

plot(r)
nrow(r)
bbox(r)

head(r@data)

library(leaflet)

leaflet() %>% addTiles() %>% addPolylines(data = r)

# use the overpass library to download osm data
library(overpass)

# save bounding box
bb = bbox(r)

# create query look at highway tags - see http://wiki.openstreetmap.org/wiki/Key:highway
ldat = opq(bb) %>%
  add_feature(key = "highway", value = "cycleway") %>% issue_query()

shapefile(ldat, file = "D://chiara-gps-project/cycleway")

plot(ldat)
plot(r, add = T, col = "red")

nrow(ldat)

plot(ldat[100,], add = T, col = "blue")
df = ldat@data
df = apply(df, 2, factor)
summary(df)
summary(ldat@data)

l = r[ldat,]
plot(l[1,])
plot(ldat, col = "grey", add = T)
plot(l[1,], col = "red", add = T)

# create a buffer


