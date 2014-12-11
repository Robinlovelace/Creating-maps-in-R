# Loading MapInfo .mid files

library(rgdal) # rgdal library
drvs <- ogrDrivers() # ogr capabilities
drvs[grep("Inf", drvs$name),] # MapInfor capability

f <- "folder/filename.mid" # filename 
l <- ogrListLayers(f) # layer name
sp_object <- readOGR(f, layer = l[[1]]) # load!