# devtools::install_github("edzer/sfr")
library('microbenchmark')
library('rgdal')
library('sf')

old = setwd("/home/robin/repos/Creating-maps-in-R/")
f = "data"
rgdal_way = function() readOGR(dsn = f, layer = "LondonBoroughs", verbose = FALSE)
sfr_way = function() st_read(dsn = f, layer = "LondonBoroughs", quiet = TRUE)
microbenchmark(rgdal_way(), sfr_way(), times = 3)
lnd_sfr = st_read(dsn = f, layer = "LondonBoroughs", quiet = TRUE)
plot(lnd_sfr)
