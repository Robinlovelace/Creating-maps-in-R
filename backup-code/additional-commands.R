### Additional commands
plot(lnd[1:5, ])
head(lnd@data)
library(classInt)
??classInt
i1 <- classIntervals(var = lnd$station.count, n = 4, style = "jenks")
?findColours

library(RColorBrewer)

pal <- brewer.pal(5, "Reds")
cols1 <- findColours(i1, pal)
plot(lnd, col = cols1)

lnd@polygons[3]
lnd@polygons[3][1]
getClass("Spatial")
class(lnd)
getClass("SpatialPolygonsDataFrame")