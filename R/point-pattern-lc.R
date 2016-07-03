library(gstat)
?idw

zinc.idw = idw(zinc~1, meuse, meuse.grid)
spplot(zinc.idw)
# create a pixel surfacce 
tmp <- as(zinc.idw, "SpatialPixelsDataFrame")
spplot(tmp["var1.pred"], 
       main = "zinc IDW interpolation")

evgm <-variogram(zinc~1, meuse)
lzn.fit = fit.variogram(evgm, model = vgm(19000, "Sph", 900, 1))
lzn.fit
plot(evgm, lzn.fit)

lzn.kriged = krige(formula = zinc~1, locations = meuse,
                   data = meuse.grid, model = lzn.fit)
tmp <- as(lzn.kriged, "SpatialPixelsDataFrame")
spplot(tmp["var1.pred"], 
       main = "zinc Krige interpolation")

lzn.condsim = krige(log(zinc)~1, meuse, meuse.grid, model = lzn.fit,
                                            nmax = 30, nsim = 4)
lzn.condsim_ras = as(lzn.condsim, "SpatialPixelsDataFrame")
spplot(lzn.condsim_ras)
## This was produced automatically from materials by Lex Comber - see
# https://github.com/lexcomber/LexTrainingR
library(GISTools)
# load the data
data(newhaven)
# 1. Have a look at breach
class(breach)
plot(tracts)
plot(breach, add = T)
# 2. Calculate the KDE
breach.dens <- kde.points(breach,lims=tracts) 
# 3. Plot the KDE
# with a level plot 
level.plot(breach.dens)
# 4. Clip the plot
# use the 'masking' function 
masker <- poly.outer(breach.dens,tracts,extend=100) 
add.masking(masker)
# Add the census tracts 
plot(tracts,add=TRUE)

## ---- eval=F-------------------------------------------------------------
## par(mfrow = c(nrows, ncols))

## ---- eval=T, message=F--------------------------------------------------
library(sp)
library(gstat)
data(meuse)
head(meuse)
dim(meuse)
# only 155 data points
# conver to SPDF
coordinates(meuse) <- ~x+y
plot(meuse)

## ---- eval=T, message=F--------------------------------------------------
data(meuse.grid)
head(meuse.grid)
dim(meuse.grid)
# 3103 data points
# conver to SPDF
coordinates(meuse.grid) <- ~x+y
plot(meuse.grid)

## ---- eval=T, message=F--------------------------------------------------
library(gstat)
?idw

## ---- eval=T, message=F--------------------------------------------------
zinc.idw = idw(zinc~1, meuse, meuse.grid)
# create a pixel surfacce 
tmp <- as(zinc.idw, "SpatialPixelsDataFrame")
spplot(tmp["var1.pred"], 
       main = "zinc IDW interpolation")

## ---- eval=T, message=F--------------------------------------------------
evgm <-variogram(zinc~1,meuse)
lzn.fit = fit.variogram(evgm, model = vgm(150000, "Sph", 900, 1))
lzn.fit
plot(evgm, lzn.fit)

## ---- eval=T, message=F--------------------------------------------------
lzn.kriged = krige(zinc~1, meuse, meuse.grid, model = lzn.fit)
tmp <- as(lzn.kriged, "SpatialPixelsDataFrame")
spplot(tmp["var1.pred"], 
       main = "zinc Krige interpolation")

## ---- eval=T, message=F--------------------------------------------------
spplot(tmp["var1.var"], 
       main = "zinc Krige variance")

## ---- eval=T-------------------------------------------------------------
# R Kernel Density comparison
require(GISTools)
data(newhaven)
# Set up parameters to create two plots side by side
# with 2 line margin at the top, no other margins
par(mfrow=c(1,2),mar=c(0,0,2,0))
# Part 1. KDE for forced entry
brf.dens <- kde.points(burgres.f,lims=tracts) 
level.plot(brf.dens)
# Use ‘masking’ as before
masker <- poly.outer(brf.dens,tracts,extend=100) 
add.masking(masker)
plot(tracts,add=TRUE)
# Add a title
title("Forced Burglaries")

# Part 2. KDE for non-forced entry 
brn.dens <- kde.points(burgres.n,lims=tracts) 
level.plot(brn.dens)
# Use ‘masking’ as before
masker <- poly.outer(brn.dens,tracts,extend=100) 
add.masking(masker)
plot(tracts,add=TRUE)
# Add a title
title("Non-Forced Burglaries") 
# reset par(mfrow) 
par(mfrow=c(1,1))

