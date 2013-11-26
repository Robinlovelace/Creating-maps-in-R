# qgithub question
download.file("http://www.personal.leeds.ac.uk/~georl/egs/lnd-stations-multi.zip", 
              "lnd-stations.zip")
unzip("lnd-stations.zip")
lndS <- readOGR(".", "lnd-stations", p4s = "+init=epsg:27700")

download.file("http://www.personal.leeds.ac.uk/~georl/egs/lnd-stns.zip", 
              "lnd-stns.zip")
unzip("lnd-stns.zip")
lndS <- readOGR(".", "lnd-stns", p4s = "+init=epsg:27700")
plot(lndS)


