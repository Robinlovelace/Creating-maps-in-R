# Reproducible workflow for transport planning

# How to represent movement on a map?
o = c(5, 51)
d = c(8, 52)

plot(rbind(o, d))
lines(rbind(o, d))

library(stplanr)
(o = geo_code("Utrecht"))
(d = geo_code("Munster"))

r_osrm = viaroute(startlat = o[2], startlng = o[1], endlat = d[2], endlng = d[1])
r_sp = viaroute2sldf(r_osrm)

plot(r_sp)

library(tmap)
r_bb = tmaptools::bb(r_sp, 2)
data("Europe")
qtm(Europe) +
  qtm(r_sp)
# try with tmap_mode("view")

# Scaling up the solution to many trips with stplanr
# See the stplanr intro vignette:
# https://cran.r-project.org/web/packages/stplanr/vignettes/introducing-stplanr.html
head(cents)
head(flow)
rd = od2line(flow = flow, zones = cents)
plot(rd)


