# Cluster points of tourist activity in Girona
library(sp)
tp <- read.csv('vignettes/data/Girona_Points.csv')
tp <- SpatialPointsDataFrame(coords=matrix(c(tp$lng , tp$lat ), ncol=2), data=tp)
plot(tp[seq(1, nrow(tp), 1000),])
library(spatstat)
library(maptools) # to convert to point pattern
sSp <- as(SpatialPoints(tp), "ppp")
# Z <- spatstat::kppm(sSp)
# plot(Z)
Dens <- density(sSp, adjust=0.2)
class(Dens)
plot(Dens)
contour(density(sSp, adjust=0.2), nlevels=4) # how many levels do you want for the contours?


Dsg <- as(Dens, "SpatialGridDataFrame")
Dim <-as.image.SpatialGridDataFrame(Dsg)
Dcl <- contourLines(Dim)
SLDF <- ContourLines2SLDF(Dcl)
proj4string(SLDF) <- proj4string(lnd) # assign correct CRS - for future steps
plot(SLDF, col=terrain.colors(8))
library(rgeos)
Polyclust <- gPolygonize(SLDF[4,]) # which contour layer do you want? (size of clusters)
gas <- gArea(Polyclust, byid=T)/10000
Polyclust <- SpatialPolygonsDataFrame(Polyclust, as.data.frame(gas), match.ID=F)
plot(Polyclust)

proj4string(tp) <- proj4string(Polyclust)
cAg <- aggregate(tp["quiz_id"], by = Polyclust, FUN=length, )
cAg$count <- cAg$quiz_id

plot(SLDF, col=terrain.colors(8), add=T)
plot(cAg, col = "red", add = T)
graphics::text(coordinates(cAg), labels = cAg$quiz_id)

class(cAg)
# rm excluded points + save
tpIn <- tp[cAg,]
head(row.names(tpOut))
tpOut <- tp[!row.names(tp) %in% row.names(tpIn),]
plot(tpOut[1:10000,])
plot(cAg, add=T)

nrow(tpIn) / nrow(tp) # points in cluster
# % area in cluster:
gArea(cAg) / as.numeric((bbox(Dsg)[1,2] - bbox(Dsg)[1,1]) * (bbox(Dsg)[2,2] - bbox(Dsg)[2,1])) 

library(rgdal)
writeOGR(cAg, "exclude/", "cluster_poly", driver="ESRI Shapefile") # save polygons
writeOGR(tpIn, "exclude/", "tpIn", driver="ESRI Shapefile") # save the points in the layer
writeOGR(tpOut, "exclude/", "tpOut", driver="ESRI Shapefile") # save the points in the layer
