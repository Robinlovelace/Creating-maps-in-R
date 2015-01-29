# Script to scrape geo-references images from Google maps and save as geotiffs
library(ggmap) # install.packages('ggmap') must be run first - same for 'raster'
library(raster)
gc <- as.numeric(geocode("Melbourne")) # centre point of the raster images to grab
# x_adjust <- 0.0018 # move centrepoint in x location
# y_adjust <- -0.003 # move y direction
gc <- gc + c(x_adjust, y_adjust)
ggmap(get_map(location = gc ))
gm <- get_map(location = gc, zoom = 16)
ggmap(gm)
gm <- get_map(gc, zoom = 16, maptype = "satellite")
ggmap(gm)

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

gr1 <- ggmap_rast(map = gm)
class(gr1)
bb <- bbox(gr1)

# Stitching together many bounding boxes
n_col <- 3 # width in bb units ################## add your input here 
n_row <- 2 # height ################## add your input here

bb_array <- array(NA, dim = c(2, 2, n_row, n_col))
bb_array[1,,1,1] <- bb[1, ] - ((n_col - 1) / 2) * (bb[1, 2] - bb[1, 1]) # top left x
bb_array[2,,1,1] <- bb[1, ] - ((n_row - 1)  / 2) * (bb[2, 2] - bb[2, 1]) # top left y
for(i in 1:n_col){
  for(j in 1:n_row){
    bb_array[1,,j,i] <- bb[1, ] - ((n_col - 1) / 2) * (bb[1, 2] - bb[1, 1]) + (i - 1)* (bb[1, 2] - bb[1, 1])
    bb_array[2,,j,i] <- bb[2, ] - ((n_row - 1)  / 2) * (bb[2, 2] - bb[2, 1]) + (j - 1)* (bb[2, 2] - bb[2, 1])
  }
}

# Using the bounding boxes to download the images
grm <- ggmap_rast(get_map(bb_array[,,1,1], maptype = "satellite"))

for(i in 1:n_col){
  for(j in 1:n_row){
    gr <- ggmap_rast(get_map(bb_array[,,j,i], maptype = "satellite"))
    grm <- raster::merge(grm, gr, tolerance = 5)
  }
}
plotRGB(grm)

writeRaster(grm, filename = "~/Dropbox/Public/tmp/whatever.tiff", format="GTiff", overwrite = TRUE) # save output
# writeRaster(grm, filename = "~/Dropbox/highbury.bmp", format="BMP", overwrite = TRUE) # save output
