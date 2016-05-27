pkgs = c("geojsonio", "raster")
lapply(pkgs, library, character.only = T)

url = "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/wyoming.geojson"
download.file(url, destfile = "wyoming.geojson")
x = geojson_read("wyoming.geojson", what = "sp") # or what=sp if you want a spatial object
plot(x)

# generate random data to sample from

rpoints = spsample(x = x, n = 100, type = "random")
points(rpoints)
rpoints = SpatialPointsDataFrame(rpoints,
                                  data = data.frame(v = rep(1, length(rpoints))))

r = raster(x = x, ncols = 3, nrows = 3)
r = rasterize(rpoints, y = r, field = "v", fun = "count")
xras = rasterise(x = x, y = r, ext = extent(x))

plot(r)
plot(x, add = T)
points(rpoints)
rpoly = as(r, "SpatialPolygonsDataFrame")
spplot(rpoly)
