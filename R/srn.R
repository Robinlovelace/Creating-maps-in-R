# Aim: download and analyse England's strategic road network
library(tmap)
library(sp)
u = "https://www.whatdotheyknow.com/request/286920/response/707141/attach/3/HAPMS%2020150914.zip"
download.file(u, destfile = "srn.zip")
unzip("srn.zip")
srn = read_shape("Network.shp")
srn_bridges = read_shape("UnderBridges.shp")

# remove excess files
f = list.files(pattern = "Network.|Bridges.|srn.zip")
unlink(f)

# plot
tmap_mode("view")
qtm(srn)
bb(srn)
proj4string(srn) = CRS("+init=epsg:27700")
proj4string(srn_bridges) = CRS("+init=epsg:27700")
srn = spTransform(srn, CRS("+init=epsg:4326"))
srn_bridges = spTransform(srn_bridges, CRS("+init=epsg:4326"))
saveRDS(srn, "input-data/srn.Rds")
saveRDS(srn_bridges, "input-data/srn_bridges.Rds")