# load in errosion data
library(tmap)
library(sp)
library(rgeos)

# set working directory
old = setwd("~/Desktop/NCERM maps/")

dirs = list.dirs()

# omit directories
dirs = dirs[!grepl(pattern = "NAI|HLS", dirs)]
dirs = dirs[-1]

i = dirs[1]
shps = as.list(dirs)

# scenarios of interest: LT_SMP_95, LT_NAI_95
counter = 0
for(i in dirs){
  shp = list.files(i, pattern = ".shp")[1]
  print(shp)
  if(is.na(shp)) next()
  counter = counter + 1
  shoreline = read_shape(file.path(i, shp), stringsAsFactors = T)
  
  # find columns in all variables
  if(counter == 1)
    snames = names(shoreline) else
      snames = snames[snames %in% names(shoreline)]
  # print(snames)
  shps[[counter]] = shoreline
  plot(shoreline)
}

for(i in 1:length(shps)){
  shps[[i]] = SpatialLinesDataFrame(sl = SpatialLines(shps[[i]]@lines),
                                    data = shps[[i]]@data[snames])
  
}

# test joining with 2 shapes
plot(shps[[2]])
plot(shps[[3]], add = T) # yes it's continuous

names(shps[[2]])
names(shps[[3]])
shpsb = sbind(shps[[2]], shps[[3]])

plot(shpsb)
plot(shps[[2]], col = "red", add = T)

nrow(shpsb)

# now sbind them all
for(i in 1:length(shps)){
  if(i == 1)
    shpsb = shps[[1]] else
      shpsb = sbind(shpsb, shps[[i]])
}

plot(shpsb) # uk outline
summary(shpsb$LT_SMP_95)
summary(shpsb$LT_NAI_95)
shpsb$LT_SMP_95[shpsb$LT_SMP_95 == 0] = 0.1
shpsb$LT_NAI_95[shpsb$LT_NAI_95 == 0] = 0.1

# create a buffer representing erosion
buf = gBuffer(shpsb, byid = T, width = shpsb$LT_NAI_95)
nrow(buf)
# bufag = gBuffer(buf, width = 0) # fails
bufag = gUnaryUnion(buf)
# plot(buf)
length(bufag)
class(bufag)
plot(bufag)
mapview::mapview(bufag)

# Challenge: show erosion. Solution: subtract from original coastline
# library(rnaturalearth)
# rnaturalearth::
# uk = ne_countries(scale = 10, country = "united kingdom")
# plot(uk) # too low res.

# u = "https://census.edina.ac.uk/ukborders/easy_download/prebuilt/shape/infuse_uk_2011.zip"
# download.file(u, "infuse_uk_2011.zip") # appears not to work - load manually
uk = read_shape("infuse_uk_2011.shp")
bb(uk)
mapview::mapview(uk)
# uk_eroded = gDifference(uk, bufag) # fails
uk2 = gBuffer(uk, width = 0)
uk_eroded = gDifference(uk2, bufag) # 
plot(uk_eroded)

tmap_mode("view")
tm_shape(uk2) +
  tm_borders() +
  tm_shape(uk_eroded) +
  tm_fill()

saveRDS(uk_eroded, "/tmp/uk_eroded.Rds")
file.size("/tmp/uk_eroded.Rds") / 1e6
object.size(uk_eroded) / 1e6
library(rmapshaper)
uk_eroded_lores = ms_simplify(input = uk_eroded, keep = 0.04)
object.size(uk_eroded_lores) / 1e6
mapview::mapview(uk_eroded_lores)
uk_eroded_lores@polygons[[1]]@Polygons[[1]]
raster::
sel_max_area = which.max(gArea(uk_eroded@polygons[[1]], byid = T))
uk1 = SpatialPolygons(list(Polygons(list(Polygon(uk_eroded_lores@polygons[[1]]@Polygons[[1]])), ID = 1)))

gA = NULL
for(i in 1:length(uk_eroded_lores@polygons[[1]]@Polygons)){
  g = gArea(SpatialPolygons(list(Polygons(list(Polygon(uk_eroded_lores@polygons[[1]]@Polygons[[i]])), ID = 1)))
)
  gA = c(gA, g)
}
sm = which.max(gA)
lapply(uk_eroded_lores@polygons, function(x)
  SpatialPolygons(list(Polygons(list(Polygon(uk_eroded_lores@polygons[[1]]@Polygons)), ID = 1))))
uk_eroded_lo = SpatialPolygons(list(Polygons(list(Polygon(uk_eroded_lores@polygons[[1]]@Polygons[[sm]])), ID = 1)))
proj4string(uk_eroded_lo) = proj4string(uk)
mapview::mapview(uk_eroded_lo)

uk_lo = ms_simplify(uk)

qtm(uk_lo, fill = "blue") +
  qtm(uk_eroded_lo)

shps = shps_old

# compared with original
shpb_lo = ms_simplify(shpsb)
bbox(shpb_lo)
proj4string(shpb_lo) = CRS("+init=epsg:27700")
shpb_lo_wgs = spTransform(shpb_lo, CRS("+init=epsg:4326"))
tm_shape(shpb_lo) +
  tm_lines(col = "red") +
  qtm(uk_eroded_lo, fill = "green")

uk_outline = ms_simplify(shpb_lo)
geojsonio::geojson_write(uk_eroded_lo, file = "/tmp/uk_eroded_lo_LT_NAI_95.geojson")
geojsonio::geojson_write(uk_outline, file = "/tmp/uk_outline.geojson")
