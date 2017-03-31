## Code authored by Jamie Owen <jamie[at]jumpingrivers.com
## during Robin Lovelace Spatial R course for fun challenge in 
## London to find all branches of chosen lunch location

library(rvest)
library(leaflet)
library(ggmap)
library(magrittr)
library(dplyr)

tossed = read_html("http://tosseduk.com/stores/")

pcodes = tossed %>% html_nodes("span.bold") %>% html_text()
pcodes = pcodes[!grepl("Store",pcodes)]
longlat = geocode(pcodes)

#### which one is nearest?
locations = tossed %>% 
  html_nodes(".store-details") %>% 
  html_nodes("h3") %>% html_text()

locations %<>% 
  data.frame("Location" = ., "PostCode" = pcodes, 
             "miles" = mapdist("senate house london", to = pcodes)$miles,
             "lon" = longlat$lon, "lat" = longlat$lat)

locations %>% summarise(max(miles),mean(miles),min(miles))

leaflet(locations) %>% 
  addTiles() %>% 
  addMarkers(~lon,~lat,label = ~Location,
             popup = ~paste0(round(miles,2)," from senate house."))