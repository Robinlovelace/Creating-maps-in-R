# Script to scrape geo-references images from Google maps and save as geotiffs
library(ggmap)
library(raster)
gc <- as.numeric(geocode("Roseband, Leeds"))
ggmap(get_map(location = , zoom = 10))
gm <- get_map(location = gc, zoom = 20)
ggmap(gm)
gc[2]
gc
gc <- c(-1.5662, 53.8057)
gm <- get_map(gc, zoom = 20, maptype = "satellite")
ggmap(gm)

gr1 <- ggmap_rast(map = gm)
class(gr1)
(bb <- bbox(gr1))
plot(gr1)

# Create raster layer from ggmap objects with new function
ggmap_rast <- function(map){
  map_bbox <- attr(map, 'bb') 
  .extent <- extent(as.numeric(map_bbox[c(2,4,1,3)]))
  my_map <- raster(.extent, nrow= nrow(map), ncol = ncol(map))
  rgb_cols <- setNames(as.data.frame(t(col2rgb(map))), c('red','green','blue'))
  red <- my_map
  values(red) <- rgb_cols[['red']]
  green <- my_map
  values(green) <- rgb_cols[['green']]
  blue <- my_map
  values(blue) <- rgb_cols[['blue']]
  stack(red,green,blue)
}

# Stitching together many bounding boxes
n_row <- 3 # height in bb units
n_col <- 6 # width
bb_array <- array(NA, dim = c(2, 2, n_col, n_row))
bb_array[1,,1,1] <- bb[1, ] - (n_row / 2) * (bb[1, 2] - bb[1, 1]) # top left x
bb_array[2,,1,1] <- bb[1, ] - (n_col / 2) * (bb[2, 2] - bb[2, 1]) # top left y
for(i in 1:n_row){
  for(j in 1:n_col){
    bb_array[1,,j,i] <- bb[1, ] - (n_row / 2) * (bb[1, 2] - bb[1, 1]) + (i - 1)* (bb[1, 2] - bb[1, 1])
    bb_array[2,,j,i] <- bb[2, ] - (n_col / 2) * (bb[2, 2] - bb[2, 1]) + (j - 1)* (bb[2, 2] - bb[2, 1])
  }
}

# Using the bounding boxes to download the images
grm <- ggmap_rast(get_map(bb_array[,,1,1], maptype = "satellite"))
for(i in 1:n_row){
  for(j in 1:n_col){
    gr <- ggmap_rast(get_map(bb_array[,,j,i], maptype = "satellite"))
    grm <- raster::merge(gr, grm, tolerance = 1)
  }
}
plotRGB(grm)
writeRaster(grm, filename = "/tmp/output.tif", format="GTiff") # save output
