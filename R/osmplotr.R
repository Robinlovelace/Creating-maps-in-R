# Aim: test osmplotr's capabilities
# devtools::install_github("mpadge/osmplotr")
library(osmplotr)
# withr::with_libpaths("D:/R/Rlibs",
#                      devtools::install_github("hrbrmstr/overpass"))
library(overpass)
library(tmap)

b = bb("Hackney, London", ext = 2)
b = as.vector(b)
class(b)

h = extract_osm_objects(key = "highway", bbox =  b)
summary(h)

# download the cycleways/cyclable routes
hc = extract_osm_objects(key = "highway", value = "cycleway", bbox = b)
hb = extract_osm_objects(key = "highway", value = "yes", bbox = b)
# hlcn = extract_osm_objects(bbox =  b, extra_pairs = c("network", "ncn")) # failed
?opq
overpass::opq()
q = '[out:xml];
 (node["network"="lcn"](51.523240,-0.069362,51.563240,-0.029362);
  way["network"="lcn"](51.523240,-0.069362,51.563240,-0.029362);
  relation["network"="lcn"](51.523240,-0.069362,51.563240,-0.029362););
(._;>;);
out;'
lnd = overpass_query(q)

hlcn9 = extract_osm_objects(key = "highway", bbox =  b, extra_pairs = c("lcn_ref", "9"))
hlcna = extract_osm_objects(key = "highway", bbox =  b, extra_pairs = c("Cycle Route", "London Cycle Network Route 9"))

plot(h)
plot(hb, add = T, col = "red", lwd = 1)
plot(hc, add = T, col = "red", lwd = 2)
plot(hlcn, add = T, col = "green", lwd = 3)
plot(lnd, add = T, col = "green", lwd = 3)

library(geojsonio)
geojson_write(hc, file = "data/hackney-cycleway.geojson")
geojson_write(lnd, file = "data/lcn-cycleway.geojson")

# # Example from GitHub
# bbox = c(-0.15,51.5,-0.1,51.52) 
# structures = c ('highway', 'highway', 'building', 'building', 'building',
#                  'amenity', 'grass', 'park', 'natural', 'tree')   
# structs = osm_structures (structures=structures, col_scheme='dark')   
# structs$value [1] = '!primary'   
# structs$value [2] = 'primary'
# structs$suffix [2] = 'HP'
# structs$value [3] = '!residential'
# structs$value [4] = 'residential'
# structs$value [5] = 'commercial'
# structs$suffix [3] = 'BNR'
# structs$suffix [4] = 'BR'
# structs$suffix [5] = 'BC'
# 
# # Then download the corresponding data, noting that extract_osm_objects returns two components: warn containing any warnings generated during download, and obj containing the appropriate spatial object.
# 
# london = list ()
# for (i in 1:(nrow (structs) - 1)) 
# {
#   dat = extract_osm_objects (key=structs$key [i], value=structs$value [i],
#                               bbox=bbox)
#   if (!is.null (dat$warn))
#     warning (dat$warn)
#   fname = paste0 ('dat_', structs$suffix [i])
#   assign (fname, dat)
#   london [[i]] = get (fname)
#   names (london)[i] = fname
#   rm (list=c(fname))
# }
# 
# # And finally the additional data for specific buildings and highways (ignoring potential warnings this time).
# 
# extra_pairs = c ('name', 'Royal.Festival.Hall')
# london$dat_RFH = extract_osm_objects (key='building', extra_pairs=extra_pairs, 
#                                        bbox=bbox)
# extra_pairs = list (c ('addr:street', 'Stamford.St'),
#                      c ('addr:housenumber', '150'))
# london$dat_ST = extract_osm_objects (key='building', extra_pairs=extra_pairs, 
#                                       bbox=bbox)
# highways = c ('Kingsway', 'Holborn', 'Farringdon.St', 'Strand',
#                'Fleet.St', 'Aldwych')
# london$highways1 = highways2polygon (highways=highways, bbox=bbox)
# highways = c ('Queen.s.Walk', 'Blackfriars', 'Waterloo', 'The.Cut')
# london$highways2 = highways2polygon (highways=highways, bbox=bbox)
# highways = c ('Regent.St', 'Oxford.St', 'Shaftesbury')
# london$highways3 = highways2polygon (highways=highways, bbox=bbox)
# 
# plotting
# library(maptools)
# indx = which (!london$dat_BR$id %in% london$dat_BNR$id)
# dat_B = spRbind (london$dat_BR [indx,], london$dat_BNR)
# indx = which (!london$dat_H$id %in% london$dat_HP$id)
# dat_H = spRbind (london$dat_H [indx,], london$dat_HP)
# dat_T = london$dat_T
# 
# # Specify the bounding box for the desired region
# 
# bbox = c(-0.15,51.5,-0.1,51.52)
# 
# # Download the desired data---in this case, all building perimeters.
# 
# dat_B = extract_osm_objects (key="building", bbox=bbox)
# 
# # Initiate an osm_basemap with desired background (bg) colour
# 
# plot_osm_basemap (xylims=get_xylims (bbox), bg="gray20", file="map1.png")
# 
# graphics.off ()
# 
# Add desired plotting objects in the desired colour.
# 
# add_osm_objects (dat_B, col="gray40")
# 
# # this works
# plot_osm_basemap (xylims=get_xylims (bbox), bg="gray20")
# add_osm_objects (dat_B, col="gray40")

#