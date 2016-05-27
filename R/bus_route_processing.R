# Aim: add bus routes data to zones

data_dir1 = "D://archivos shapes (V. nov15)"
z1 = "D://archivos shapes (V. nov15)/Conurbano_radios/conurbano_radios.shp"
z2 = "D://archivos shapes (V. nov15)/CABA_radio_fuenteINDEC/cabaxrdatos.shp"


list.files(data_dir)

library(raster)

z1 = shapefile(z1)
bproj = proj4string(z1)
plot(z1)
z2 = shapefile(z2)

z1 = spTransform(z1, CRSobj = bproj)
z2 = spTransform(z2, CRSobj = bproj)
z3 = spTransform(z3, bproj)
bus_r = spTransform(bus_r, bproj)

plot(z3[1:1000,])
plot(bus_r, add = T)

library(tmap)

names(z1)
names(z2)

library(dplyr)
z1@data = select(z1@data, CLAVERA)



z2@data = as.data.frame(z2$LINK)

names(z2) = names(z1)

z3 = sbind(z1, z2)

bus_r = shapefile("D://archivos shapes (V. nov15)/Conulirase_INTRUPUBA.shp")

plot(bus_r, col = "red", add = T)

bbox(bus_r)
bbox(z1)
bbox(z2)

proj4string(z3) = proj4string(bus_r)

cents = gCentroid(z3, byid = T)
cents = SpatialPointsDataFrame(cents, data = z3@data)

# create a loop for each bus route

nrow(bus_r)
plot(bus_r[1,], col = "blue")
library(rgeos)

bbuf = gBuffer(bus_r[1,], width = 300)
plot(bbuf, add = T)

# sel = cents[bbuf,] # simple selection
sel = over(cents, bbuf)
sel = !is.na(sel)

# plot(sel, add = T, col = "red")
plot(cents[sel,], add = T, col = "red")

cents$num_bus_routes = 0

cents$num_bus_routes[sel] = cents$num_bus_routes[sel] + 1

for(i in 1:nrow(bus_r)){
  bbuf = gBuffer(bus_r[i,], width = 300)
  sel = over(cents, bbuf) # selects zones in the buffer
  sel = !is.na(sel)
  cents$num_bus_routes[sel] = cents$num_bus_routes[sel] + 1
  print(i)
}


z3$num_bus_routes = cents$num_bus_routes

z3 = spTransform(z3, CRS("+init=epsg:4326"))
qtm(z3, fill = "num_bus_routes", line.col = NULL)

df1 = z3@data
newdata = inner_join(df1, z2@data)

shapefile(z3, file = "D://buenos-aires/output")



