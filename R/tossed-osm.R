# tossed locations in England
library(osmdata)
q = opq(bbox = getbb("England")) %>% 
  add_feature("name", "Tossed") %>% 
  add_feature("amenity", "fast_food")
tossed = osmdata_sf(q)
plot(tossed$osm_points )

library(tmap)
tmap_mode("view")
qtm(tossed$osm_points)
