library(rgeos)
plot(lnd, col = "grey")
cent_lnd <- gCentroid(lnd)
points(cent_lnd, cex = 3)
lnd_buffer <- gBuffer(spgeom = cent_lnd, width = 10000) # set 10 km buffer
lnd_central <- lnd[lnd_buffer,]
lnd_cents <- SpatialPoints(coordinates(lnd),  proj4string = CRS(proj4string(lnd)))
sel <- lnd_cents[lnd_buffer,]
lnd_central <- lnd[sel,]
plot(lnd_central, add = T, col = "red")
plot(lnd_buffer, add = T, col = "white")
text(coordinates(cent_lnd), "Middle Earth")
