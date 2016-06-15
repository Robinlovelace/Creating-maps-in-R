load("data/lnd.RData")
library(raster)

r = raster(nrow = 50, ncol = 50, ext = extent(lnd))
lnd_raster = rasterize(lnd, r)
class(lnd_raster)
plot(lnd_raster)
