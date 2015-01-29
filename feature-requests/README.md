# Extending R's spatial capabilities

R's spatial packages open up a huge variety of functions for spatial data analysis.
R's flexibility means that users can create their own custom functions to solve problems that are insoluble using existing commands.

However, there is still much scope for creating new packages that make life
easier for people doing spatial analysis in R. Below are just a few examples of
tested functions, function ideas and research areas that could be useful for
enhancing R's reputation as a leading command-line GIS.

## Tested functions

- [gClip()](http://robinlovelace.net/r/2014/07/29/clipping-with-r.html), for clipping the spatial extent of one object by another:

```
lib <- c("maptools", "rgdal", "rgeos", "raster")
lapply(lib, library, character.only = T)
gClip <- function(shp, bb){
  if(class(bb) == "matrix") b_poly <- as(extent(as.vector(t(bb))), "SpatialPolygons")
  else b_poly <- as(extent(bb), "SpatialPolygons")
  gIntersection(shp, b_poly, byid = T)
}
```

- [gSnap()](http://gis.stackexchange.com/questions/121722/how-can-i-snap-one-set-of-points-to-another-in-r/121726#121726), for snapping one set of points to their nearest neighbour in another set of points.

## Funtion ideas

- get_osm_buildings(), a wrapper around [get_osm()](http://rpackages.ianhowson.com/rforge/osmar/man/get_osm.html) to extract data from Open Street Map and output the result in a user-friendly format such as SpatialPolygonsDataFrame.

- pAggregate(), a function to convert attribute data from one set of polygons to another, based on area.

- get_bingmap(), a ggmap function akin to [get_googlemap](http://www.inside-r.org/packages/cran/ggmap/docs/get_googlemap) for downloading bing maps.



