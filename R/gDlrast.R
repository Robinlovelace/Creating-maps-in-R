# Function for saving Google maps images

gDlrast <- function(loc_name,
  scale = 16, maptype = "roadmap", x_adjust = 0, y_adjust = 0,
  ncol = 2, nrow = 1){

if(require("ggmap")){
  print("the ggmap package is loaded correctly")
} else {
  print("install the ggmap package")
}

if(require("raster")){
  print("the raster package is loaded correctly")
} else {
  print("install the raster package")
}

gc <- as.numeric(geocode(loc_name)) # centre point 
gc <- gc + c(x_adjust, y_adjust) # adjust centre
gm <- get_map(gc, zoom = scale, maptype = maptype)
# ggmap(gm)

# Create raster layer from ggmap objects with new function

gr1 <- ggmap_rast(map = gm)
bb <- bbox(gr1)

# Stitching together many bounding boxes
bb_array <- array(NA, dim = c(2, 2, nrow, ncol))
bb_array[1,,1,1] <- bb[1, ] - ((ncol - 1) / 2) * (bb[1, 2] - bb[1, 1]) # top left x
bb_array[2,,1,1] <- bb[1, ] - ((nrow - 1)  / 2) * (bb[2, 2] - bb[2, 1]) # top left y
for(i in 1:ncol){
  for(j in 1:nrow){
    bb_array[1,,j,i] <- bb[1, ] - ((ncol - 1) / 2) * (bb[1, 2] - bb[1, 1]) + (i - 1)* (bb[1, 2] - bb[1, 1])
    bb_array[2,,j,i] <- bb[2, ] - ((nrow - 1)  / 2) * (bb[2, 2] - bb[2, 1]) + (j - 1)* (bb[2, 2] - bb[2, 1])
  }
}

# Using the bounding boxes to download the images
grm <- ggmap_rast(get_map(bb_array[,,1,1], maptype = "satellite"))

for(i in 1:ncol){
  for(j in 1:nrow){
    gr <- ggmap_rast(get_map(bb_array[,,j,i], maptype = "satellite"))
    grm <- raster::merge(grm, gr, tolerance = 5)
  }
}
grm
# plotRGB(grm)
# writeRaster(grm, filename = "/tmp/melb.tif", format="GTiff", overwrite =T)
  
}
