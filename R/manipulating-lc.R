pkgs = c("GISTools", "tmap")
lapply(pkgs, library, character.only = T)
data(tornados)
plot(torn)
plot(us_states, lty = 2)

state = us_states2[grep(pattern = "Okla|Tex|Arka", us_states2$STATE_NAME),]
plot(state, lty = 3)
sm = gUnaryUnion(state)
plot(sm, add = T, lwd = 1.5)
library(tmap)
lnd = raster::shapefile("data/london_sport.shp")
tmap_mode("view")
qtm(lnd)
plot(state)
qtm(torn)

