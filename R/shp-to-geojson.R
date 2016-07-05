# Aim: convert a shapefile to a geojson
library(tmap) # to read shapefile
library(geojsonio) # to write geojson

shp = read_shape("D:/tmp/shapefile/shapefile/shapefileC.shp")
qtm(shp) # plot the data
geojson_write(shp, file = "D:/tmp/shp.geojson")
