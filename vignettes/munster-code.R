#' # Reproducible workflow for transport planning
#' 
#' ## Finding and reproducing this example
#' 
#' See https://github.com/Robinlovelace/Creating-maps-in-R/blob/master/vignettes/munster-code.md

#' How I got here: http://rpubs.com/RobinLovelace/282944
#' 
#' Context - the propensity to cycle tool:
#' http://rpubs.com/RobinLovelace/278921
#' 
#' Geographic data can save the world: 
#' http://rpubs.com/RobinLovelace/272796
#' 
#' ## Comment on 'tidy' dplyr pipes
#' 
#' See https://csgillespie.github.io/efficientR/data-carpentry.html#chaining-operations
#' 
if(!grepl(pattern = "vig", getwd()))
  old = setwd("vignettes")

# How to represent movement on a map?
o = c(5, 51)
d = c(8, 52)

sqrt((o[1] - d[1])^2 + (o[2] - d[2])^2) # what does that mean?
geosphere::distGeo(o, d)

plot(rbind(o, d))
lines(rbind(o, d))

library(stplanr)
(o = geo_code("Utrecht"))
(d = geo_code("Munster"))

#' With OSRM
# r_osrm = viaroute(startlat = o[2], startlng = o[1], endlat = d[2], endlng = d[1])
# r_sp = viaroute2sldf(r_osrm)

#' With graphhopper
# r_sp = route_graphhopper(from = o, to = d, vehicle = "bike")
# saveRDS(r_sp, "route-utrecht-munster.Rds")
r_sp = readRDS("route-utrecht-munster.Rds")
r_sf = sf::st_as_sf(r_sp)

#' ## Treatment of units
rgeos::gLength(r_sp)
(d = sf::st_length(r_sf))
units::set_units(d, km)

plot(r_sp)
plot(r_sf)
devtools::install_github("tidyverse/ggplot2")
library(ggplot2)

r_fort = fortify(r_sp)
ggplot(r_fort) + geom_path(aes(long, lat))
ggplot(r_fort) + geom_path(aes(long, lat)) + coord_map()

# with the new sf method
ggplot(r_sf) + geom_sf() # much easier!

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
sum(flow$All)
rd = od2line(flow = flow, zones = cents)
plot(rd)

# routes_fast = line2route(rd) # needs cyclestreets api key
routes_fast$All = rd$All
rnet = overline(routes_fast, attrib = "All")
plot(rnet, lwd = rnet$All / mean(flow$All))
plot(routes_fast, lwd = routes_fast$All / mean(flow$All), col = "red", add = T)

# if this fails, navigate to the following link and download manually:
# https://github.com/npct/pct-data/raw/master/liverpool-city-region/l.Rds
u_pct = "https://github.com/npct/pct-data/raw/master/liverpool-city-region/l.Rds"
if(!exists("l.Rds"))
  download.file(u_pct, "l.Rds")
library(tmap)
library(stplanr) # loads sp

## Loading required package: sp

l = readRDS("l.Rds")
tm_shape(l) + tm_lines(lwd = "all")

#' Exercise
#' Reproduce this code: http://rpubs.com/RobinLovelace/273513

#' Output the result
# knitr::spin("munster-code.R", format = "Rmd")
# setwd(old)
